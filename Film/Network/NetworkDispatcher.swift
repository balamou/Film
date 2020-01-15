//
//  NetworkDispatcher.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-17.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}

/// The sole purpose of **URLSessionNetworkDispatcher** is to take your request data and execute it.
///
/// The **RequestData** contains all the information to reach a REST end point, which is the base URL,
/// path to the end point, HTTP method and the parameters.
final class URLSessionNetworkDispatcher: NetworkDispatcher {
    static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        guard var url = URL(string: request.baseURL) else {
            onError(ConnectionError.invalidURL)
            return
        }
        
        url.appendPathComponent(request.endPoint.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if case .post = request.method {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = request.data
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            guard let _ = response else {
                onError(ConnectionError.emptyResponse)
                return
            }
            
            guard let data = data else {
                onError(ConnectionError.noData)
                return
            }
            
            onSuccess(data)
        }.resume()
    }
}
