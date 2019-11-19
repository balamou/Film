//
//  MockSeriesAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-18.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

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
