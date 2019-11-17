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
    
}

//----------------------------------------------------------------------
// TODO: Implement and test Concrete API
//----------------------------------------------------------------------
final class ConcreteSeriesAPI: SeriesAPI {
    
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func getSeries(start: Int, quantity: Int, result: @escaping SeriesRequest) {
        networkCall(start: start, quantity: quantity) { data in
            DispatchQueue.main.async {
                result(data)
            }
        }
    }
    
    private func networkCall(start: Int, quantity: Int, result: @escaping SeriesRequest) {
        let randomError = NSError(domain: "hehe", code: 0, userInfo: nil)
        let path = "\(settings.basePath)/shows/hehe"
        
        guard let url = URL(string: path) else {
            result(.failure(randomError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                result(.failure(randomError))
                return
            }
            
            guard let response = response else {
                // TODO: handle empty response
                return
            }
            
            print(response)
            
            guard let data = data else {
                result(.failure(randomError))
                return
            }
            
            print(data)
            
            do {
                let seriesPresenter = try JSONDecoder().decode([SeriesPresenter].self, from: data)
                print(seriesPresenter)
                let res = (seriesPresenter, true)
                result(.success(res))
            } catch {
                result(.failure(randomError))
            }
        }.resume()
    }
}
