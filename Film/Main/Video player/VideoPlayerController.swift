//
//  VideoPlayerController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-22.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class VideoPlayerController: UIViewController, VLCMediaPlayerDelegate {

    var videoPlayerView: VideoPlayerView!
    var volumeController: VolumeController?
    var stateMachine: VideoPlayerStateMachine!
    
    private var isPlaying: PlayState = .playing
    private var mediaPlayer = VLCMediaPlayer()
    private let film: Film
    private var sliderAction: VideoPlayerSliderAction?
    
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
        view = videoPlayerView
        
        videoPlayerView.titleLabel.text = film.title
        
        sliderAction = VideoPlayerSliderAction(view: videoPlayerView, mediaPlayer: mediaPlayer)
        
        setUpPlayer(url: film.URL)
        setActions()
        overrideVolumeBar()
       
        stateMachine = VideoPlayerStateMachine(view: videoPlayerView)
        stateMachine.updateUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stateMachine.transitionTo(state: .shown(.playing))
        }
    }
    
    override func viewDidLayoutSubviews() {
        videoPlayerView.didAppear()
    }
    
    func setUpPlayer(url: String) {
        let streamURL = URL(string: url)!
        let vlcMedia = VLCMedia(url: streamURL)
        
        mediaPlayer.media = vlcMedia
        mediaPlayer.delegate = self
        mediaPlayer.drawable = videoPlayerView.mediaView
        
        mediaPlayer.play()
    }
    
    //----------------------------------------------------------------------
    // MARK: Actions
    //----------------------------------------------------------------------
    
    func setActions() {
        videoPlayerView.pausePlayButton.addTarget(self, action: #selector(pausePlayButtonPressed(sender:)), for: .touchUpInside)
        
        let tapToShowControlls = UITapGestureRecognizer(target: self, action: #selector(showControlls))
        tapToShowControlls.numberOfTapsRequired = 1
        videoPlayerView.mediaView.addGestureRecognizer(tapToShowControlls)
        
        let tapToHideControlls = UITapGestureRecognizer(target: self, action: #selector(hideControlls))
        tapToHideControlls.numberOfTapsRequired = 1
        videoPlayerView.controlView.addGestureRecognizer(tapToHideControlls)
        
        videoPlayerView.forward10sButton.addTarget(self, action: #selector(rewindForward), for: .touchUpInside)
        videoPlayerView.backward10sButton.addTarget(self, action: #selector(rewindBack), for: .touchUpInside)
        
        videoPlayerView.closeButton.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        videoPlayerView.nextEpisodeButton.addTarget(self, action: #selector(playNextEpisode), for: .touchUpInside)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        videoPlayerView.mediaView.addGestureRecognizer(doubleTap)
        
        tapToShowControlls.require(toFail: doubleTap)
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
    // Actions: Controlls
    //----------------------------------------------------------------------
    @objc func showControlls() {
        stateMachine.transitionTo(state: .shown(isPlaying))
    }
    
    @objc func hideControlls() {
        stateMachine.transitionTo(state: .hidden(isPlaying))
    }
    
    @objc func pausePlayButtonPressed(sender: UIButton) {
        switch isPlaying {
        case .playing:
            mediaPlayer.pause()
            isPlaying = .paused
            
        case .paused:
            mediaPlayer.play()
            isPlaying = .playing
        }
        
        stateMachine.transitionTo(state: .shown(isPlaying))
    }
    
    @objc func rewindForward() {
        mediaPlayer.jumpForward(Int32(10))
    }
    
    @objc func rewindBack() {
        mediaPlayer.jumpBackward(Int32(10))
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        
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
// MARK: Application Life Cycle
//----------------------------------------------------------------------

extension VideoPlayerController {
    
    // When leaving the app
    func applicationWillResignActive() {
        // Pause the player
        mediaPlayer.pause()
        isPlaying = .paused
        videoPlayerView.pausePlayButton.setImage(Images.Player.playImage, for: .normal) // ▶
        
        // SHOW CONTROLLS
        videoPlayerView.controlView.isHidden = false
        isStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func applicationDidBecomeActive() {
        if let _ = navigationController { // re-rotate only if on the navigation stack
            forceLandscapeOrientation()
        }
    }
}
