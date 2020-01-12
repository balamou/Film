//
//  Film+mock.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-19.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

extension Film {
    static let testVideos = ["http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
                             "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4" ]
    
    static let serverVideos = ["Get out" : "http://192.168.72.59:3000/en/shows/E03.mkv",
                               "Rick and morty S1E1" : "http://192.168.72.59:3000/en/shows/E03.mkv",
                               "Westworld" : "http://192.168.72.59:3000/en/shows/E03.mkv"]
    
    static func provideMock() -> Film {
        return Film(id: 0, type: .show, URL: serverVideos["Rick and morty S1E1"] ?? testVideos[0])
    }
    
}
