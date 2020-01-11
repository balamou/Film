//
//  ViewedContentManager.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

class ViewedContentManager {
    private let storageManager: StorageManager<ViewedContent>
    private var contents: [ViewedContent]
    
    init() {
        storageManager = StorageManager<ViewedContent>(key: "viewed_content")
        contents = (try? storageManager.bulkLoad()) ?? []
    }
    
    func save() {
        do {
            try storageManager.save(contents)
        } catch {
            print("Unable to save `viewed_content`")
        }
    }
    
    private func findMovie(by id: Int) -> ViewedContent? {
        contents.first(where: { item in
            switch item.id {
            case let .movie(id: movieId) where movieId == id:
                return true
            default:
                return false
            }
        })
    }
    
    
   private func findEpisode(by id: Int) -> ViewedContent? {
       contents.first(where: { item in
           switch item.id {
           case .episode(let episodeId, _, _, _) where episodeId == id:
               return true
           default:
               return false
           }
       })
   }
    
    func findMovie(by id: Int, orAdd defaultValue: ViewedContent) -> ViewedContent {
        guard let movie = findMovie(by: id) else {
            contents.append(defaultValue)
            return defaultValue
        }
        
        return movie
    }
    
    func findEpisode(by id: Int, orAdd defaultValue: ViewedContent) -> ViewedContent {
        guard let episode = findEpisode(by: id) else {
            contents.append(defaultValue)
            return defaultValue
        }
        
        return episode
    }
    
    static func test() {
        let manager = ViewedContentManager()
        print(manager.contents)
        
        let value = ViewedContent(id: .movie(id: 10), title: "Wolf of Wallstreet", intialPlayTime: Date(), lastPlayedTime: Date(), position: 340, duration: 1230)
        let movie = manager.findMovie(by: 10, orAdd: value)
        
        movie.position = 203
        movie.lastPlayedTime = Date()
        manager.save()
        
        print()
    }
}

extension ViewedContentManager: WatchedAPI {
    
    func getWatched(result: @escaping WatchedHandler) {
        contents.sort(by: { $0.lastPlayedTime < $1.lastPlayedTime })
        let groupped = group(viewed: contents)
        
        let watched = groupped.map { item -> Watched in
            switch item.id {
            case let .movie(id: movieId):
                let label = Film.durationMin(seconds: item.duration)
                
                return Watched(id: movieId, duration: item.duration, stoppedAt: item.position, label: label, videoURL: "^^^", type: .movie, showId: nil, title: item.title, posterURL: "^^^")
            case let .episode(id: episodeId, showId: showId, seasonNumber: seasonNumber, episodeNumber: episodeNumber):
                let label = "S\(seasonNumber):E\(episodeNumber)"
                
                return Watched(id: episodeId, duration: item.duration, stoppedAt: item.position, label: label, videoURL: "^^^", type: .show, showId: showId, title: item.title, posterURL: "^^^")
            }
        }
        
        result(.success(watched))
    }
    
    private func group(viewed: [ViewedContent]) -> [ViewedContent] {
        var shows: [Int: ViewedContent] = [:]
        var movies: [ViewedContent] = []
        
        for item in viewed {
            switch item.id {
            case .movie:
                movies.append(item)
            case .episode(_, let showId, _, _):
                guard let show = shows[showId] else {
                    shows[showId] = item
                    break
                }
                
                if show.lastPlayedTime > item.lastPlayedTime {
                    shows[showId] = item
                }
            }
        }
        
        let lastWatchedEpisodes = shows.map { $0.value }
        movies.append(contentsOf: lastWatchedEpisodes)
        
        return movies
    }
}
