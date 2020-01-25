//
//  ViewController.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let mediaPlayer = VLCMediaPlayer()
    private let mediaView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(mediaView)
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        
        mediaView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mediaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mediaView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        setUpPlayer(url: "http://192.168.72.46:3000/videos/en/series/rick_and_morty/S1/E1.mp4", stoppedAt: 0)
    }
    
    private func setUpPlayer(url: String, stoppedAt: Float) {
        guard let streamURL = URL(string: url) else {
            print("Error reading the URL") // TODO: exit & alert
            return
        }
        
        let vlcMedia = VLCMedia(url: streamURL)
        
        vlcMedia.addOptions(["network-caching": 500])
        mediaPlayer.media = vlcMedia
        //          mediaPlayer.drawable = videoPlayerView.mediaView
        mediaPlayer.drawable = mediaView
        
        mediaPlayer.play()
    }

}

