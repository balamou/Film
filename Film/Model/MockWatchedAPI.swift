//
//  MockWatchedAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol WatchedAPI {
    func getWatched(result: @escaping ([Watched], _ error: String?) -> ())
}

class MockWatchedAPI: WatchedAPI {
    
    func getWatched(result: @escaping ([Watched], _ error: String?) -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            let error: String? = nil
            let data = Watched.getRandomMock()
            
            result(data, error)
        })
        
    }
    
}
