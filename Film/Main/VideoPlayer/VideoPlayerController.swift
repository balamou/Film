//
//  VideoPlayerController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-22.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class VideoPlayerController: UIViewController, VLCMediaPlayerDelegate {

    var isPlaying: Bool = true
    var videoPlayerView: VideoPlayerView!
    var mediaPlayer = VLCMediaPlayer()
    var timer: Timer?
    var film: Film = Film()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forceLandscapeOrientation()
        
        videoPlayerView = VideoPlayerView(frame: self.view.frame)
        self.view = videoPlayerView
       
        setUpPlayer(url: film.URL)
        setActions()
        setTimerForControlHide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        videoPlayerView.didAppear()
    }
    
    func setActions() {
        videoPlayerView.pausePlayButton.addTarget(self, action: #selector(pausePlayButtonPressed(sender:)), for: .touchUpInside)
        
        let tapToShowControlls = UITapGestureRecognizer(target: self, action: #selector(showControlls))
        videoPlayerView.mediaView.addGestureRecognizer(tapToShowControlls)
        
        let tapToHideControlls = UITapGestureRecognizer(target: self, action: #selector(hideControlls))
        videoPlayerView.controlView.addGestureRecognizer(tapToHideControlls)
        
        videoPlayerView.forward10sButton.addTarget(self, action: #selector(rewindForward), for: .touchUpInside)
        videoPlayerView.backward10sButton.addTarget(self, action: #selector(rewindBack), for: .touchUpInside)
        
        videoPlayerView.closeButton.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        
        // Slider
        mediaPlayer.addObserver(self, forKeyPath: "time", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        videoPlayerView.slider.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        videoPlayerView.slider.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        videoPlayerView.slider.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        videoPlayerView.slider.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    func setUpPlayer(url: String) {
        let streamURL = URL(string: url)!
        let vlcMedia = VLCMedia(url: streamURL)
        
        mediaPlayer.media = vlcMedia
        mediaPlayer.drawable = videoPlayerView.mediaView
        mediaPlayer.delegate = self
        
        mediaPlayer.play()
    }
    
    //----------------------------------------------------------------------
    // Orientation
    //----------------------------------------------------------------------
    func forceLandscapeOrientation() {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    var isStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //----------------------------------------------------------------------
    // Actions
    //----------------------------------------------------------------------
    func setTimerForControlHide() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] timer in
            print("Timer fired!")
            self?.hideControlls()
        }
    }
    
    @objc func showControlls() {
        videoPlayerView.controlView.isHidden = false
        self.isStatusBarHidden = false
        
        UIView.animate(withDuration: 0.1) {
            self.setNeedsStatusBarAppearanceUpdate()
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
            //sender.setTitle("▶", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        } else {
            mediaPlayer.play()
            isPlaying = true
            //sender.setTitle("▌▌", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
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
    
    func positionSliderAction()
    {
        self.perform(#selector(setPositionForReal), with: nil, afterDelay: 0.3)
        
        setPosition = false
        updatePosition = true
    }
    
    @objc func setPositionForReal()
    {
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
        let position = setUISliderThumbValueWithLabel(slider: videoPlayerView.slider, label: label)
        let rect = label.frame
        
        label.text = film.durationMin(seconds: Int(sender.value * Float(film.duration)))
            
        label.isHidden = false
        label.frame = CGRect(origin: position, size: rect.size)
    }
    
    func setUISliderThumbValueWithLabel(slider: UISlider, label: UILabel) -> CGPoint {
        let sliderTrack = slider.trackRect(forBounds: slider.bounds)
        let sliderFrm = slider .thumbRect(forBounds: slider.bounds, trackRect: sliderTrack, value: slider.value)
        return CGPoint(x: sliderFrm.origin.x + slider.frame.origin.x + sliderFrm.size.width/2 - label.frame.size.width/2, y: videoPlayerView.bottomBar.frame.origin.y)
    }
    
    
    
}

class Film {
    // Mandatory
    var id: Int
    var URL: String
    var duration: Int
    
    // Optional
    var stoppedAt: Int?
    var poster: String?
    var title: String?
    
    init() {
        var testVideos = ["http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
                          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4" ]
        
        id = 0
        URL = testVideos[7]
        duration = 15
    }
    
    func label() -> String {
        return ""
    }
    
    func durationMin() -> String {
        return durationMin(seconds: duration)
    }
    
    func durationMin(seconds sec: Int) -> String
    {
        let hours: Int = sec / 3600
        let minutes: Int = (sec % 3600) / 60
        let seconds: Int = sec - minutes * 60
        
        if hours == 0 {
            return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        } else {
            return "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes))"
        }
    }
}

