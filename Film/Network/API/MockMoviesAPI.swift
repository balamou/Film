//
//  MockMoviesAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-14.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

typealias MoviesHandler = (Result<([MoviesPresenter], Bool), Error>) -> Void

protocol MoviesAPI {
    func getMovies(start: Int, quantity: Int, result: @escaping MoviesHandler)
}

class ConcreteMoviesAPI: MoviesAPI {
    private let settings: Settings
    
    private struct MoviesWrapper: Decodable {
        let movies: [MoviesPresenter]
        let isLast: Bool
    }
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getMovies(start: Int, quantity: Int, result: @escaping MoviesHandler) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .movies(start: start, quantity: quantity, language: settings.language), method: .get)
        let requestType = RequestType<MoviesWrapper>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            result(.success((data.movies, data.isLast)))
        }, onError: { error in
            result(.failure(error))
        })
    }
}

class MockMoviesAPI: MoviesAPI {
    var count = 0
    let timeDelay = 1.5
    
    func getMovies(start: Int, quantity: Int, result: @escaping MoviesHandler) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay, execute: { [weak self] in
            guard let self = self else { return }
            
            if self.count == 2 {
                result(.failure(NSError(domain: "Error", code: 0, userInfo: nil)))
                self.count += 1
                return
            }
            
            let data: [MoviesPresenter]
            if self.count == 4 {
                data = MoviesPresenter.getMockData2()
            } else if self.count == 3 {
                data = []
            } else {
                data = MoviesPresenter.getMockData()
            }
            
            let isLast = (start >= 2 * 9)
            
            result(.success((data, isLast)))
            
            if start == 2 * 9 + 4 {
                self.count = 0
            } else {
                self.count += 1
            }
        })
    }
}
