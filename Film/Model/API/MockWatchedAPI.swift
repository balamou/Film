//
//  MockWatchedAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol WatchedAPI {
    func getWatched(result: @escaping (Result<[Watched], NetworkError>) -> Void)
}

enum NetworkError: Error {
    case badURL
    case noInternet
    case noData
    case invalidEndpoint
    case jsonError
    case dataTaskError(Error)
    
    func getDescription() -> String {
        switch self {
        case .badURL:
            return "The URL is wrong"
        case .noInternet:
            return "There is no internet connection"
        case .noData:
            return "There is no data"
        case .invalidEndpoint:
            return "Invalid endpoint"
        case .jsonError:
            return "JSON parsing error"
        case .dataTaskError(_):
            return "Data task error"
        }
    }
}

class MockWatchedAPI: WatchedAPI {
    
    var count = 0
    let timeDelay = 1.5
    
    func getWatched(result: @escaping (Result<[Watched], NetworkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) { [weak self] in
            guard let self = self else { return }
            
            if self.count == 2 || self.count == 5 {
                result(.failure(.badURL))
            } else {
                let data = (self.count == 1 || self.count == 4) ? [] : Watched.getRandomMock()
                result(.success(data))
            }
            
            self.count += 1
        }
    }
}
    

//----------------------------------------------------------------------
// TODO: Implement and test Concrete API
//----------------------------------------------------------------------
class ConcreteWatchedAPI: WatchedAPI {
    
    let serverIP: String = "192.168.72.46"
    let port: String = "9899"
    
    func getWatched(result: @escaping (Result<[Watched], NetworkError>) -> Void) {
        networkCall(result: result)
    }

    func networkCall(result: @escaping (Result<[Watched], NetworkError>) -> Void) {
        let urlString = "http://\(serverIP):\(port)/path/to/rest"
        
        guard let url = URL(string: urlString) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(.dataTaskError(error)))
                return
            }
            
            guard let response = response else {
                // TODO: handle empty response
                return
            }
            
            guard let data = data else {
                result(.failure(.noData))
                return
            }
            
            do {
                let watched = try JSONDecoder().decode([Watched].self, from: data)
                result(.success(watched))
            } catch {
                result(.failure(.jsonError))
            }
        }.resume()
    }
}
