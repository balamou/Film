//
//  MockWelcomeAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-21.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

typealias LoginHandler = (Result<Int, Error>) -> Void

protocol WelcomeAPI {
    func signUp(username: String, result: @escaping LoginHandler)
    func login(username: String, result: @escaping LoginHandler)
}

class ConcreteWelcomeAPI: WelcomeAPI {
    private let settings: Settings
    
    private struct WelcomeWrapper: Decodable {
        let userId: Int?
        let error: String?
    }
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func signUp(username: String, result: @escaping LoginHandler) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .signup(username: username), method: .get)
        let requestType = RequestType<WelcomeWrapper>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            guard let userId = data.userId else {
                result(.failure(ConnectionError.custom(data.error ?? "Error no user id")))
                return
            }
            
            result(.success(userId))
        }, onError: { error in
            result(.failure(error))
        })
    }
    
    func login(username: String, result: @escaping LoginHandler) {
        let requestData = RequestData(baseURL: settings.basePath, endPoint: .login(username: username), method: .get)
        let requestType = RequestType<WelcomeWrapper>(data: requestData)
        
        requestType.execute(onSuccess: { data in
            guard let userId = data.userId else {
                result(.failure(ConnectionError.custom(data.error ?? "Error no user id")))
                return
            }
            
            result(.success(userId))
        }, onError: { error in
            result(.failure(error))
        })
    }
}
