//
//  MockSeriesInfoAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-18.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class MockSeriesInfoAPI: SeriesInfoAPI {
    let simulatedDelay = 1.5
    static var count = 0
    var count2 = 0
    
    func getSeriesInfo(seriesId: Int, result: @escaping Handler<(Series, [Episode])>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) {
            if MockSeriesInfoAPI.count == 2 {
                result(.failure(ConnectionError.invalidURL))
            } else {
                result(.success((Series.getMock(), Episode.getMockArray())))
            }
            
            MockSeriesInfoAPI.count += 1
        }
    }
    
    func getEpisodes(seriesId: Int, season: Int, result: @escaping Handler<[Episode]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) { [weak self] in
            if self?.count2 == 2 {
                result(.failure(ConnectionError.invalidURL))
            } else {
                result(.success(Episode.getMockArray()))
            }
            
            self?.count2 += 1
        }
    }
    
}

