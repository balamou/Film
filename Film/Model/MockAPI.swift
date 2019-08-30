//
//  MockAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


protocol SeriesMoviesAPI {
    func getSeries(start: Int, quantity: Int, result: @escaping ([SeriesPresenter]) -> ())
    func getMovies(start: Int, quantity: Int, result: @escaping ([MoviesPresenter]) -> ())
}

class MockSeriesAPI: SeriesMoviesAPI {
    
    func getSeries(start: Int, quantity: Int, result: @escaping ([SeriesPresenter]) -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
           result(SeriesPresenter.getMockData())
        })
    }
    
    func getMovies(start: Int, quantity: Int, result: @escaping ([MoviesPresenter]) -> ()) {
        
    }
}
