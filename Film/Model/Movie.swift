//
//  Movie.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-15.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


struct Movie: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let videoURL: String
    
    let description: String?
    let poster: String?
    let stoppedAt: Int?
        
    var percentViewed: Float {
        guard let stoppedAt = stoppedAt else { return 0 }
        
        return Float(stoppedAt)/Float(duration)
    }
}
