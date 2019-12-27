//
//  Watched+mock.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-01.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


extension Watched {
    
    static func getMockData() -> [Watched] {
        let data = [Watched(id: 0, duration: 100, stoppedAt: 40, label: "S1:E3", videoURL: MockData.videoURLs[0], type: .show),
                    Watched(id: 1, duration: 100, stoppedAt: 10, label: "1h 30 min", videoURL: MockData.videoURLs[1], type: .show),
                    Watched(id: 2, duration: 100, stoppedAt: 80, label: "S1:E7", videoURL: MockData.videoURLs[2], type: .movie),
        ]
        
        return data
    }
    
    static func getRandomMock() -> [Watched] {
       
        return [Watched(id: 0, duration: 100, stoppedAt: 40, label: "S1:E3", videoURL: MockData.videoURLs[0], type: .show, posterURL: MockData.randomPoster()),
                Watched(id: 1, duration: 100, stoppedAt: 40, label: "1h 30 min", videoURL: MockData.videoURLs[1], type: .show, posterURL: MockData.randomPoster()),
                Watched(id: 2, duration: 100, stoppedAt: 40, label: "S1:E7", videoURL: MockData.videoURLs[2], type: .movie, posterURL: MockData.randomPoster()),
        ]
    }
    
    fileprivate static func randomFloat() -> Float {
        return Float.random(in: 0 ..< 1)
    }
    
}
