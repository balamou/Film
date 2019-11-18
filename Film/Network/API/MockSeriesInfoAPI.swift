//
//  MockSeriesInfoAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-07.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol SeriesInfoAPI {
    func getSeriesInfo(seriesId: Int, result: @escaping Handler<(Series, [Episode])>)
    func getEpisodes(seriesId: Int, season: Int, result: @escaping Handler<[Episode]>)
}

class ConcreteSeriesInfoAPI: SeriesInfoAPI {
    private let settings: Settings
    
    private struct WrapperSeries: Decodable {
        let series: Series
        let episodes: [Episode]
    }
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getSeriesInfo(seriesId: Int, result: @escaping Handler<(Series, [Episode])>) {
        guard let userId = settings.userId else {
            result(.failure(ConnectionError.custom("UserId is nil")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .show(showId: seriesId, userId: userId), method: .get)
        let requestType = RequestType<WrapperSeries>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            result(.success((data.series, data.episodes)))
        }, onError: { error in
            result(.failure(error))
        })
    }
    
    func getEpisodes(seriesId: Int, season: Int, result: @escaping Handler<[Episode]>) {
        
    }
}

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


