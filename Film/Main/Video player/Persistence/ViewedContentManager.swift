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
    
    func update(viewingContent: ViewedContent, with position: Int) {
        viewingContent.position = position
        viewingContent.lastPlayedTime = Date().timeIntervalSince1970
        delegate?.didUpdateWatched()
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
