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

class StorageManager<T> where T: Codable {
    enum StoreManagerError: Error {
        case dataNotStored
    }
    
    private let defaults: UserDefaults
    private let key: String
    
    init(key: String, defaults: UserDefaults = .standard) {
        self.key = key
        self.defaults = defaults
    }
    
    func save(_ newData: [T]) throws {
        let encodedData = try JSONEncoder().encode(newData)
        
        defaults.set(encodedData, forKey: key)
    }
    
    func bulkLoad() throws -> [T] {
        guard let retrievedData = defaults.object(forKey: key), let data = retrievedData as? Data else {
            throw StoreManagerError.dataNotStored
        }
        
        let decodedData = try JSONDecoder().decode([T].self, from: data)
        
        return decodedData
    }
}
