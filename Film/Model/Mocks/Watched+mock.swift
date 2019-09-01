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
        let data = [Watched(id: 0, stoppedAt: 0.4, label: "S1:E3", movieURL: MockData.videoURLs[0]),
                    Watched(id: 1, stoppedAt: 0.1, label: "1h 30 min", movieURL: MockData.videoURLs[1]),
                    Watched(id: 2, stoppedAt: 0.8, label: "S1:E7", movieURL: MockData.videoURLs[2]),
        ]
        
        return data
    }
    
    static func getRandomMock() -> [Watched] {
       
        return [Watched(id: 0, posterURL: MockData.imageURLs[0], stoppedAt: Float.random(in: 0 ..< 1), label: "S1:E3", movieURL: MockData.videoURLs[0]),
                Watched(id: 1, posterURL: MockData.imageURLs[1], stoppedAt: Float.random(in: 0 ..< 1), label: "1h 30 min", movieURL: MockData.videoURLs[1]),
                Watched(id: 2, posterURL: MockData.imageURLs[2], stoppedAt: Float.random(in: 0 ..< 1), label: "S1:E7", movieURL: MockData.videoURLs[2]),
        ]
    }
}
