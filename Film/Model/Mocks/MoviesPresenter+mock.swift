//
//  MoviesPresenter+mock.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-14.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

extension MoviesPresenter {
    
    static func getMockData() -> [MoviesPresenter] {
        return load(offset: 0, quantity: 9)
    }
    
    static func getMockData2() -> [MoviesPresenter] {
        return load(offset: 9, quantity: 4)
    }
    
    static func load(offset: Int, quantity: Int) -> [MoviesPresenter]  {
        return Array(0..<quantity).map { MoviesPresenter(id: $0 + offset, posterURL: MockData.moviePosters[$0 + offset]) }
    }
}
