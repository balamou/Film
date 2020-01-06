//
//  Film.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

enum FilmType: String, Decodable {
    case movie
    case show
}

struct Film {
    let id: Int // MovieID OR EpisodeID (this is not the show id)
    let URL: String
    let duration: Int
    let type: FilmType
    
    var stoppedAt: Int?
    var title: String?
    
    func durationMin() -> String {
        return Film.durationMin(seconds: duration)
    }
    
    static func durationMin(seconds sec: Int) -> String {
        let hours: Int = sec / 3600
        let minutes: Int = (sec % 3600) / 60
        let seconds: Int = sec - minutes * 60
        
        if hours == 0 {
            return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        } else {
            return "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes))"
        }
    }
    
    static func from(watched: Watched) -> Film {
        return Film(id: watched.id,
                    URL: watched.videoURL,
                    duration: watched.duration,
                    type: watched.type,
                    stoppedAt: watched.stoppedAt,
                    title: watched.title)
    }
    
    static func from(episode: Episode) -> Film {
        var newTitle: String = "No title".localize()
        if let title = episode.title {
            newTitle = "S\(episode.seasonNumber):E\(episode.episodeNumber) \"\(title)\""
        }
        
        return Film(id: episode.id,
                    URL: episode.videoURL,
                    duration: episode.duration,
                    type: .show,
                    stoppedAt: episode.stoppedAt,
                    title: newTitle)
    }
    
    static func from(movie: Movie) -> Film {
        return Film(id: movie.id,
                    URL: movie.videoURL,
                    duration: movie.duration,
                    type: .movie,
                    stoppedAt: movie.stoppedAt,
                    title: movie.title)
    }
}
