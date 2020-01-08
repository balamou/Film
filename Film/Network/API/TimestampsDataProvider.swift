//
//  TimestampsDataProvider.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-08.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

protocol TimestampsDataProvider {
    func getEpisodeTimestamps(episodeId: Int, result: @escaping Handler<[VideoTimestamp]>)
//    func getMovieTimestamps(movieId: Int, result: @escaping Handler<VideoTimestamp>) // TODO: implement this method
}

class TimestampsNetworkProvider: TimestampsDataProvider {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getEpisodeTimestamps(episodeId: Int, result: @escaping Handler<[VideoTimestamp]>) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .timestamp(episodeId: episodeId), method: .get)
        let requestType = RequestType<[VideoTimestamp]>(data: requestData)
        
        requestType.execute(onSuccess: { timestamps in
            result(.success(timestamps))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
