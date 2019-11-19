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
