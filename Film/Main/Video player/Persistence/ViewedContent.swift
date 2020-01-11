//
//  ViewedContent.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-09.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

struct ViewedContent {
    enum ViewedContent {
        struct EpisodeContent {
            let id: Int
            let showId: Int
            /// used to match to the proper show in the database
            let showTitle: String
            /// used to match seasons in `ShowInfoVC`
            let seasonNumber: Int
            /// used to match episodes in `ShowInfoVC`
            let episodeNumber: Int
        }
        
        case movie(id: Int, title: String)
        case episode(id: Int, episode: EpisodeContent)
    }
    
    /// content viewed
    let content: ViewedContent
    /// date initially played the content
    let intialPlayTime: Date
    /// date last played the content
    let lastPlayedTime: Date
    /// position in the content
    let position: Int
    /// duration of the content
    let duration: Int
}
