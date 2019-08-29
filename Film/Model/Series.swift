//
//  Show.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-28.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

class Series {
    
    
    
}

class SeriesPresenter {
    
    var id: Int
    var posterURL: String?
    
    init(id: Int, posterURL: String? = nil) {
        self.id = id
        self.posterURL = posterURL
    }
    
    static func getMockData() -> [SeriesPresenter] {
        let imageURLs = ["https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_PRESENTS_V1_-_COVER_B_FNL_WEB_1024x.jpg?v=1559159173",
                         "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_PRESENTS_V1_-_COVER_A_FNL_WEB_1024x.jpg?v=1559158092",
                         "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_45_-_COVER_A_SOLICIT_WEB_1024x.jpg?v=1546446607"]
        
        return [SeriesPresenter(id: 0, posterURL: imageURLs[0]),
                SeriesPresenter(id: 1, posterURL: imageURLs[1]),
                SeriesPresenter(id: 2, posterURL: imageURLs[2])]
    }
    
}
