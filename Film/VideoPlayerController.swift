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
    var mediaPlayer = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        videoPlayerView = VideoPlayerView(frame: self.view.frame)
        self.view = videoPlayerView
        
        setUpPlayer()
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

