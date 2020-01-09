//
//  NextEpisodeProvider.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-05.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

protocol NextEpisodeProvider {
    func getNextEpisode(episodeId: Int, result: @escaping Handler<Film>)
}

class NextEpisodeNetworkProvider: NextEpisodeProvider {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getNextEpisode(episodeId: Int, result: @escaping Handler<Film>) {
        guard let userId = settings.userId else {
            result(.failure(ConnectionError.custom("UserId is nil")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .nextEpisode(episodeId: episodeId, userId: userId), method: .get)
        let requestType = RequestType<Film>(data: requestData)
        
        requestType.execute(onSuccess: { film in
            var _film = film
            _film.fixURL(with: self.settings.createPath)
                
            result(.success(_film))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
