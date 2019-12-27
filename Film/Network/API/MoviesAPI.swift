//
//  MockMoviesAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-14.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

typealias MoviesHandler = (Result<([MovieItem], Bool), Error>) -> Void

protocol MoviesAPI {
    func getMovies(start: Int, quantity: Int, result: @escaping MoviesHandler)
}

class ConcreteMoviesAPI: MoviesAPI {
    private let settings: Settings
    
    private struct MoviesWrapper: Decodable {
        let movies: [MovieItem]
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

