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

enum VideoPlayerState: CustomStringConvertible {
    case initial
    case shown(PlayState)
    case hidden
    case loadingShown
    case loadingHidden
    case scrolling
    
    var description: String {
        switch self {
        case .initial:
            return ".initial"
        case .shown(_):
            return ".shown"
        case .hidden:
            return ".hidden"
        case .loadingShown:
            return ".loadingShown"
        case .loadingHidden:
            return ".loadingHidden"
        case .scrolling:
            return ".scrolling"
        }
    }
}

class VideoPlayerStateMachine {
    private var view: VideoPlayerView
    private var currentState: VideoPlayerState
    private var transitioning = false
    
    private var timer: Timer?
    
    init(view: VideoPlayerView) {
        self.view = view
        self.currentState = .initial
        updateUI()
    }
    
    var canDoubleTap: Bool {
        switch currentState {
        case .initial,
             .scrolling:
            return false
        default:
            return true
        }
    }
    
    var canTapToShowHideControls: Bool {
        switch currentState {
        case .initial,
             .scrolling:
            return false
        default:
            return true
        }
    }
    
    private func canTransition(from: VideoPlayerState, to: VideoPlayerState) -> Bool {
        switch (from, to) {
        case (.initial, .shown):
            return true
        case (.shown, .shown),
             (.shown, .hidden),
             (.shown, .loadingShown),
             (.shown, .scrolling):
            return true
        case (.hidden, .shown),
             (.hidden, .loadingHidden):
            return true
        case (.loadingShown, .loadingShown),
             (.loadingShown, .shown),
             (.loadingShown, .loadingHidden),
             (.loadingShown, .scrolling):
            return true
        case (.loadingHidden, .loadingShown),
             (.loadingHidden, .hidden):
            return true
        case (.scrolling, .scrolling),
             (.scrolling, .shown):
            return true
        case (_, .initial): // when tapped "play next episode"
            return true
        default:
            return false
        }
    }
    
    func transitionTo(state newState: VideoPlayerState) {
        guard canTransition(from: currentState, to: newState) else {
            if Debugger.Player.crashWhenAttemptingIllegalTransition {
                assertionFailure("Attempting to transition from '\(currentState)' to '\(newState)'")
            } else {
                print("Illegal Transition: Attempting to transition from '\(currentState)' to '\(newState)'")
            }
            return
        }
        
        if Debugger.Player.printPlayerStateTransitions {
            print("\(currentState) -> \(newState)")
        }
        
        let from = currentState
        let to = newState
        currentState = newState
        timer?.invalidate()
        
        switch (from, to) {
        case (.loadingShown, .shown):
            transitionTo(state: .hidden, after: 7.0)
            
        case (.shown, .hidden):
            hideAnimation()
            
        case (.hidden, .shown(let playing)):
            setupPlaying(playing)
            showAnimation()
            transitionTo(state: .hidden, after: 7.0)
            
        case (.shown, .shown(let playing)):
            // update playOrPause icon
            setupPlaying(playing)
            
        case (.loadingShown, .loadingHidden):
            hideAnimation()
            
        case (.loadingHidden, .loadingShown):
            showAnimation()
            transitionTo(state: .loadingHidden, after: 7.0)
            
        case (.initial, .shown(let playing)):
            setupPlaying(playing)
            transitionTo(state: .hidden, after: 7.0)
            
        default:
            break
        }
        
        updateUI()
    }
    
    private func hideAnimation() {
        transitioning = true
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.view.controlView.alpha = 0.0
        }, completion: { _ in
            self.transitioning = false
        })
    }
    
    private func showAnimation() {
        transitioning = true
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.view.controlView.alpha = 1.0
        }, completion: {_ in
            self.transitioning = false
        })
    }
    
    private func transitionTo(state: VideoPlayerState, after seconds: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] timer in
            self?.transitionTo(state: state)
            timer.invalidate()
        }
    }
    
    func setupPlaying(_ playing: PlayState) {
        switch playing {
        case .paused:
            view.pausePlayButton.pause()
        case .playing:
            view.pausePlayButton.play()
        }
    }
    
    func updateUI() {
        switch currentState {
        case .initial:
            break
        default:
            view.slider.setThumbImage(Images.Player.thumbTrackImage, for: .normal)
            view.slider.setThumbImage(Images.Player.thumbTrackImage, for: .focused)
            view.slider.setThumbImage(Images.Player.thumbTrackImage, for: .highlighted)
        }
        
        view.closeButton.show()
        view.nextEpisodeButton.show()
        
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
            setupPlaying(playing)
            
            view.backward10sLabel.show()
            view.backward10sButton.show()
            view.forward10sLabel.show()
            view.forward10sButton.show()
            view.pausePlayButton.show()
            view.airPlayButton.show()
            view.spinner.stopAnimating()
        case .hidden:
            view.airPlayButton.show()
            view.spinner.stopAnimating()
        case .loadingShown:
            view.pausePlayButton.hide()

            view.backward10sLabel.show()
            view.backward10sButton.show()
            view.forward10sLabel.show()
            view.forward10sButton.show()
            view.airPlayButton.show()
            view.spinner.startAnimating()
        case .loadingHidden:
            view.spinner.startAnimating()
        case .scrolling:
            view.nextEpisodeButton.hide()
            view.airPlayButton.hide()
            view.pausePlayButton.hide()
            view.spinner.hide()
            view.backward10sLabel.hide()
            view.backward10sButton.hide()
            view.forward10sLabel.hide()
            view.forward10sButton.hide()
            view.closeButton.hide()
        }
    }
    
    func startedBuffering() {
        switch currentState {
        case .shown:
            transitionTo(state: .loadingShown)
        case .hidden:
            transitionTo(state: .loadingHidden)
        default:
            return
        }
    }
    
    func doneBuffering(playState: PlayState) {
        switch currentState {
        case .initial:
            transitionTo(state: .shown(playState))
        case .loadingShown:
            transitionTo(state: .shown(playState))
        case .loadingHidden:
            transitionTo(state: .hidden)
        default:
            return
        }
    }
    
    func showControls(playState: PlayState) {
        switch currentState {
        case .hidden:
            transitionTo(state: .shown(playState))
        case .loadingHidden:
            transitionTo(state: .loadingShown)
        default:
            print("Attempting to show controls in invalid state ('\(currentState)')")
        }
    }
    
    func hideControls() {
        switch currentState {
        case .shown:
            transitionTo(state: .hidden)
        case .loadingShown:
            transitionTo(state: .loadingHidden)
        default:
            print("Attempting to show controls in invalid state ('\(currentState)')")
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
