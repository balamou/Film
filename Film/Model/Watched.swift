//
//  Watched.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


struct Watched: Decodable {
    enum WatchedType: String, Decodable {
        case movie
        case show
    }
    
    var id: Int // database id (for information button)
    var posterURL: String? // URL of the poster image
    var stoppedAt: Float // percentage of the progression
    var label: String // Either Season # and Episode # or duration
    var movieURL: String // for player
    var type: WatchedType
}
