//
//  SeriesPresenter+mock.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-01.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


extension SeriesPresenter {
    
    static func getMockData() -> [SeriesPresenter] {
        return load(offset: 3, quantity: 9)
    }
    
    static func getMockData2() -> [SeriesPresenter] {
        return load(offset: 3 + 9, quantity: 4)
    }
    
    static func load(offset: Int, quantity: Int) -> [SeriesPresenter]  {
        return Array(0..<quantity).map { SeriesPresenter(id: $0 + offset, posterURL: MockData.posters[$0 + offset]) }
    }
}
