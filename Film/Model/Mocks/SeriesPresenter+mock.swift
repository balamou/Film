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
        return [SeriesPresenter(id: 0, posterURL: MockData.seriesPosters[0]),
                SeriesPresenter(id: 1, posterURL: MockData.seriesPosters[1]),
                SeriesPresenter(id: 2, posterURL: MockData.seriesPosters[2]),
                SeriesPresenter(id: 3, posterURL: MockData.seriesPosters[3]),
                SeriesPresenter(id: 4, posterURL: MockData.seriesPosters[4]),
                SeriesPresenter(id: 5, posterURL: MockData.seriesPosters[5]),
                SeriesPresenter(id: 6, posterURL: MockData.seriesPosters[6]),
                SeriesPresenter(id: 7, posterURL: MockData.seriesPosters[7]),
                SeriesPresenter(id: 8, posterURL: MockData.seriesPosters[8])]
    }
    
    
    static func getMockData2() -> [SeriesPresenter] {
        return [SeriesPresenter(id: 0, posterURL: MockData.seriesPosters[9]),
                SeriesPresenter(id: 1, posterURL: MockData.seriesPosters[10]),
                SeriesPresenter(id: 2, posterURL: MockData.seriesPosters[11]),
                SeriesPresenter(id: 3, posterURL: MockData.seriesPosters[12])]
    }
}
