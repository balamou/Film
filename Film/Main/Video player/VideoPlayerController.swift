//
//  VideoPlayerController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-22.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class VideoPlayerController: UIViewController {

    var volumeController: VolumeController?
    var videoPlayerView: VideoPlayerView!
    
    private var stateMachine: VideoPlayerStateMachine!
    private var bufferingManager: BufferingManager!
    private var sliderAction: VideoPlayerSliderAction!
    private var playState: PlayState = .playing
    
    private let mediaPlayer = VLCMediaPlayer()
    private let film: Film
    
    private let backwardTime: Int32 = 10
    private let forwardTime: Int32 = 10
    
    init(film: Film) {
        self.film = film
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
        
        view = videoPlayerView
        
        setupPlayerHelpers()
        setUpPlayer(url: film.URL)
        setActions()
        overrideVolumeBar()
    }
    
    override func viewDidLayoutSubviews() {
        videoPlayerView.didAppear()
    }
    
    func setupPlayerHelpers() {
        sliderAction = VideoPlayerSliderAction(view: videoPlayerView, mediaPlayer: mediaPlayer)
        sliderAction.delegate = self
        
        bufferingManager = BufferingManager(mediaPlayer: mediaPlayer)
        bufferingManager.delegate = self
        
        stateMachine = VideoPlayerStateMachine(view: videoPlayerView)
    }
    
    func setUpPlayer(url: String) {
        let streamURL = URL(string: url)!
        let vlcMedia = VLCMedia(url: streamURL)
        
        mediaPlayer.media = vlcMedia
        mediaPlayer.drawable = videoPlayerView.mediaView
        
        mediaPlayer.play()
    }
    
    //----------------------------------------------------------------------
    // MARK: Actions
    //----------------------------------------------------------------------
    func setActions() {
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
        guard stateMachine.canTapToShowHideControls else { return }
        stateMachine.showControls(playState: playState)
    }
    
    @objc func hideControls() {
        guard stateMachine.canTapToShowHideControls else { return }
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
        }
        
        stateMachine.transitionTo(state: .shown(playState))
    }
    
    @objc func rewindForward() {
        mediaPlayer.jumpForward(forwardTime)
    }
    
    @objc func rewindBack() {
        mediaPlayer.jumpBackward(backwardTime)
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
        print("Close video")
        navigationController?.popViewController(animated: false)
    }
    
    @objc func playNextEpisode() {
        print("Next episode")
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
        return self.isStatusBarHidden
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
        print("STARTED BUFFERING")
    }
    
    func endedBuffering() {
        stateMachine.doneBuffering(playState: playState)
        print("DONE BUFFERING")
    }
    
}

extension VideoPlayerController: VideoPlayerSliderActionDelegate {
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
