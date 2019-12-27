//
//  ImageConstants.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct Images {
    
    static let logoImage = UIImage(named: "Logo")
    static let closeImage = UIImage(named: "Close")
    
    struct Tabs {
        static let watchingImage = UIImage(named: "Watching")
        static let showsImage = UIImage(named: "Shows")
        static let moviesImage = UIImage(named: "Movies")
        static let settingsImage = UIImage(named: "Settings")
    }
    
    struct Watching {
        static let idleImage = UIImage(named: "Nothing_found")
        static let informationImage = UIImage(named: "info")
    }
    
    struct Player {
        static let pauseImage = UIImage(named: "Pause")
        static let playImage = UIImage(named: "Play")
        static let forwardImage = UIImage(named: "forward")
        static let backwardImage = UIImage(named: "backward")
        static let nextEpisodeImage = UIImage(named: "Next_episode")
        static let volumeImage = UIImage(named: "Volume")
    }
    
    struct ShowInfo {
        static let playEpisode = UIImage(named: "play_episode")
    }
}
