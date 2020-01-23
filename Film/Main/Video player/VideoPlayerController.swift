//
//  VideoPlayerController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-22.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

enum ActionType {
    case skip(from: Int, to: Int)
    case nextEpisode(from: Int)
}

struct VideoTimestamp: Decodable {
    /// Custom string displayed on the label.
    /// Examples include: `Skip intro`, `Skip to end scene` or `Next episode`
    let name: String
    let action: ActionType
}

class VideoPlayerController: UIViewController {

    var volumeController: VolumeController?
    var videoPlayerView: VideoPlayerView!
    
    private var stateMachine: VideoPlayerStateMachine!
    private var bufferingManager: BufferingManager!
    private var sliderAction: VideoPlayerSliderAction!
    private var playState: PlayState = .playing
    
    private let mediaPlayer = VLCMediaPlayer()
    private var film: Film
    
    private let backwardTime: Int32 = 10
    private let forwardTime: Int32 = 10
    private let playNextEpisodeAfterWatchingPercentage: Float = 0.95
    
    private let nextEpisodeProvider: NextEpisodeNetworkProvider
    private let settings: Settings
    
    private var skipForwardAnimation: AnimationManager!
    private var skipBackwardAnimation: AnimationManager!
    
    private var timestamps: [(VideoTimestamp, SkipButton)] = []
    private var timestampsProvider: TimestampsDataProvider
    
    private let videoProvider: VideoURLProvider
    private let viewedContentManager: ViewedContentManager
    
    init(film: Film, settings: Settings, viewedContentManager: ViewedContentManager) {
        self.film = film
        self.settings = settings
        self.nextEpisodeProvider = NextEpisodeNetworkProvider(settings: settings) // TODO: inject
        self.timestampsProvider = TimestampsNetworkProvider(settings: settings) // TODO: inject
        self.videoProvider = VideoURLNetworkProvider(settings: settings) // TODO: inject
        self.viewedContentManager = viewedContentManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forceLandscapeOrientation()
        setupView()
        setupPlayerHelpers()
        fetchVideoURL()
        setActions()
        overrideVolumeBar()
    }
    
    //----------------------------------------------------------------------
    // MARK: Setup
    //----------------------------------------------------------------------
    private func setupView() {
        videoPlayerView = VideoPlayerView(frame: view.frame)
        videoPlayerView.titleLabel.text = film.title
        if film.type == .movie {
            videoPlayerView.nextEpisodeButton.isEnabled = false
            videoPlayerView.nextEpisodeButton.setTitleColor(.gray, for: .disabled)
        }
        
        view = videoPlayerView
    }
    
    private func processTimestamps(timestamps: [VideoTimestamp]) -> [(VideoTimestamp, SkipButton)] {
        return timestamps.map { videoTimestamp in
            let button = SkipButton(parentView: view, buttonText: videoTimestamp.name.localize())
            button.attachAction { [weak self] skipButton in
                guard let self = self else { return }
                
                switch videoTimestamp.action {
                case let .skip(from: _, to: to):
                    let position = Float(to)/Float(self.mediaPlayer.totalDuration)
                    self.mediaPlayer.position = position
                    self.videoPlayerView.slider.value = position
                case .nextEpisode(from: _):
                    skipButton.animateHide()
                    self.playNextEpisode()
                }
            }
            
            return (videoTimestamp, button)
        }
    }
    
    override func viewDidLayoutSubviews() {
        videoPlayerView.didAppear()
    }
    
    private func setupPlayerHelpers() {
        sliderAction = VideoPlayerSliderAction(view: videoPlayerView, mediaPlayer: mediaPlayer)
        sliderAction.delegate = self
        
        bufferingManager = BufferingManager(mediaPlayer: mediaPlayer)
        bufferingManager.delegate = self
        
        stateMachine = VideoPlayerStateMachine(view: videoPlayerView)
        
        skipForwardAnimation = AnimationManager(view, button: videoPlayerView.forward10sButton, label: videoPlayerView.forward10sLabel, animationDirection: .forward)
        skipBackwardAnimation = AnimationManager(view, button: videoPlayerView.backward10sButton, label: videoPlayerView.backward10sLabel, animationDirection: .backward)
    }
    
    private func setUpPlayer(url: String, stoppedAt: Float) {
        guard let streamURL = URL(string: url) else {
            print("Error reading the URL") // TODO: exit & alert
            return
        }
        videoPlayerView.titleLabel.text = film.title
        
        let vlcMedia = VLCMedia(url: streamURL)
        
        vlcMedia.addOptions(["network-caching": 500])
        mediaPlayer.media = vlcMedia
        mediaPlayer.drawable = videoPlayerView.mediaView
        
        mediaPlayer.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { // update 0.5 seconds later to let the media load the video
            self.mediaPlayer.position = stoppedAt
            self.playState = .playing
            self.videoPlayerView.slider.value = stoppedAt
        })
    }
    
    //----------------------------------------------------------------------
    // MARK: Actions
    //----------------------------------------------------------------------
    private func setActions() {
        videoPlayerView.pausePlayButton.addTarget(self, action: #selector(pausePlayButtonPressed), for: .touchUpInside)
        
        let tapToShowControls = UITapGestureRecognizer(target: self, action: #selector(showControls))
        tapToShowControls.numberOfTapsRequired = 1
        videoPlayerView.mediaView.addGestureRecognizer(tapToShowControls)
        
        let tapToHideControls = UITapGestureRecognizer(target: self, action: #selector(hideControls))
        tapToHideControls.numberOfTapsRequired = 1
        videoPlayerView.controlView.addGestureRecognizer(tapToHideControls)
        
        videoPlayerView.forward10sButton.addTarget(self, action: #selector(rewindForward), for: .touchUpInside)
        videoPlayerView.backward10sButton.addTarget(self, action: #selector(rewindBack), for: .touchUpInside)
        
        videoPlayerView.closeButton.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        videoPlayerView.nextEpisodeButton.addTarget(self, action: #selector(playNextEpisode), for: .touchUpInside)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        videoPlayerView.mediaView.addGestureRecognizer(doubleTap)
        
        tapToShowControls.require(toFail: doubleTap)
        
        videoPlayerView.audioAndSubtitles.addTarget(self, action: #selector(audioAndSubtitlesTapped), for: .touchUpInside)
    }
    
    
    //----------------------------------------------------------------------
    // Actions: Controls
    //----------------------------------------------------------------------
    @objc func showControls() {
        stateMachine.showControls(playState: playState)
    }
    
    @objc func hideControls() {
        stateMachine.hideControls()
    }
    
    @objc func pausePlayButtonPressed() {
        switch playState {
        case .playing:
            mediaPlayer.pause()
            playState = .paused
            
        case .paused:
            mediaPlayer.play()
            playState = .playing
            shortVibration()
        }
        
        print(mediaPlayer.currentPositionInSeconds)
        
        stateMachine.transitionTo(state: .shown(playState))
    }
    
    private func shortVibration() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    @objc func rewindForward() {
        mediaPlayer.jumpForward(forwardTime)
        skipForwardAnimation.animate()
    }
    
    @objc func rewindBack() {
        mediaPlayer.jumpBackward(backwardTime)
        skipBackwardAnimation.animate()
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        guard stateMachine.canDoubleTap else { return }
        
        let location = sender.location(in: view)
        let percentage = location.x/view.frame.width
        if percentage < 0.5 {
            rewindBack()
        } else {
            rewindForward()
        }
    }
    
    @objc func closeVideo() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func audioAndSubtitlesTapped() {
        if case .playing = playState {
            pausePlayButtonPressed() // Pause
        }
        
        videoPlayerView.audioAndSubtitlesView.show()
        videoPlayerView.audioAndSubtitlesView.setup(with: mediaPlayer)
    }
    
    //----------------------------------------------------------------------
    // MARK: Orientation
    //----------------------------------------------------------------------
    func forceLandscapeOrientation() {
        let landscapeRight = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(landscapeRight, forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    var isStatusBarHidden = false
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //----------------------------------------------------------------------
    // MARK: Removing observers/pointers
    //----------------------------------------------------------------------
    deinit {
        print("Remove Observers: Deinit")
        mediaPlayer.stop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mediaPlayer.stop()
        resetOrientation()
    }
    
    private func resetOrientation() {
        guard isMovingFromParent else {
            return
        }
        
        let portrait = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(portrait, forKey: "orientation")
    }
}

//----------------------------------------------------------------------
// MARK: Buffering
//----------------------------------------------------------------------
extension VideoPlayerController: BufferingDelegate {
    
    func startedBuffering() {
        stateMachine.startedBuffering()
        
        if Debugger.Player.printBufferingState {
            print("STARTED BUFFERING")
        }
    }
    
    func endedBuffering() {
        stateMachine.doneBuffering(playState: playState)
        
        if Debugger.Player.printBufferingState {
            print("DONE BUFFERING")
        }
    }
    
}

extension VideoPlayerController: VideoPlayerSliderActionDelegate {
    func observeCurrentTime(percentagePlayed: Float, totalDuration: Int) {
    }
    
    func observeSecondsChange(currentTimeSeconds: Int) {
        updateViewedContent(position: currentTimeSeconds)
        
        guard stateMachine.shouldShowTimestamps else { return }
        
        timestamps.forEach { (videoInfo, button) in
            switch videoInfo.action {
            case let .skip(from: from, to: to):
                if currentTimeSeconds >= from && currentTimeSeconds < to {
                    button.animateShow()
                } else {
                    button.animateHide()
                }
            case let .nextEpisode(from: from):
                if currentTimeSeconds >= from {
                    button.animateShow()
                } else {
                    button.animateHide()
                }
            }
        }
    }
    
    private func updateViewedContent(position: Int) {
        viewedContentManager.update(id: film.id, type: film.type, with: position)
        viewedContentManager.save()
    }
    
    func didStartScrolling() {
        stateMachine.transitionTo(state: .scrolling)
    }
    
    func didEndScrolling() {
        stateMachine.transitionTo(state: .shown(playState))
    }
}


//----------------------------------------------------------------------
// MARK: Application Life Cycle
//----------------------------------------------------------------------

extension VideoPlayerController {
    
    // When leaving the app
    func applicationWillResignActive() {
        mediaPlayer.pause()
        playState = .paused
        stateMachine.transitionTo(state: .shown(playState))
        
        isStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func applicationDidBecomeActive() {
        if let _ = navigationController { // re-rotate only if on the navigation stack
            forceLandscapeOrientation()
        }
    }
}

//----------------------------------------------------------------------
// MARK: Network Fetching
//----------------------------------------------------------------------
extension VideoPlayerController {
    
    /// duration is the video duration in seconds
    private func fetchVideoTimestamps(duration: Int) {
        guard case .show = film.type else { return } // TODO: implement movie timestamps provider
        
        timestampsProvider.getEpisodeTimestamps(episodeId: film.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case var .success(videoTimestamps):
                videoTimestamps = self.addNextEpisodeTimestamp(videoTimestamps: videoTimestamps, duration: duration)
                self.timestamps = self.processTimestamps(timestamps: videoTimestamps)
            case let .failure(error):
                let videoTimestamps = self.addNextEpisodeTimestamp(videoTimestamps: [], duration: duration)
                self.timestamps = self.processTimestamps(timestamps: videoTimestamps)
                print(error) // TODO: show alert perhaps? (Not critical)
            }
        }
    }
    
    private func addNextEpisodeTimestamp(videoTimestamps: [VideoTimestamp], duration: Int) -> [VideoTimestamp] {
        let doesHaveNextEpisode = videoTimestamps.contains { timestamp in
            switch timestamp.action {
            case .nextEpisode:
                return true
            default:
                return false
            }
        }
        
        guard doesHaveNextEpisode else {
            let from = Int(Float(duration) * playNextEpisodeAfterWatchingPercentage)
            let timestamp = VideoTimestamp(name: "Next episode".localize(), action: .nextEpisode(from: from))
            return videoTimestamps + [timestamp]
        }
        
        return videoTimestamps
    }
    
    @objc func playNextEpisode() {
        videoPlayerView.nextEpisodeButton.isEnabled = false
        
        nextEpisodeProvider.getNextEpisode(episodeId: film.id, result: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(nextEpisodeResult):
                switch nextEpisodeResult {
                case let .film(newFilm):
                    self.film = newFilm
                    self.clearTimestamps()
                    self.stateMachine.transitionTo(state: .initial)
                    self.mediaPlayer.stop()
                    self.videoPlayerView.titleLabel.text = newFilm.title
                    
                    self.fetchVideoURL()
                case .noMoreEpisodes:
                    self.showTheEnd()
                }
            case let .failure(error):
                print("Error occurred! \(error)") // TODO: Exit
            }
            
            self.videoPlayerView.nextEpisodeButton.isEnabled = true
        })
    }
    
    private func clearTimestamps() {
        timestamps.forEach { (_, button) in
            button.removeFromSuperview()
        }
        
        timestamps = [] // clear timestamps from previous video
    }
    
    private func showTheEnd() {
        mediaPlayer.stop()
        
        // UI
        let redEndView = UIView(frame: videoPlayerView.controlView.frame)
        redEndView.backgroundColor = .black
        
        let theEnd = UILabel()
        theEnd.text = "The end".localize()
        theEnd.textColor = .white
        
        // Position
        redEndView.addSubviewLayout(theEnd)
        
        theEnd.centerXAnchor.constraint(equalTo: redEndView.centerXAnchor).isActive = true
        theEnd.centerYAnchor.constraint(equalTo: redEndView.centerYAnchor).isActive = true

        let tapToShowControls = UITapGestureRecognizer(target: self, action: #selector(showControls))
        redEndView.addGestureRecognizer(tapToShowControls)
        
        view.insertSubview(redEndView, belowSubview: videoPlayerView.controlView)
    }
    
    private func fetchVideoURL() {
        switch film.type {
        case .movie:
            fetchMovieData()
        case .show:
            fetchEpisodeData()
        }
    }
    
    private func fetchEpisodeData() {
        videoProvider.getEpisodeData(id: film.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                let title = self.titleFromEpisode(title: data.episodeTitle, seasonNumber: data.seasonNumber, episodeNumber: data.episodeNumber)
                self.film = Film(id: data.id, type: .show, URL: data.videoURL, title: title)
                
                let contentID: ViewedContent.ContentID = .episode(id: data.id, showId: data.showId, seasonNumber: data.seasonNumber, episodeNumber: data.episodeNumber)
                let value = ViewedContent(id: contentID, title: data.showTitle, lastPlayedTime: Date().timeIntervalSince1970, position: 0, duration: data.duration)
                let viewingContent = self.viewedContentManager.addEpisodeIfNotAdded(id: data.id, value: value)
                
                let stoppedAt = viewingContent.stoppedAt
                self.setUpPlayer(url: data.videoURL, stoppedAt: stoppedAt)
 
                self.fetchVideoTimestamps(duration: data.duration)
            case let .failure(error):
                print(error) // TODO: show alert & exit
            }
        }
    }
    
    private func titleFromEpisode(title: String?, seasonNumber: Int, episodeNumber: Int) -> String {
        let notitle = "No title".localize()
        let newTitle = title ?? notitle
      
        return "S\(seasonNumber):E\(episodeNumber) \"\(newTitle)\""
    }
    
    private func fetchMovieData() {
        videoProvider.getMovieData(id: film.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                self.film = Film(id: data.id, type: .movie, URL: data.videoURL, title: data.title)
                
                let value = ViewedContent(id: .movie(id: data.id), title: data.title, lastPlayedTime: Date().timeIntervalSince1970, position: 0, duration: data.duration)
                let viewingContent = self.viewedContentManager.addMovieIfNotAdded(id: data.id, value: value)
                
                let stoppedAt = viewingContent.stoppedAt
                self.setUpPlayer(url: data.videoURL, stoppedAt: stoppedAt)
            case let .failure(error):
                print(error) // TODO: show alert & exit
            }
        }
    }
    
}
