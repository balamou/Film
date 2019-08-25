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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forceLandscape()
        
        videoPlayerView = VideoPlayerView(frame: self.view.frame)
        self.view = videoPlayerView
        
        setUpPlayer()
        
        videoPlayerView.pausePlayButton.addTarget(self, action: #selector(pausePlayButtonPressed(sender:)), for: .touchUpInside)
        
        let tapOnVideo = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        videoPlayerView.mediaView.addGestureRecognizer(tapOnVideo)
        
        let tapTohideControlls = UITapGestureRecognizer(target: self, action: #selector(hideControlls))
        videoPlayerView.controlView.addGestureRecognizer(tapTohideControlls)
    }
    
    @objc func videoTapped() {
        videoPlayerView.controlView.isHidden = false
    }
    
    @objc func hideControlls() {
        videoPlayerView.controlView.isHidden = true
    }
    
    @objc func pausePlayButtonPressed(sender: UIButton) {
        if isPlaying {
            mediaPlayer.pause()
            isPlaying = false
            sender.setTitle("▶", for: .normal)
        } else {
            mediaPlayer.play()
            isPlaying = true
            sender.setTitle("▌▌", for: .normal)
        }
    }
    
    func forceLandscape() {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func setUpPlayer() {
        let streamURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!
        let vlcMedia = VLCMedia(url: streamURL)
        
        mediaPlayer.media = vlcMedia
        mediaPlayer.drawable = videoPlayerView.mediaView
        mediaPlayer.delegate = self
        
        mediaPlayer.play()
    }
}
