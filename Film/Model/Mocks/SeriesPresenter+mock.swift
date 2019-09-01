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
        return Array(0...8).map { SeriesPresenter(id: $0, posterURL: MockData.seriesPosters[$0]) }
    }
    
    static func getMockData2() -> [SeriesPresenter] {
       return Array(0...3).map { SeriesPresenter(id: $0 + 9, posterURL: MockData.seriesPosters[$0 + 9]) }
    }
    
    static func load(offset: Int, quantity: Int) -> [SeriesPresenter]  {
        return Array(0..<quantity).map { SeriesPresenter(id: $0 + offset, posterURL: MockData.seriesPosters[$0 + offset]) }
    }
}
