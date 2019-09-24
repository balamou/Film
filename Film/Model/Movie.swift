//
//  Movie.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-15.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


struct Movie: Decodable {
    
    var id: Int
    var title: String
    var duration: Int
    
    var description: String?
    var poster: String?
    var stoppedAt: Int?
    
    init(id: Int,
         title: String,
         duration: Int,
         description: String? = nil,
         poster: String? = nil,
         stoppedAt: Int? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.poster = poster
        self.stoppedAt = stoppedAt
    }
    
    func stoppedAtRatio() -> CGFloat {
        guard let stoppedAt = stoppedAt else { return 0 }
        
        return CGFloat(stoppedAt)/CGFloat(duration)
    }
}
