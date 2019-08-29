//
//  Watched.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


class Watched {
    
    var id: Int // database id (for information button)
    var poster: String? // URL of the poster image
    var stoppedAt: Float // percentage of the progression
    var label: String // Either Season # and Episode # or duration
    var movieURL: String // for player
    
    init(id: Int, poster: String? = nil, stoppedAt: Float, label: String, movieURL: String) {
        self.id = id
        self.poster = poster
        self.stoppedAt = stoppedAt
        self.label = label
        self.movieURL = movieURL
    }
    
    static func getMockData() -> [Watched] {
        let data = [Watched(id: 0, stoppedAt: 0.4, label: "S1:E3", movieURL: "http://192.168.72.46:9989/EN/series/rick_and_morty/S1/E01.mp4"),
                    Watched(id: 1, stoppedAt: 0.1, label: "1h 30 min", movieURL: "http://192.168.72.46:9989/EN/movies/get_out/movie.mp4"),
                    Watched(id: 2, stoppedAt: 0.8, label: "S1:E7", movieURL: "http://192.168.72.46:9989/EN/series/westworld/S1/E07.mp4"),
        ]
        
        return data
    }
    
    static func getRandomMock() -> [Watched] {
        let data = [Watched(id: 0, stoppedAt: Float.random(in: 0 ..< 1), label: "S1:E3", movieURL: "http://192.168.72.46:9989/EN/series/rick_and_morty/S1/E01.mp4"),
                    Watched(id: 1, stoppedAt: Float.random(in: 0 ..< 1), label: "1h 30 min", movieURL: "http://192.168.72.46:9989/EN/movies/get_out/movie.mp4"),
                    Watched(id: 2, stoppedAt: Float.random(in: 0 ..< 1), label: "S1:E7", movieURL: "http://192.168.72.46:9989/EN/series/westworld/S1/E07.mp4"),
        ]
        
        return data
    }
}
