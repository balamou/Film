//
//  MockWatchedAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-18.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class MockWatchedAPI: WatchedAPI {
    var count = 0
    let timeDelay = 1.5
    
    func getWatched(result: @escaping WatchedHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) { [weak self] in
            guard let self = self else { return }
            
            if self.count == 2 || self.count == 5 {
                result(.failure(ConnectionError.invalidURL))
            } else {
                let data = (self.count == 1 || self.count == 4) ? [] : Watched.getRandomMock()
                result(.success(data))
            }
            
            self.count += 1
        }
    }
}
    
