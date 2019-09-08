//
//  MockSeriesInfoAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-07.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol SeriesInfoAPI {
    func getSeriesInfo(result: @escaping (Result<Series, Error>) -> Void)
    func getEpisodes(season: Int, result: @escaping (Result<[Episode], Error>) -> Void)
}

class MockSeriesInfoAPI: SeriesInfoAPI {
    
    let simulatedDelay = 1.5
    static let abc = 10
    
    func getSeriesInfo(result: @escaping (Result<Series, Error>) -> Void) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) {
            
        }
    }
    
    func getEpisodes(season: Int, result: @escaping (Result<[Episode], Error>) -> Void) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) {
            
        }
    }
    
}


