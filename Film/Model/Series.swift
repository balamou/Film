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
                         "https://cdn.shopify.com/s/files/1/0191/7850/products/RICKMORTY_45_-_COVER_A_SOLICIT_WEB_1024x.jpg?v=1546446607",
                         "https://mir-s3-cdn-cf.behance.net/project_modules/disp/2cd7d911377377.560f6bdfb0dab.jpg",
        "https://m.media-amazon.com/images/M/MV5BNWNmYzQ1ZWUtYTQ3ZS00Y2UwLTlkMDctZThlOTJkMGJiNzBiXkEyXkFqcGdeQXVyNjg2NjQwMDQ@._V1_.jpg",
        "https://m.media-amazon.com/images/M/MV5BN2UwNDc5NmEtNjVjZS00OTI5LWE5YjctMWM3ZjBiZGYwMGI2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg",
        "https://cdn.flickeringmyth.com/wp-content/uploads/2019/02/vice.jpg",
        "https://m.media-amazon.com/images/M/MV5BMjIxMjgxNTk0MF5BMl5BanBnXkFtZTgwNjIyOTg2MDE@._V1_.jpg",
            "https://honeydoze.com/wp-content/uploads/2017/03/the-social-network.jpg"]
        
        return [SeriesPresenter(id: 0, posterURL: imageURLs[0]),
                SeriesPresenter(id: 1, posterURL: imageURLs[1]),
                SeriesPresenter(id: 2, posterURL: imageURLs[2]),
                SeriesPresenter(id: 3, posterURL: imageURLs[3]),
                SeriesPresenter(id: 4, posterURL: imageURLs[4]),
                SeriesPresenter(id: 5, posterURL: imageURLs[5]),
                SeriesPresenter(id: 6, posterURL: imageURLs[6]),
                SeriesPresenter(id: 7, posterURL: imageURLs[7]),
                SeriesPresenter(id: 8, posterURL: imageURLs[8])]
    }
    
}
