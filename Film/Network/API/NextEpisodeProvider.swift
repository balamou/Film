//
//  NextEpisodeProvider.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-05.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

enum NextEpisodeResult {
    case film(Film)
    case noMoreEpisodes
}

protocol NextEpisodeProvider {
    func getNextEpisode(episodeId: Int, result: @escaping Handler<NextEpisodeResult>)
}

class NextEpisodeNetworkProvider: NextEpisodeProvider {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    struct Wrapper: Decodable {
        var isLastEpisode: Bool
        var film: Film?
    }
    
    func getNextEpisode(episodeId: Int, result: @escaping Handler<NextEpisodeResult>) {
        guard let userId = settings.userId else {
            result(.failure(ConnectionError.custom("UserId is nil")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .nextEpisode(episodeId: episodeId, userId: userId), method: .get)
        let requestType = RequestType<Wrapper>(data: requestData)
        
        requestType.execute(onSuccess: { wrapped in
            if var _film = wrapped.film {
                _film.fixURL(with: self.settings.createPath)
                result(.success(.film(_film)))
                return
            }
                
            result(.success(.noMoreEpisodes))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
