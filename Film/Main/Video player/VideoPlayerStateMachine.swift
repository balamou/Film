//
//  VideoPlayerStateMachine.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-04.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

enum PlayState {
    case playing
    case paused
}

enum VideoPlayerState {
    case initial
    case shown(PlayState)
    case hidden(PlayState)
    case loadingShown
    case loadingHidden
    case scrolling
}

class VideoPlayerStateMachine {
    private var view: VideoPlayerView
    private var currentState: VideoPlayerState = .initial
    private var thumbImage: UIImage?
    
    init(view: VideoPlayerView) {
        self.view = view
    }
    
    private func canTransition(from: VideoPlayerState, to: VideoPlayerState) -> Bool {
        switch (from, to) {
        case (.initial, .shown):
            return true
        case (.shown, .hidden),
             (.shown, .loadingShown),
             (.shown, .scrolling):
            return true
        case (.hidden, .shown),
             (.hidden, .loadingHidden):
            return true
        case (.loadingShown, .shown),
             (.loadingShown, .loadingHidden),
             (.loadingShown, .scrolling):
            return true
        case (.scrolling, .loadingShown):
            return true
        default:
            return false
        }
    }
    
    func transitionTo(state newState: VideoPlayerState) {
        guard canTransition(from: currentState, to: newState) else {
            assertionFailure("Attempting to transition from '\(currentState)' to '\(newState)'")
            return
        }
        
        let from = currentState
        let to = newState
        currentState = newState
        
        switch (from, to) {
        case (.shown, .hidden):
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                self.view.controlView.alpha = 0.0
            })
        case (.hidden, .shown):
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                self.view.controlView.alpha = 1.0
            })
        case (.loadingShown, .loadingHidden):
            break
        case (.loadingHidden, .loadingShown):
            break
        default:
            updateUI()
        }
    }
    
    func updateUI() {
        thumbImage = thumbImage ?? view.slider.thumbImage(for: .normal)
        
        switch currentState {
        case .initial:
            view.controlView.show()
            
            view.backward10sLabel.hide()
            view.backward10sButton.hide()
            view.forward10sLabel.hide()
            view.forward10sButton.hide()
            view.pausePlayButton.hide()
            view.airPlayButton.hide()
            view.spinner.startAnimating()
            
            view.slider.setThumbImage(UIImage(), for: .normal)
        case .shown(let playing):
            switch playing {
            case .paused:
                view.pausePlayButton.setImage(Images.Player.playImage, for: .normal)
            case .playing:
                view.pausePlayButton.setImage(Images.Player.pauseImage, for: .normal)
            }
            
            view.controlView.show()
            
            view.backward10sLabel.show()
            view.backward10sButton.show()
            view.forward10sLabel.show()
            view.forward10sButton.show()
            view.pausePlayButton.show()
            view.airPlayButton.show()
            view.spinner.stopAnimating()
            
            view.slider.setThumbImage(thumbImage, for: .normal)
        case .loadingShown:
            view.controlView.show()
            view.pausePlayButton.hide()

            view.backward10sLabel.show()
            view.backward10sButton.show()
            view.forward10sLabel.show()
            view.forward10sButton.show()
            view.airPlayButton.show()
            view.spinner.startAnimating()
            
            view.slider.setThumbImage(thumbImage, for: .normal)
        default:
            return
        }
    }
}

extension UIView {
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
}
