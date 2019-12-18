//
//  MockSeriesInfoAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-07.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol SeriesInfoAPI {
    func getSeriesInfo(seriesId: Int, result: @escaping Handler<(Series, [Episode], [Int])>)
    func getEpisodes(seriesId: Int, season: Int, result: @escaping Handler<[Episode]>)
}

class ConcreteSeriesInfoAPI: SeriesInfoAPI {
    private let settings: Settings
    
    private struct WrapperSeries: Decodable {
        let series: Series
        let episodes: [Episode]
        let availableSeasons: [Int]
    }
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func fixURL(episodes: [Episode], urlFixer: (String?) -> String?) -> [Episode] {
        return episodes.map { episode -> Episode in
            var episodeCopy = episode
            episodeCopy.fixURL(with: urlFixer)
            return episodeCopy
        }
    }
    
    func getSeriesInfo(seriesId: Int, result: @escaping Handler<(Series, [Episode], [Int])>) {
        guard let userId = settings.userId else {
            result(.failure(ConnectionError.custom("UserId is nil")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .show(showId: seriesId, userId: userId), method: .get)
        let requestType = RequestType<WrapperSeries>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            let episodeData = self.fixURL(episodes: data.episodes, urlFixer: self.settings.createPath)
            
            result(.success((data.series, episodeData, data.availableSeasons)))
        }, onError: { error in
            result(.failure(error))
        })
    }
    
    func getEpisodes(seriesId: Int, season: Int, result: @escaping Handler<[Episode]>) {
        guard let userId = settings.userId else {
            result(.failure(ConnectionError.custom("UserId is nil")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .episodes(showId: seriesId, userId: userId, season: season), method: .get)
        let requestType = RequestType<[Episode]>(data: requestData)
        
        requestType.execute(onSuccess: { episodes in
            let episodeData = self.fixURL(episodes: episodes, urlFixer: self.settings.createPath)
            
            result(.success(episodeData))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
