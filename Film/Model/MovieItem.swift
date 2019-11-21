//
//  MovieItem.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-01.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

struct MovieItem: Decodable {
    var id: Int
    var posterURL: String?
}
