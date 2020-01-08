//
//  VideoPlayerController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-22.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

struct VideoAction {
    enum ActionType {
        case skip(from: Int, to: Int)
        case nextEpisode(from: Int)
    }
    
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
    
    private var stops: [(VideoAction, SkipButton)] = []
    
    init(film: Film, settings: Settings) {
        self.film = film
        self.settings = settings
        self.nextEpisodeProvider = NextEpisodeNetworkProvider(settings: settings) // TODO: inject
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
        setUpPlayer(url: film.URL)
        setActions()
        overrideVolumeBar()
        
        fetchVideoInfo()  // TODO: Implement `VideoInfoDataProvider`
    }
    
    private func fetchVideoInfo() {
        let info = [
            VideoAction(name: "Skip intro", action: .skip(from: 128, to: 158)),
            VideoAction(name: "Next Episode", action: .nextEpisode(from: 1295))
        ];
        
        stops = info.map { videoAction in
            let button = SkipButton(parentView: view, buttonText: videoAction.name)
            button.attachAction { [weak self] in
                guard let self = self else { return }
                
                switch videoAction.action {
                case let .skip(from: _, to: to):
                    self.mediaPlayer.position = Float(to)/Float(self.mediaPlayer.totalDuration)
                case .nextEpisode(from: _):
                    button.animateHide()
                    self.playNextEpisode()
                }

            }
            
            return (videoAction, button)
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
    
    private func setUpPlayer(url: String) {
        let streamURL = URL(string: url)!
        let vlcMedia = VLCMedia(url: streamURL)
        
        mediaPlayer.media = vlcMedia
        mediaPlayer.drawable = videoPlayerView.mediaView
        
        mediaPlayer.play()
        playState = .playing
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
    
    @objc func playNextEpisode() {
        videoPlayerView.nextEpisodeButton.isEnabled = false
        
        nextEpisodeProvider.getNextEpisode(episodeId: film.id, result: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(newFilm):
                self.stateMachine.transitionTo(state: .initial)
                self.mediaPlayer.stop()
                self.setUpPlayer(url: newFilm.URL)
                self.videoPlayerView.titleLabel.text = newFilm.title
                self.film = newFilm
            case let .failure(error):
                print("Error occurred! \(error)") // TODO: Display alert
            }
            
            self.videoPlayerView.nextEpisodeButton.isEnabled = true
        })
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
        stops.forEach { (videoInfo, button) in
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
