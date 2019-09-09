//
//  MockWatchedAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noInternet
    
    func getDescription() -> String {
        switch self {
        case .badURL:
            return "The URL is wrong"
        case .noInternet:
            return "There is no internet connection"
        }
    }
}

protocol WatchedAPI {
    func getWatched(result: @escaping (Result<[Watched], NetworkError>) -> Void)
}

class MockWatchedAPI: WatchedAPI {
    
    var count = 0
    
    func getWatched(result: @escaping (Result<[Watched], NetworkError>) -> Void) {
        test3(result: result)
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
    
    // Example using result type
    // TODO: actually implement this
    func test3(result: @escaping (Result<[Watched], NetworkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            if self.count == 2 || self.count == 5 {
                result(.failure(NetworkError.badURL))
            } else {
                let data = (self.count == 0 || self.count == 4) ? [] : Watched.getRandomMock()
                result(.success(data))
            }
                
            self.count += 1
        }
    }
    
    enum APIServiceError: Error {
        case invalidEndpoint
        case noData
    }
    
    //----------------------------------------------------------------------
    // TMP: Template for actual API
    //----------------------------------------------------------------------
    func actualAPI(result: @escaping (Result<[Watched], Error>) -> Void) {
        let urlString = "http://192.168.72.46:9899/path/to/rest"
        
        guard let url = URL(string: urlString) else {
            result(.failure(APIServiceError.invalidEndpoint))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response else {
                // TODO: handle empty response
                return
            }
            
            guard let data = data else {
                result(.failure(APIServiceError.noData))
                return
            }
            
            do {
                // let watched = try JSONDecoder().decode([Watched].self, from: data) // TODO: decode
                let watched: [Watched] = []
                result(.success(watched))
            } catch let jsonError {
                result(.failure(jsonError))
            }
        }.resume()
    }
}
