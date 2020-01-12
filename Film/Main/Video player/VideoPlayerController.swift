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
    
    private let nextEpisodeProvider: NextEpisodeNetworkProvider
    private let settings: Settings
    
    private var skipForwardAnimation: AnimationManager!
    private var skipBackwardAnimation: AnimationManager!
    
    private var timestamps: [(VideoTimestamp, SkipButton)] = []
    private var timestampsProvider: TimestampsDataProvider
    
    private let videoProvider: VideoURLProvider
    private let viewedContentManager: ViewedContentManager
    private var viewingContent: ViewedContent?
    
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
        
        videoPlayerView = VideoPlayerView(frame: view.frame)
        videoPlayerView.titleLabel.text = film.title
        if film.type == .movie {
            videoPlayerView.nextEpisodeButton.isEnabled = false
            videoPlayerView.nextEpisodeButton.setTitleColor(.gray, for: .disabled)
        }
        
        view = videoPlayerView
        
        setupPlayerHelpers()
        fetchVideoURL()
        setActions()
        overrideVolumeBar()
        
        fetchVideoTimestamps()
    }
    
    private func fetchVideoTimestamps() {
        guard case .show = film.type else { return } // TODO: implement movie timestamps provider
        
        timestampsProvider.getEpisodeTimestamps(episodeId: film.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(videoTimestamps):
                self.timestamps = self.processTimestamps(timestamps: videoTimestamps)
                print(videoTimestamps)
            case let .failure(error):
                self.timestamps = []
                print(error) // TODO: show alert perhaps?
            }
            
        }
    }
    
    private func processTimestamps(timestamps: [VideoTimestamp]) -> [(VideoTimestamp, SkipButton)] {
        return timestamps.map { videoTimestamp in
            let button = SkipButton(parentView: view, buttonText: videoTimestamp.name)
            button.attachAction { [weak self] skipButton in
                guard let self = self else { return }
                
                switch videoTimestamp.action {
                case let .skip(from: _, to: to):
                    self.mediaPlayer.position = Float(to)/Float(self.mediaPlayer.totalDuration)
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
        videoPlayerView.pausePlayButton.addTarget(self, action: #selector(pausePlayButtonPressed(sender:)), for: .touchUpInside)
        
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
    
    @objc func pausePlayButtonPressed(sender: UIButton) {
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
    
    //----------------------------------------------------------------------
    // Orientation: Landscape
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
    // Status bar
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
        guard let viewingContent = viewingContent else { return } // TODO: Log as inconsistency
        
        viewedContentManager.update(viewingContent: viewingContent, with: position)
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

extension VideoPlayerController {
    
    @objc func playNextEpisode() {
        videoPlayerView.nextEpisodeButton.isEnabled = false
        
        nextEpisodeProvider.getNextEpisode(episodeId: film.id, result: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(newFilm):
                self.film = newFilm
                self.timestamps = [] // clear timestamps from previous video
                self.fetchVideoTimestamps()
                self.stateMachine.transitionTo(state: .initial)
                self.mediaPlayer.stop()
                self.videoPlayerView.titleLabel.text = newFilm.title
                
                self.fetchVideoURL()
            case let .failure(error):
                print("Error occurred! \(error)") // TODO: Exit
            }
            
            self.videoPlayerView.nextEpisodeButton.isEnabled = true
        })
    }
    
    func fetchVideoURL() {
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
                self.viewingContent = self.viewedContentManager.findEpisode(by: data.id, orAdd: value)
                
                let stoppedAt = self.viewingContent!.stoppedAt
                self.setUpPlayer(url: data.videoURL, stoppedAt: stoppedAt)
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
                self.viewingContent = self.viewedContentManager.findMovie(by: data.id, orAdd: value)
                
                 let stoppedAt = self.viewingContent!.stoppedAt
                self.setUpPlayer(url: data.videoURL, stoppedAt: stoppedAt)
            case let .failure(error):
                print(error) // TODO: show alert & exit
            }
        }
    }
    
}
