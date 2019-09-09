//
//  MockSeriesInfoAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-07.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

enum SeriesInfoError: Error {
    case badURL
    
    func getDescription() -> String {
        switch self {
        case .badURL:
            return "Bad url"
        }
    }
}


protocol SeriesInfoAPI {
    func getSeriesInfo(seriesId: Int, result: @escaping (Result<(Series, [Episode]), Error>) -> Void)
    func getEpisodes(seriesId: Int, season: Int, result: @escaping (Result<[Episode], Error>) -> Void)
}

class MockSeriesInfoAPI: SeriesInfoAPI {
    
    let simulatedDelay = 1.5
    
    func getSeriesInfo(seriesId: Int, result: @escaping (Result<(Series, [Episode]), Error>) -> Void) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) {
            result(.success((Series.getMock(), Episode.getMockArray())))
        }
    }
    
    func getEpisodes(seriesId: Int, season: Int, result: @escaping (Result<[Episode], Error>) -> Void) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) {
            
        }
    }
    
}


