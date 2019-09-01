//
//  Show.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class Series {
    var title: String
    var episodes: [Episode]
    var description: String?
    var posterURL: String?
    var lastWatchedEpisode: Episode?
    
    init(title: String, episodes: [Episode], description: String? = nil, posterURL: String? = nil, lastWatchedEpisode: Episode? = nil) {
        self.title = title
        self.episodes = episodes
        self.description = description
        self.posterURL = posterURL
        self.lastWatchedEpisode = lastWatchedEpisode
    }
    
    static func getMock() -> Series {
        let url = "http://192.168.72.46:9989/EN/series/rick_and_morty/S1/E01.mp4"
        let episodes = [1, 2, 3, 4, 5].map { i in Episode(id: i, episodeNumber: i, seasonNumber: 1, videoURL: url) }
        let desc = "An animated series on adult-swim about the infinite adventures of Rick, a genius alcoholic and careless scientist, with his grandson Morty, a 14 year-old anxious boy who is not so smart, but always tries to lead his grandfather with his own morale compass. Together, they explore the infinite universes; causing mayhem and running into trouble."
        
        return Series(title: "Rick and Morty", episodes: episodes, description: desc)
    }
}

class Episode {
    var id: Int
    var episodeNumber: Int
    var seasonNumber: Int
    var videoURL: String
    
    var title: String?
    var plot: String?
    var stoppedAt: Float?
    
    init(id: Int, episodeNumber: Int, seasonNumber: Int, videoURL: String, title: String? = nil, plot: String? = nil, stoppedAt: Float? = nil) {
        self.id = id
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.videoURL = videoURL
        self.title = title
        self.plot = plot
        self.stoppedAt = stoppedAt
    }
    
    static func getMock() -> Episode {
        return Episode(id: 1, episodeNumber: 1, seasonNumber: 2, videoURL: "http://192.168.72.46:9989/EN/series/rick_and_morty/S1/E01.mp4")
    }
    
    func constructTitle() -> String {
        if let title = title {
            return "\(episodeNumber). \(title)"
        } else {
            return "Episode ".localize() + "\(episodeNumber)"
        }
    }
}


