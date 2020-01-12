//
//  ViewedContentManager.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

protocol ViewContentManagerObservable: class {
    func didUpdateWatched()
}

class ViewedContentManager {
    internal let storageManager: StorageManager<ViewedContent>
    internal var contents: [ViewedContent]
    weak var delegate: ViewContentManagerObservable?
    
    private var currentViewingContent: ViewedContent?
    
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
    
    func addMovieIfNotAdded(id: Int, value: ViewedContent) -> ViewedContent {
        guard let movie = findMovie(by: id) else {
            contents.append(value)
            return value
        }
        
        return movie
    }
    
    func addEpisodeIfNotAdded(id: Int, value: ViewedContent) -> ViewedContent {
        guard let episode = findEpisode(by: id) else {
            contents.append(value)
            return value
        }
        
        return episode
    }
        
    func update(id: Int, type: FilmType, with position: Int) {
        currentViewingContent = getReference(id: id, type: type)
        
        currentViewingContent?.position = position
        currentViewingContent?.lastPlayedTime = Date().timeIntervalSince1970
        
        delegate?.didUpdateWatched()
    }
    
    private func getReference(id: Int, type: FilmType) -> ViewedContent? {
        if let viewing = currentViewingContent {
            switch (type, viewing.id) {
            case (.movie, .movie(let movieId)) where movieId == id:
                return viewing
            case (.show, .episode(let episodeId, _, _, _)) where episodeId == id:
                return viewing
            default:
                break
            }
        }
        
        switch type {
        case .movie:
            return findMovie(by: id)
        case .show:
            return findEpisode(by: id)
        }
    }
    
    func lastWatchedSeason(showId: Int) -> Int? {
        var show: ViewedContent?
        var season: Int?
        
        for item in contents {
            switch item.id {
            case .episode(_, let _showId, let seasonNumber, _) where _showId == showId:
                guard let actualShow = show else {
                    show = item
                    season = seasonNumber
                    break
                }
                
                if actualShow.lastPlayedTime < item.lastPlayedTime {
                    show = item
                    season = seasonNumber
                }
            default:
                break
            }
        }
        
        return season
    }
    
    static func test() {
        let manager = ViewedContentManager()
        //manager.contents = []
        manager.contents.forEach { item in
            print(item)
        }
        
        manager.save()
    }
}
