//
//  Debugger.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct Debugger {
    
    /// Highlights in red tap area of CustomMarginButton
    static let showButtonMargins = false
    
    struct Player {
        /// Allows to display custom volume indicator.
        /// Set to `false` if there is a problem with the volume indicator.
        /// Setting to false will also mute `[MediaRemote] OutputDeviceUID is nil Speaker: (null)` warnings.
        static let allowVolumeOverride = true
        static let printPlayerStateTransitions = true
        static let printBufferingState = false
        
        /// Crashes the app with an assertion when attempting to
        /// make illegal transition between states in Player.
        /// See [player state transitions](https://github.com/balamou/Film/blob/master/images/video_player_state_transitions.png?raw=true).
        static let crashWhenAttemptingIllegalTransition = true
    }
    
}
