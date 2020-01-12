//
//  ViewedContentManager.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

class ViewedContentManager {
    internal let storageManager: StorageManager<ViewedContent>
    internal var contents: [ViewedContent]
    
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
    }
    
    static func test() {
        let manager = ViewedContentManager()
//        manager.contents = []
        
//        let value = ViewedContent(id: .movie(id: 10), title: "Wolf of Wallstreet", lastPlayedTime: Date().timeIntervalSince1970, position: 340, duration: 1230)
//        let movie = manager.findMovie(by: 10, orAdd: value)
//        let value2 = ViewedContent(id: .episode(id: 12, showId: 23, seasonNumber: 2, episodeNumber: 3), title: "Rick and Morty", lastPlayedTime: Date().timeIntervalSince1970, position: 350, duration: 1349)
//        let show2 = manager.findEpisode(by: 12, orAdd: value2)
//        let value3 = ViewedContent(id: .episode(id: 13, showId: 23, seasonNumber: 3, episodeNumber: 1), title: "Rick and Morty", lastPlayedTime: Date().timeIntervalSince1970, position: 12, duration: 1120)
//        let show3 = manager.findEpisode(by: 13, orAdd: value3)
//
//        movie.position = 203
//        movie.lastPlayedTime = Date().timeIntervalSince1970
//
//        show2.position = 900
//        movie.lastPlayedTime = Date().timeIntervalSince1970
        
        manager.contents.forEach { item in
            print(item)
        }
        manager.save()
        
        print()
        
//        let p = PostersNetworkProvider(settings: Settings())
//        let data = [ContentInfo(type: .movie, id: 123), ContentInfo(type: .show, id: 69)]
//        p.getPosters(data: data, result: { res in })
    }
}
