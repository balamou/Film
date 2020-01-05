//
//  VideoPlayerSliderAction.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-04.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class VideoPlayerSliderAction: NSObject {
    var setPosition = true
    var updatePosition = true
    let view: VideoPlayerView
    let mediaPlayer: VLCMediaPlayer
    
    init(view: VideoPlayerView, mediaPlayer: VLCMediaPlayer) {
        self.view = view
        self.mediaPlayer = mediaPlayer
        
        super.init()
        
        mediaPlayer.addObserver(self, forKeyPath: "time", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        view.slider.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        view.slider.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        view.slider.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        view.slider.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    // continuously update slider and time displayed
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (setPosition && updatePosition) {
            view.slider.value = mediaPlayer.position // move slider
            
            var remaining =  mediaPlayer.remainingTime.description
            remaining.remove(at: remaining.startIndex)
            view.durationLabel.text = remaining // display time
        }
    }
    
    // When the value of the slider is set but the finger is outside the slider
    @objc func touchUpOutside(_ sender: UISlider) {
        positionSliderAction()
        view.currentPositionLabel.isHidden = true
    }
    
    // When the value of the slider is set but the finger is inside the slider
    @objc func touchUpInside(_ sender: UISlider) {
        positionSliderAction()
        view.currentPositionLabel.isHidden = true
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
            mediaPlayer.position = view.slider.value
            setPosition = true
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Update time label as slider is moving
    //----------------------------------------------------------------------
    @objc func valueChanged(_ sender: UISlider) {
        let label = view.currentPositionLabel
        label.sizeToFit()
        
        let position = setUISliderThumbValueWithLabel(slider: view.slider, label: label)
        let rect = label.frame.addToWidth(5.0)
        let duration = mediaPlayer.media.length.intValue/1000
        label.text = Film.durationMin(seconds: Int(sender.value * Float(duration)))
            
        label.isHidden = false
        label.frame = CGRect(origin: position, size: rect.size)
    }
    
    func setUISliderThumbValueWithLabel(slider: UISlider, label: UILabel) -> CGPoint {
        let sliderTrack = slider.trackRect(forBounds: slider.bounds)
        let sliderFrm = slider.thumbRect(forBounds: slider.bounds, trackRect: sliderTrack, value: slider.value)
        return CGPoint(x: sliderFrm.origin.x + slider.frame.origin.x + sliderFrm.size.width/2 - label.frame.size.width/2, y: view.bottomBar.frame.origin.y)
    }

    deinit {
        mediaPlayer.removeObserver(self, forKeyPath: "time")
    }
}
