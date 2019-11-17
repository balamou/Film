//
//  MockAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

typealias SeriesRequest = Handler< ([SeriesPresenter], Bool) >

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
        let showsData: [SeriesPresenter]
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


class MockSeriesAPI: SeriesAPI {
    var count = 0
    let timeDelay = 1.5
    
    func getSeries(start: Int, quantity: Int, result: @escaping SeriesRequest) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay, execute: { [weak self] in
            guard let self = self else { return }
            
            if self.count == 2 {
                result(.failure(ConnectionError.invalidURL))
                self.count += 1
                return
            }
            
            let data: [SeriesPresenter]
            if self.count == 4 {
                data = SeriesPresenter.getMockData2()
            } else if self.count == 3 {
                data = []
            } else {
                data = SeriesPresenter.getMockData()
            }
            
            let isLast = (start >= 2 * 9)
            
            result(.success((data, isLast)))
            
            if start == 2 * 9 + 4 {
                self.count = 0
            } else {
                self.count += 1
            }
        })
    }
}

