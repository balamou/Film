//
//  MockData.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-01.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


class MockData {
    
    static let videoURLs = ["http://192.168.72.46:9989/EN/series/rick_and_morty/S1/E01.mp4",
                     "http://192.168.72.46:9989/EN/movies/get_out/movie.mp4",
                     "http://192.168.72.46:9989/EN/series/westworld/S1/E07.mp4"]
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
