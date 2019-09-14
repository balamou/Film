//
//  MockAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

typealias SeriesRequest = (Result<([SeriesPresenter], Bool), Error>) -> Void

protocol SeriesAPI {
    func getSeries(start: Int, quantity: Int, result: @escaping SeriesRequest)
}

class MockSeriesAPI: SeriesAPI {
    
    var count = 0
    let timeDelay = 1.5
    
    func getSeries(start: Int, quantity: Int, result: @escaping SeriesRequest) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay, execute: { [weak self] in
            guard let self = self else { return }
            
            if self.count == 2 {
                result(.failure(NSError(domain: "Error", code: 0, userInfo: nil)))
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
    
    func getSeriesDeprecated(start: Int, quantity: Int, result: @escaping ([SeriesPresenter], _ isLast: Bool, _ error: String?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay, execute: { [weak self] in
            let error: String? = self?.count == 2 || self?.count == 3 ? "Could not load" : nil
            let data = self?.count == 4 ? SeriesPresenter.getMockData2() : SeriesPresenter.getMockData()
            let isLast = (start >= 2 * 9)
            
            result(data, isLast, error)
            
            if start == 2 * 9 + 4 {
                self?.count = 0
            } else {
                self?.count += 1
            }
        })
    }
}
