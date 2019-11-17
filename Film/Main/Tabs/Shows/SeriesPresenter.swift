//
//  SeriesPresenter.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-31.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct SeriesPresenter {
    var id: Int
    var posterURL: String?
    
    init(id: Int, posterURL: String? = nil) {
        self.id = id
        self.posterURL = posterURL
    }
    
    init(_ watched: Watched) {
        self.id = watched.id
        self.posterURL = watched.posterURL
    }
}

