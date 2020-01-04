//
//  ImageConstants.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct Images {
    
    static let logoImage = UIImage(named: "logo")
    
    struct Tabs {
        static let watchingImage = UIImage(named: "watching")
        static let showsImage = UIImage(named: "shows")
        static let moviesImage = UIImage(named: "movies")
        static let settingsImage = UIImage(named: "settings")
    }
    
    struct Watching {
        static let idleImage = UIImage(named: "nothing_found")
        static let informationImage = UIImage(named: "info")
    }
    
    struct Player {
        static let pauseImage = UIImage(named: "pause")
        static let playImage = UIImage(named: "play")
        static let forwardImage = UIImage(named: "forward")
        static let backwardImage = UIImage(named: "backward")
        static let nextEpisodeImage = UIImage(named: "next_episode")
        static let volumeImage = UIImage(named: "volume")
        static let airPlayImage = UIImage(named: "airplay")
        static let closeImage = UIImage(named: "close")
    }
    
    struct ShowInfo {
        static let playEpisode = UIImage(named: "play_episode")
    }
}
