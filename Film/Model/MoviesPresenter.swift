//
//  MoviesPresenter.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-01.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


class MoviesPresenter {
    
    var id: Int
    var posterURL: String?
    
    init(id: Int, posterURL: String? = nil) {
        self.id = id
        self.posterURL = posterURL
    }
    
}
