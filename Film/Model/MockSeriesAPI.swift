//
//  MockAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


protocol SeriesMoviesAPI {
    func getSeries(start: Int, quantity: Int, result: @escaping ([SeriesPresenter], _ isLast: Bool, _ error: String?) -> ())
    func getMovies(start: Int, quantity: Int, result: @escaping ([MoviesPresenter], _ isLast: Bool, _ error: String?) -> ())
}

class MockSeriesAPI: SeriesMoviesAPI {
    
    var count = 0
    
    func getSeries(start: Int, quantity: Int, result: @escaping ([SeriesPresenter], _ isLast: Bool, _ error: String?) -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            let error: String? = self?.count == 2 || self?.count == 3 ? "Could not load" : nil
            let data = self?.count == 4 ? SeriesPresenter.getMockData2() : SeriesPresenter.getMockData()
            let isLast = (start >= 2 * 9)
            
            result(data, isLast, error)
            
            if start == 2 * 9 + 4 {
                self?.count = 0
            } else {
                self?.count += 1
            }
        })
    }
    
    func getMovies(start: Int, quantity: Int, result: @escaping ([MoviesPresenter], _ isLast: Bool, _ error: String?) -> ()) {
        
    }
}
