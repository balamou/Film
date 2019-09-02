//
//  Series+mock.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-01.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


extension Series {
    
    static func getMock() -> Series {
        let url = MockData.videoURLs[0]
        let episodes = Array(1...5).map { i in Episode(id: i, episodeNumber: i, seasonNumber: 1, videoURL: url) }
        let desc = "An animated series on adult-swim about the infinite adventures of Rick, a genius alcoholic and careless scientist, with his grandson Morty, a 14 year-old anxious boy who is not so smart, but always tries to lead his grandfather with his own morale compass. Together, they explore the infinite universes; causing mayhem and running into trouble."
        
        return Series(title: "Rick and Morty", episodes: episodes, seasonSelected: 2, totalSeasons: 4, description: desc, posterURL: MockData.randomPoster())
    }
}

extension Episode {
    
    static func getMock() -> Episode {
        return Episode(id: 1, episodeNumber: 1, seasonNumber: 2, videoURL: MockData.videoURLs[0])
    }
    
}
