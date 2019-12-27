//
//  MockData.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-01.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct MockData {
    static let videoURLs = ["http://192.168.72.59:3000/E03.mkv",
                     "http://192.168.72.59:3000/E03.mkv",
                     "http://192.168.72.59:3000/E03.mkv"]
    static let posters: [String] = loadFromAsset(assetName: "Posters")
    static let moviePosters: [String] = loadFromAsset(assetName: "MoviePosters")
    
    static func randomPoster() -> String {
        return MockData.posters[Int.random(in: 0 ..< MockData.posters.count)]
    }
    
    static private func loadFromAsset(assetName: String) -> [String] {
        guard let asset = NSDataAsset(name: assetName) else {
            fatalError("Missing data asset: \(assetName)")
        }
        
        let decoder = JSONDecoder()
        let data = try! decoder.decode([String].self, from: asset.data)
        
        return data
    }
}
