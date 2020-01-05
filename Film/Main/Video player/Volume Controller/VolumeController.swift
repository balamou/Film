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

protocol VolumeControllerDelegate: class {
    func showVolumeIndicator(volumeLevel: Float)
    func hideVolumeIndicator()
}

class VolumeController {
    weak var delegate: VolumeControllerDelegate?
    
    private let volumeIndicatorTimeout: Double
    
    private let notificationCenter = NotificationCenter.default
    private let observerName = NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
    
    private var previousVolumeLevel: Float?
    private var timer: Timer?
    
    init(view: UIView, hideAfter seconds: Double = 2.0) {
        volumeIndicatorTimeout = seconds
        hideVolumeHUD(targetView: view)
        
        notificationCenter.addObserver(self, selector: #selector(systemVolumeDidChange), name: observerName, object: nil)
    }
    
    private func hideVolumeHUD(targetView: UIView) {
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
        
//        print(volumeLevel)
        
        if let prevVolumeLevel = previousVolumeLevel, volumeLevel != prevVolumeLevel {
            delegate?.showVolumeIndicator(volumeLevel: volumeLevel)
            
            timer?.invalidate()
            // Execute "Hide" after 2.0 seconds
            timer = Timer.scheduledTimer(withTimeInterval: volumeIndicatorTimeout, repeats: false) {
                [weak self] timer in
                self?.delegate?.hideVolumeIndicator()
            }
        }
        
        previousVolumeLevel = volumeLevel
    }
    
    deinit {
        notificationCenter.removeObserver(self, name:  observerName, object: nil)
    }
}
