//
//  ViewedContentManager+WatchedAPI.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

extension ViewedContentManager: WatchedAPI {
    
    func getWatched(result: @escaping WatchedHandler) {
        var groupped = group(viewed: contents)
        groupped.sort(by: { $0.lastPlayedTime > $1.lastPlayedTime })
        groupped = Array(groupped.prefix(9))
        
        let postersProvider = PostersNetworkProvider(settings: Settings())
        postersProvider.getPosters(data: convertToContentInfo(viewed: groupped)) { [weak self] posterResult in
            guard let self = self else { return }
            
            switch posterResult {
            case let .success(posters):
                let watched = self.merge(viewed: groupped, with: posters)
                result(.success(watched))
            case let .failure(error):
                result(.failure(error))
            }
        }
    }
    
    private func merge(viewed: [ViewedContent], with posters: [Poster]) -> [Watched] {
        var moviePosters: [Int: String] = [:]
        var showPosters: [Int: String] = [:]
        
        posters.filter { $0.type == .movie }.forEach { poster in
            moviePosters[poster.id] = poster.posterURL
        }
        posters.filter { $0.type == .show }.forEach { poster in
            showPosters[poster.id] = poster.posterURL
        }
        
        return convertToWatched(viewed: viewed, moviePosters: moviePosters, showPosters: showPosters)
    }
    
    private func convertToWatched(viewed: [ViewedContent], moviePosters: [Int: String], showPosters: [Int: String]) -> [Watched] {
        viewed.map { item -> Watched in
            switch item.id {
            case let .movie(id: movieId):
                let label = Film.durationMinWithTime(seconds: item.duration)
                
                return Watched(id: movieId, duration: item.duration, stoppedAt: item.position, label: label, type: .movie, showId: nil, title: item.title, posterURL: moviePosters[movieId])
            case let .episode(id: episodeId, showId: showId, seasonNumber: seasonNumber, episodeNumber: episodeNumber):
                let label = "S\(seasonNumber):E\(episodeNumber)"
                
                return Watched(id: episodeId, duration: item.duration, stoppedAt: item.position, label: label, type: .show, showId: showId, title: item.title, posterURL: showPosters[showId])
            }
        }
    }
    
    private func convertToContentInfo(viewed: [ViewedContent]) -> [ContentInfo] {
        viewed.map { item in
            let filmType: FilmType
            let id: Int
            switch item.id {
            case let .movie(movieId):
                filmType = .movie
                id = movieId
            case let .episode(_, showId, _, _):
                filmType = .show
                id = showId
            }
            
            return ContentInfo(type: filmType, id: id)
        }
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
                
                if show.lastPlayedTime < item.lastPlayedTime {
                    shows[showId] = item
                }
            }
        }
        
        let lastWatchedEpisodes = shows.map { $0.value }
        movies.append(contentsOf: lastWatchedEpisodes)
        
        return movies
    }
    
}
