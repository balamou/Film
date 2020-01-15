//
//  VideoURLProvider.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

struct MovieWrapper: Decodable {
    let id: Int
    let title: String
    var videoURL: String
    let duration: Int
    
    mutating func fixURL(urlFixer: (String?) -> String?) {
        videoURL = urlFixer(videoURL) ?? videoURL
    }
}

struct EpisodeWrapper: Decodable {
    let id: Int
    let showTitle: String
    let showId: Int
    
    let episodeTitle: String?
    var videoURL: String
    let duration: Int
    let seasonNumber: Int
    let episodeNumber: Int
    
    mutating func fixURL(urlFixer: (String?) -> String?) {
        videoURL = urlFixer(videoURL) ?? videoURL
    }
}

protocol VideoURLProvider {
    func getMovieData(id: Int, result: @escaping Handler<MovieWrapper>)
    func getEpisodeData(id: Int, result: @escaping Handler<EpisodeWrapper>)
}

class VideoURLNetworkProvider: VideoURLProvider {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getMovieData(id: Int, result: @escaping Handler<MovieWrapper>) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .videoURL(id: id, type: .movie), method: .get)
        let requestType = RequestType<MovieWrapper>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            var _data = data
            _data.fixURL(urlFixer: self.settings.createPath)
            
            result(.success(_data))
        }, onError: { error in
            result(.failure(error))
        })
    }
    
    func getEpisodeData(id: Int, result: @escaping Handler<EpisodeWrapper>) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .videoURL(id: id, type: .show), method: .get)
        let requestType = RequestType<EpisodeWrapper>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            var _data = data
            _data.fixURL(urlFixer: self.settings.createPath)
            
            result(.success(_data))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
