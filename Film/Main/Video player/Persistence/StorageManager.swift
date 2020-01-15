//
//  StorageManager.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

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
