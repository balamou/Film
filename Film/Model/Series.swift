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
    
    func constructTitle() -> String {
        if let title = title {
            return "\(episodeNumber). \(title)"
        } else {
            return "Episode ".localize() + "\(episodeNumber)"
        }
    }
}


