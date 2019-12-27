//
//  Show.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


struct Series: Decodable {
    var id: Int
    var title: String
    var seasonSelected: Int
    var totalSeasons: Int
    
    var description: String?
    var posterURL: String?
    var lastWatchedEpisode: Episode?
}

struct Episode: Decodable {
    var id: Int
    var episodeNumber: Int
    var seasonNumber: Int
    var videoURL: String
    var duration: Int
    
    var thumbnailURL: String?
    var title: String?
    var plot: String?
    var stoppedAt: Int?
    
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
    
    mutating func fixURL(with urlFixer: (String?) -> String?) {
        videoURL = urlFixer(videoURL) ?? videoURL
        thumbnailURL = urlFixer(thumbnailURL)
    }
}


