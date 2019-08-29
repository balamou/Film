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
    var posterURL: String? // URL of the poster image
    var stoppedAt: Float // percentage of the progression
    var label: String // Either Season # and Episode # or duration
    var movieURL: String // for player
    
    init(id: Int, posterURL: String? = nil, stoppedAt: Float, label: String, movieURL: String) {
        self.id = id
        self.posterURL = posterURL
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
        let imageURLs = ["https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_39_-_COVER_A_FNL_WEB_1024x.jpg?v=1530034748",
            "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_V9_TPB_-_COVER_B_FNL_WEB_1024x.jpg?v=1561666332",
        "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_53_-_COVER_A_SOLICIT_WEB_1024x.jpg?v=1566330470",
        "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_PRESENTS_V1_-_COVER_B_FNL_WEB_1024x.jpg?v=1559159173",
        "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_PRESENTS_V1_-_COVER_A_FNL_WEB_1024x.jpg?v=1559158092",
        "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_45_-_COVER_A_SOLICIT_WEB_1024x.jpg?v=1546446607"]
        
        let videoURLs = ["http://192.168.72.46:9989/EN/series/rick_and_morty/S1/E01.mp4",
                         "http://192.168.72.46:9989/EN/movies/get_out/movie.mp4",
                         "http://192.168.72.46:9989/EN/series/westworld/S1/E07.mp4"]
        
        return [Watched(id: 0, posterURL: imageURLs[0], stoppedAt: Float.random(in: 0 ..< 1), label: "S1:E3", movieURL: videoURLs[0]),
                Watched(id: 1, posterURL: imageURLs[1], stoppedAt: Float.random(in: 0 ..< 1), label: "1h 30 min", movieURL: videoURLs[1]),
                Watched(id: 2, posterURL: imageURLs[2], stoppedAt: Float.random(in: 0 ..< 1), label: "S1:E7", movieURL: videoURLs[2]),
        ]
    }
}
