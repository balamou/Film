//
//  MovieItem+mock.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-14.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

extension MovieItem {
    
    static func getMockData() -> [MovieItem] {
        return load(offset: 0, quantity: 9)
    }
    
    static func getMockData2() -> [MovieItem] {
        return load(offset: 9, quantity: 4)
    }
    
    static func load(offset: Int, quantity: Int) -> [MovieItem]  {
        return Array(0..<quantity).map { MovieItem(id: $0 + offset, posterURL: MockData.moviePosters[$0 + offset]) }
    }
}
