//
//  MockMovieAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-15.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol MovieInfoAPI {
    func getMovieInfo(movieId: Int, result: @escaping Handler<Movie>)
}

class ConcreteMovieInfoAPI: MovieInfoAPI {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getMovieInfo(movieId: Int, result: @escaping Handler<Movie>) {
        guard let userId = settings.userId else {
            result(.failure(ConnectionError.custom("UserId is nil")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .movie(movieId: movieId, userId: userId), method: .get)
        let requestType = RequestType<Movie>(data: requestData)
        
        requestType.execute(onSuccess: { movie in
            var _movie = movie
            _movie.fixURL(with: self.settings.createPath)
                
            result(.success(_movie))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
