//
//  MockWatchedAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

typealias Handler<T> = (Result<T, Error>) -> Void

typealias WatchedHandler = (Result<[Watched], Error>) -> Void

protocol WatchedAPI {
    func getWatched(result: @escaping WatchedHandler)
}

class ConcreteWatchedAPI: WatchedAPI {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getWatched(result: @escaping WatchedHandler) {
        guard let userId = settings.userId else {
            result(.failure(ConnectionError.custom("UserId is nil")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .watched(userId: userId), method: .get)
        let requestType = RequestType<[Watched]>(data: requestData)
        
        requestType.execute(onSuccess: { watched in
            result(.success(watched))
        }, onError: { error in
            result(.failure(error))
        })
    }
}

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
    
