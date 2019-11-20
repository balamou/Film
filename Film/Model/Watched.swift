//
//  Watched.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


struct Watched: Decodable {
    var id: Int // MovieID OR EpisodeID (this is not the show id, see below)
    var duration: Int
    var stoppedAt: Int // Time stopped at
    var label: String // Either Season # and Episode # or duration
    var movieURL: String // for player
    var type: FilmType
    
    var showId: Int?
    var title: String?
    var posterURL: String? // URL of the poster image
    
    var percentViewed: Float {
        return Float(stoppedAt)/Float(duration)
    }
}
