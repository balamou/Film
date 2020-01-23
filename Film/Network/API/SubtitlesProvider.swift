//
//  SubtitlesProvider.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-22.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

struct SubtitleItem: Decodable {
    let id: String
    let startTime: Int
    let endTime: Int
    let text: String
}

protocol SubtitlesProvider {
    func getSubtitles(seriesId: Int, seasonNumber: Int, episodeNumber: Int, result: @escaping Handler<[SubtitleItem]>)
}

class SubtitlesNetworkProvider: SubtitlesProvider {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getSubtitles(seriesId: Int, seasonNumber: Int, episodeNumber: Int, result: @escaping Handler<[SubtitleItem]>) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .subtitles(seriesId: seriesId, seasonNumber: seasonNumber, episodeNumber: episodeNumber), method: .get)
        let requestType = RequestType<[SubtitleItem]>(data: requestData)
        
        requestType.execute(onSuccess: { subtitles in
            result(.success(subtitles))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
