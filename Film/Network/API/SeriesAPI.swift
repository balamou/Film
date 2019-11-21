//
//  MockAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

typealias SeriesRequest = Handler< ([SeriesItem], Bool) >

protocol SeriesAPI {
    func getSeries(start: Int, quantity: Int, result: @escaping SeriesRequest)
}

//----------------------------------------------------------------------
// TODO: Test Concrete API
//----------------------------------------------------------------------
final class ConcreteSeriesAPI: SeriesAPI {
    
    private let settings: Settings
    
    /// Wrapper used to separate two values from the JSON data.
    /// Both are used independently of each other, but are encoded together (see code below)
    private struct SeriesWrapper: Decodable {
        let showsData: [SeriesItem]
        let isLast: Bool
    }
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getSeries(start: Int, quantity: Int, result: @escaping SeriesRequest) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .shows(start: start, quantity: quantity, language: settings.language), method: .get)
        let request = RequestType<SeriesWrapper>(data: requestData)
        
        request.execute(onSuccess: { data in
            result(.success((data.showsData, data.isLast)))
        }, onError: { error in
            result(.failure(error))
        })
    }
}

