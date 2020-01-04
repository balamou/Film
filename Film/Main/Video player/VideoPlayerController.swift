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
    
    private var isPlaying: Bool = true
    private var mediaPlayer = VLCMediaPlayer()
    private var timer: Timer?
    private let film: Film
    
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
        
        setUpPlayer(url: film.URL)
        setActions()
        setTimerForControlHide()
        overrideVolumeBar()
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
        videoPlayerView.mediaView.addGestureRecognizer(tapToShowControlls)
        
        let tapToHideControlls = UITapGestureRecognizer(target: self, action: #selector(hideControlls))
        videoPlayerView.controlView.addGestureRecognizer(tapToHideControlls)
        
        videoPlayerView.forward10sButton.addTarget(self, action: #selector(rewindForward), for: .touchUpInside)
        videoPlayerView.backward10sButton.addTarget(self, action: #selector(rewindBack), for: .touchUpInside)
        
        videoPlayerView.closeButton.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        
        videoPlayerView.nextEpisodeButton.addTarget(self, action: #selector(playNextEpisode), for: .touchUpInside)
        
        // Slider
        mediaPlayer.addObserver(self, forKeyPath: "time", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        videoPlayerView.slider.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        videoPlayerView.slider.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        videoPlayerView.slider.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        videoPlayerView.slider.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
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
    func setTimerForControlHide() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] timer in
            self?.hideControlls()
        }
    }
    
    @objc func showControlls() {
        videoPlayerView.controlView.isHidden = false
        
        if videoPlayerView.volumeBar.isHidden { // show status bar only if volume bar is hidden
            self.isStatusBarHidden = false
            
            UIView.animate(withDuration: 0.1) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
        
        setTimerForControlHide()
    }
    
    @objc func hideControlls() {
        videoPlayerView.controlView.isHidden = true
        self.isStatusBarHidden = true
        
        UIView.animate(withDuration: 0.1) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        timer?.invalidate()
    }
    
    @objc func pausePlayButtonPressed(sender: UIButton) {
        if isPlaying {
            mediaPlayer.pause()
            isPlaying = false
            sender.setImage(Images.Player.playImage, for: .normal) // ▶
        } else {
            mediaPlayer.play()
            isPlaying = true
            sender.setImage(Images.Player.pauseImage, for: .normal) // ▌▌
        }
    }
    
    @objc func rewindForward() {
        mediaPlayer.jumpForward(Int32(10))
    }
    
    @objc func rewindBack() {
        mediaPlayer.jumpBackward(Int32(10))
    }
    
    @objc func closeVideo() {
        print("Close video")
        navigationController?.popViewController(animated: false)
    }
    
    @objc func playNextEpisode() {
        print("Next episode")
    }
    
    //----------------------------------------------------------------------
    // Slider
    //----------------------------------------------------------------------
    var setPosition = true
    var updatePosition = true
    
    // continuously update slider and time displayed
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (setPosition && updatePosition)
        {
            videoPlayerView.slider.value = mediaPlayer.position // move slider
            
            var remaining =  mediaPlayer.remainingTime.description
            remaining.remove(at: remaining.startIndex)
            videoPlayerView.durationLabel.text = remaining // display time
        }
    }
    
    // When the value of the slider is set but the finger is outside the slider
    @objc func touchUpOutside(_ sender: UISlider) {
        positionSliderAction()
        videoPlayerView.currentPositionLabel.isHidden = true
    }
    
    // When the value of the slider is set but the finger is inside the slider
    @objc func touchUpInside(_ sender: UISlider) {
        positionSliderAction()
        videoPlayerView.currentPositionLabel.isHidden = true
    }
    
    // When the slider is touched
    @objc func touchDown(_ sender: UISlider) {
        updatePosition = false
    }
    
    func positionSliderAction() {
        self.perform(#selector(setPositionForReal), with: nil, afterDelay: 0.3)
        
        setPosition = false
        updatePosition = true
    }
    
    @objc func setPositionForReal() {
        if !setPosition {
            mediaPlayer.position = videoPlayerView.slider.value
            setPosition = true
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Update time label as slider is moving
    //----------------------------------------------------------------------
    @objc func valueChanged(_ sender: UISlider) {
        let label = videoPlayerView.currentPositionLabel
        label.sizeToFit()
        
        let position = setUISliderThumbValueWithLabel(slider: videoPlayerView.slider, label: label)
        let rect = label.frame.addToWidth(5.0)
        let duration = mediaPlayer.media.length.intValue/1000
        label.text = film.durationMin(seconds: Int(sender.value * Float(duration)))
            
        label.isHidden = false
        label.frame = CGRect(origin: position, size: rect.size)
    }
    
    func setUISliderThumbValueWithLabel(slider: UISlider, label: UILabel) -> CGPoint {
        let sliderTrack = slider.trackRect(forBounds: slider.bounds)
        let sliderFrm = slider .thumbRect(forBounds: slider.bounds, trackRect: sliderTrack, value: slider.value)
        return CGPoint(x: sliderFrm.origin.x + slider.frame.origin.x + sliderFrm.size.width/2 - label.frame.size.width/2, y: videoPlayerView.bottomBar.frame.origin.y)
    }

    //----------------------------------------------------------------------
    // MARK: Removing observers/pointers
    //----------------------------------------------------------------------
    deinit {
        print("Remove Observers: Deinit")
        mediaPlayer.removeObserver(self, forKeyPath: "time")
        mediaPlayer.stop()
        timer?.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        mediaPlayer.stop()
        timer?.invalidate()
        
        // RESET ORIENTATION
        if (self.isMovingFromParent) {
            let portrait = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(portrait, forKey: "orientation")
        }
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
        isPlaying = false
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
