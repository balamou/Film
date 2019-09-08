//
//  MockWatchedAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol WatchedAPI {
    func getWatched(result: @escaping ([Watched], _ error: String?) -> Void)
}

class MockWatchedAPI: WatchedAPI {
    
    var count = 0
    
    func getWatched(result: @escaping ([Watched], _ error: String?) -> Void) {
        test1(result: result)
    }
    
    func test1(result: @escaping ([Watched], _ error: String?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            let error: String? = (self?.count == 2 || self?.count == 5) ? "Bad internet connection" : nil
            let data = (self?.count == 0 || self?.count == 4) ? [] : Watched.getRandomMock()
            
            result(data, error)
            
            self?.count += 1
        })
    }
    
    func test2(result: @escaping ([Watched], _ error: String?) -> Void)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            let error: String? = (self?.count == 0) ? "Bad internet connection" : nil
            let data = (self?.count == 0) ? [] : Watched.getRandomMock()

            result(data, error)

            self?.count += 1
        })
    }
    
    enum NetworkError: Error {
        case badURL
        case noInternet
    }
    
    // Example using result type
    // TODO: actually implement this
    func test3(result: @escaping (Result<[Watched], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            if self?.count == 2 || self?.count == 5 {
                result(.failure(NetworkError.badURL))
            } else {
                let data = (self?.count == 0 || self?.count == 4) ? [] : Watched.getRandomMock()
                result(.success(data))
            }
                
            self?.count += 1
        })
    }
}
