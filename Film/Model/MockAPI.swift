//
//  MockAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


protocol SeriesMoviesAPI {
    func getSeries(start: Int, quantity: Int, result: @escaping ([SeriesPresenter], _ error: String?) -> ())
    func getMovies(start: Int, quantity: Int, result: @escaping ([MoviesPresenter]) -> ())
}

class MockSeriesAPI: SeriesMoviesAPI {
    
    var count = 0
    
    func getSeries(start: Int, quantity: Int, result: @escaping ([SeriesPresenter], _ error: String?) -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            let error: String? = self.count == 2 || self.count == 3 ? "Could not load" : nil
            
            result(SeriesPresenter.getMockData(), error)
            self.count += 1
        })
    }
    
    func getMovies(start: Int, quantity: Int, result: @escaping ([MoviesPresenter]) -> ()) {
        
    }
}
