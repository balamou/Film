//
//  VideoPlayerController+Volume.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

extension VideoPlayerController: VolumeControllerDelegate {
    
    func overrideVolumeBar() {
        guard Debugger.allowVolumeOverride else { return }
        
        volumeController = VolumeController(view: view)
        volumeController?.delegate = self
    }
    
    func showVolumeIndicator(volumeLevel: Float) {
        videoPlayerView.volumeImage.isHidden = false
        videoPlayerView.volumeBar.isHidden = false
        videoPlayerView.volumeBar.progress = volumeLevel
        
        // Hide status bar
        isStatusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func hideVolumeIndicator() {
        videoPlayerView.volumeBar.isHidden = true
        videoPlayerView.volumeImage.isHidden = true
    }
    
}
