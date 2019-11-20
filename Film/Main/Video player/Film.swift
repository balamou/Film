//
//  Film.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


class Film {
    // Mandatory
    var id: Int
    var URL: String
    var duration: Int
    
    // Optional
    var stoppedAt: Int?
    var title: String?
    
    init(id: Int, URL: String, duration: Int) {
        self.id = id
        self.URL = URL
        self.duration = duration
    }
    
    func durationMin() -> String {
        return durationMin(seconds: duration)
    }
    
    func durationMin(seconds sec: Int) -> String
    {
        let hours: Int = sec / 3600
        let minutes: Int = (sec % 3600) / 60
        let seconds: Int = sec - minutes * 60
        
        if hours == 0 {
            return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        } else {
            return "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes))"
        }
    }
}


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
        return Film(id: 0, URL: serverVideos["Rick and morty S1E1"] ?? testVideos[0], duration: 15)
    }
    
}