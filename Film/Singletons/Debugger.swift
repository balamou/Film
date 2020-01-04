//
//  Debugger.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct Debugger {
    
    /// Allows to display custom volume indicator.
    /// Set to `false` if there is a problem with the volume indicator.
    /// Setting to false will also mute `[MediaRemote] OutputDeviceUID is nil Speaker: (null)` warnings.
    static let allowVolumeOverride = true
    static let showButtonMargins = false
}
