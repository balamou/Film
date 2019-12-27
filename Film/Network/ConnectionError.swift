//
//  ConnectionError.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-19.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

enum ConnectionError: Error {
    case invalidURL
    case noData
    case emptyResponse
    case invalidJSON
    case custom(String)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data"
        case .emptyResponse:
            return "Empty Response"
        case .invalidJSON:
            return "Returned invalid json"
        case .custom(let description):
            return description
        }
    }
}

extension Error {
    var toString: String {
        if let error = self as? ConnectionError {
            return error.description
        }
        
        if let _ = self as? DecodingError {
            return "Decoding error"
        }
        
        return self.localizedDescription // Unknown error
    }
}
