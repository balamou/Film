//
//  PostersProvider.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

struct ContentInfo: Encodable {
    let type: FilmType
    let id: Int
}

struct Poster: Decodable {
    let type: FilmType
    let id: Int
    var posterURL: String
    
    mutating func fixURL(urlFixer: @escaping (String?) -> String?) {
        posterURL = urlFixer(posterURL) ?? posterURL
    }
}

protocol PostersProvider {
    func getPosters(data: [ContentInfo], result: @escaping Handler<[Poster]>)
}

class PostersNetworkProvider: PostersProvider {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getPosters(data: [ContentInfo], result: @escaping Handler<[Poster]>) {
        guard let encodedData = try? JSONEncoder().encode(data) else {
            result(.failure(ConnectionError.custom("Unable to encode data")))
            return
        }
        
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .posters, method: .post, data: encodedData)
        let requestType = RequestType<[Poster]>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            var _data: [Poster] = []
            data.forEach {
                var newPoster = $0
                newPoster.fixURL(urlFixer: self.settings.createPath)
                _data.append(newPoster)
            }
            
            result(.success(_data))
        }, onError: { error in
            result(.failure(error))
        })
    }

}
