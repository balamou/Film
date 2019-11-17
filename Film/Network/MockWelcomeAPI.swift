//
//  MockWelcomeAPI.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-21.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

protocol WelcomeAPI {
    func signUp(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func login(username: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class MockWelcomeAPI: WelcomeAPI {
    
    let timeDelay = 1.5
    var count = 0
    
    func signUp(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
            completion(.success(true))
        }
        
    }
    
    func login(username: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeDelay) {
            let didLoginSuccessfully = username == "michelbalamou" ? true : false
            completion(.success(didLoginSuccessfully))
        }
    }
    
    
    
}
