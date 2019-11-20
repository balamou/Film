//
//  MockMovieInfoAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-18.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class MockMovieInfoAPI: MovieInfoAPI {
    let simulatedDelay = 1.5
    
    func getMovieInfo(movieId: Int, result: @escaping Handler<Movie>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) {
            
            let data: Movie = .init(id: 2, title: "El Camino", duration: 340, videoURL: "hehe", description: "Dopest movie ever made! Breaking bad typa stuff. Coming out October 11th, 2019.", poster: MockData.moviePosters[6], stoppedAt: 50)
            
            result(.success(data))
        }
    }
}
