//
//  VideoPlayerSliderAction.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-04.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

protocol VideoPlayerSliderActionDelegate: class {
    func didStartScrolling()
    func didEndScrolling()
    func observeCurrentTime(percentagePlayed: Float, totalDuration: Int)
    
    func observeSecondsChange(currentTimeSeconds: Int)
}

class VideoPlayerSliderAction: NSObject {
    private let view: VideoPlayerView // TODO: inject only views that are needed, not the whole view
    private let mediaPlayer: VLCMediaPlayer
    
    private var setPosition = true
    private var updatePosition = true
    
    weak var delegate: VideoPlayerSliderActionDelegate?
    
    private var previousSecond: Int = -1
    
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
            
            var remaining = mediaPlayer.remainingTime.description
            remaining.remove(at: remaining.startIndex) // remove first character
            view.durationLabel.text = remaining // display time
            
            notifyDelegate()
        }
    }
    
    private func notifyDelegate() {
        let totalDuration = Int(mediaPlayer.media.length.intValue/1000)
        delegate?.observeCurrentTime(percentagePlayed: mediaPlayer.position, totalDuration: totalDuration)
        
        let currentSecond = Int(mediaPlayer.position * Float(totalDuration))
        
        if previousSecond != currentSecond {
            previousSecond = currentSecond
            delegate?.observeSecondsChange(currentTimeSeconds: currentSecond)
        }
    }
    
    // When the value of the slider is set but the finger is outside the slider
    @objc func touchUpOutside(_ sender: UISlider) {
        positionSliderAction()
        view.currentPositionLabel.isHidden = true
        delegate?.didEndScrolling()
    }
    
    // When the value of the slider is set but the finger is inside the slider
    @objc func touchUpInside(_ sender: UISlider) {
        positionSliderAction()
        view.currentPositionLabel.isHidden = true
        delegate?.didEndScrolling()
    }
    
    // When the slider is touched
    @objc func touchDown(_ sender: UISlider) {
        updatePosition = false
        delegate?.didStartScrolling()
    }
    
    private func positionSliderAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: setPositionForReal)
        
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
        
        let newLabelPosition = setUISliderThumbValueWithLabel(slider: view.slider, label: label)
        let newLabelSize = label.frame.addToWidth(5.0).size
        
        label.text = getTimeFromValue(sender.value)
        label.isHidden = false
        label.frame = CGRect(origin: newLabelPosition, size: newLabelSize)
    }
    
    private func getTimeFromValue(_ value: Float) -> String {
        let totalVideoDuration = mediaPlayer.media.length.intValue/1000
        return Film.durationMin(seconds: Int(value * Float(totalVideoDuration)))
    }
    
    private func setUISliderThumbValueWithLabel(slider: UISlider, label: UILabel) -> CGPoint {
        let sliderTrack = slider.trackRect(forBounds: slider.bounds)
        let sliderFrame = slider.thumbRect(forBounds: slider.bounds, trackRect: sliderTrack, value: slider.value)
        return CGPoint(x: sliderFrame.origin.x + slider.frame.origin.x + sliderFrame.size.width/2 - label.frame.size.width/2, y: view.bottomBar.frame.origin.y - 20)
    }

    deinit {
        mediaPlayer.removeObserver(self, forKeyPath: "time")
    }
}


extension VLCMediaPlayer {
    
    var totalDuration: Int {
        get {
            return Int(media.length.intValue/1000)
        }
    }
    
    var currentPositionInSeconds: Int {
        get {
            return Int(position * Float(totalDuration))
        }
    }
    
}
