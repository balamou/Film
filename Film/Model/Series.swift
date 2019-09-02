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
    var seasonSelected: Int
    var totalSeasons: Int
    var description: String?
    var posterURL: String?
    var lastWatchedEpisode: Episode?
    
    init(title: String, episodes: [Episode], seasonSelected: Int, totalSeasons: Int, description: String? = nil, posterURL: String? = nil, lastWatchedEpisode: Episode? = nil) {
        self.title = title
        self.episodes = episodes
        self.seasonSelected = seasonSelected
        self.totalSeasons = totalSeasons
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
    var duration: Int
    
    var thumbnailURL: String?
    var title: String?
    var plot: String?
    var stoppedAt: Float?
    
    init(id: Int,
         episodeNumber: Int,
         seasonNumber: Int,
         videoURL: String,
         duration: Int,
         thumbnailURL: String? = nil,
         title: String? = nil,
         plot: String? = nil,
         stoppedAt: Float? = nil) {
        self.id = id
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.videoURL = videoURL
        self.duration = duration
        
        self.thumbnailURL = thumbnailURL
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
    
    func durationInMinutes() -> String {
        return durationInMinutes(seconds: duration)
    }
    
    fileprivate func durationInMinutes(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours == 0 {
            return "\(minutes) " + "min".localize()
        } else {
            return "\(hours) " + "h".localize() + " \(minutes) " + "min".localize()
        }
    }
    
    
}


