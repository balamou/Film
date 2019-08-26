//
//  VolumeController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

// Warning: This class can be unpredictable due to notifications and closures

import Foundation
import MediaPlayer
import AVFoundation

class VolumeController {
    
    let notificationCenter = NotificationCenter.default
    var previousVolumeLevel: Float?
    var action: ((Float) -> ())?
    var onHide: (() -> ())?
    var timer: Timer?
    
    
    init(view: UIView, onHide: @escaping () -> (), onChange: @escaping (Float) -> ()) {
        hideVolumeHUD(targetView: view)
        self.action = onChange
        self.onHide = onHide
        
        notificationCenter.addObserver(self, selector: #selector(systemVolumeDidChange), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    func hideVolumeHUD(targetView: UIView) {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.clipsToBounds = true
        volumeView.showsRouteButton = false
        targetView.addSubview(volumeView)
    }
    
    @objc func systemVolumeDidChange(notification: NSNotification) {
        guard let volumeLevel = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float else {
            print("Volume Value not set")
            return
        }
        
        print(volumeLevel)
        
        if let prevVolumeLevel = previousVolumeLevel, volumeLevel != prevVolumeLevel {
            action?(volumeLevel)
            
            timer?.invalidate()
            // Execute "Hide" after 3 seconds
            timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] timer in
                self?.onHide?()
            }
        }
        
        previousVolumeLevel = volumeLevel
    }
    
}
