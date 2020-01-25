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
    func observeCurrentTimeMilliseconds(currentMillisecond: Int)
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
        view.slider.addTarget(self, action: #selector(touchCancelled(_:)), for: .touchCancel)
    }
    
    // continuously update slider and time displayed
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (setPosition && updatePosition) {
            view.slider.value = mediaPlayer.position // move slider
            view.durationLabel.text = mediaPlayer.timeRemaining
            
            notifyDelegate()
        }
    }
    
    private func notifyDelegate() {
        delegate?.observeCurrentTime(percentagePlayed: mediaPlayer.position, totalDuration: mediaPlayer.totalDuration)
        delegate?.observeCurrentTimeMilliseconds(currentMillisecond: mediaPlayer.currentPositionInMilliseconds)
        
        let currentSecond = mediaPlayer.currentPositionInSeconds
        
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
    
    /// Tihs method is needed, otherwise `didEndScrolling` never runs and
    /// ends up being stuck in scrolling state
    @objc func touchCancelled(_ sender: UISlider) {
        delegate?.didEndScrolling()
        positionSliderAction()
        view.currentPositionLabel.isHidden = true
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
        
        view.durationLabel.text = getTimeFromValue(1 - sender.value)
    }
    
    private func getTimeFromValue(_ value: Float) -> String {
        let totalVideoDuration = mediaPlayer.totalDuration
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
    
    /// Returns the video's total duration in seconds
    var totalDuration: Int {
        get {
            return Int(media.length.intValue/1000)
        }
    }
    
    /// Returns the current position in the video in seconds
    var currentPositionInSeconds: Int {
        get {
            return Int(position * Float(totalDuration))
        }
    }
    
    /// Returns the time remaining time of the video in this format `hh:mm:ss`
    var timeRemaining: String {
        get {
            var remaining = remainingTime.description
            remaining.remove(at: remaining.startIndex)
            return remaining
        }
    }
    
    /// Returns the current position in the media in milliseconds
    var currentPositionInMilliseconds: Int {
        get {
            return Int(position * Float(media.length.intValue))
        }
    }
    
    func disableSubtitles() {
        currentVideoSubTitleIndex = -1
    }
}
