//
//  Film.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

enum FilmType: String, Codable {
    case movie
    case show
}

struct Film: Decodable {
    let id: Int // MovieID OR EpisodeID (this is not the show id)
    let type: FilmType
    var URL: String? = nil
    var title: String?
    
    mutating func fixURL(with urlFixer: (String?) -> String?) {
        URL = urlFixer(URL) ?? URL
    }
    
    static func durationMin(seconds sec: Int) -> String {
        let secondsInHour = 3600
        let secondsInMinute = 60
        
        let hours: Int = sec / secondsInHour
        let minutes: Int = (sec % secondsInHour) / secondsInMinute
        let seconds: Int = sec - minutes * secondsInMinute
        
        if hours == 0 {
            return "\(addZero(to: minutes)):\(addZero(to: seconds))"
        }
        
        return "\(addZero(to: hours)):\(addZero(to: minutes))"
    }
    
    static func durationMinWithTime(seconds sec: Int) -> String {
        let secondsInHour = 3600
        let secondsInMinute = 60
        
        let hours: Int = sec / secondsInHour
        let minutes: Int = (sec % secondsInHour) / secondsInMinute
        let seconds: Int = sec - minutes * secondsInMinute
        
        if hours == 0 {
            return "\(minutes)min \(seconds)s"
        }
        
        return "\(hours)h \(minutes)min"
    }
    
    static private func addZero(to number: Int) -> String {
        return String(format: "%02d", number)
    }
    
    static func from(watched: Watched) -> Film {
        return Film(id: watched.id,
                    type: watched.type,
                    title: watched.title)
    }
    
    static func from(episode: Episode) -> Film {
        var newTitle: String = "No title".localize()
        if let title = episode.title {
            newTitle = "S\(episode.seasonNumber):E\(episode.episodeNumber) \"\(title)\""
        }
        
        return Film(id: episode.id,
                    type: .show,
                    title: newTitle)
    }
    
    static func from(movie: Movie) -> Film {
        return Film(id: movie.id,
                    type: .movie,
                    title: movie.title)
    }
}
