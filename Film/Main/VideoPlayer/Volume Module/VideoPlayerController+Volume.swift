//
//  VideoPlayerController+Volume.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

extension VideoPlayerController {
    
    func overrideVolumeBar() {
        if !Debuger.allowVolumeOverride {
            return
        }
        
        vol = VolumeController(view: view, onHide: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.videoPlayerView.volumeBar.isHidden = true
            strongSelf.videoPlayerView.volumeImage.isHidden = true
        }) { [weak self] volumeLevel in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.videoPlayerView.volumeImage.isHidden = false
            strongSelf.videoPlayerView.volumeBar.isHidden = false
            strongSelf.videoPlayerView.volumeBar.progress = volumeLevel
            
            // Hide status bar
            strongSelf.isStatusBarHidden = true
            strongSelf.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
