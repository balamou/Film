//
//  MockWelcomeAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-18.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class MockWelcomeAPI: WelcomeAPI {
    let timeDelay = 1.5
    var count = 0
    
    func signUp(username: String, result: @escaping LoginHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
            result(.success(1))
        }
    }
    
    func login(username: String, result: @escaping LoginHandler) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
            let didLoginSuccessfully = username == "michelbalamou" ? 1 : -1
            result(.success(didLoginSuccessfully))
        }
    }
}
