//
//  ViewedContent.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-09.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

struct ViewedContent: Codable {
    enum ContentID {
        case movie(id: Int)
        case episode(id: Int, showId: Int, seasonNumber: Int, episodeNumber: Int)
    }

    /// id of the content viewed
    let id: ContentID
    /// TItle of the content viewed (used to matching it to the right show/movie id after backup)
    let title: String
    /// date initially played the content
    let intialPlayTime: Date
    /// date last played the content
    let lastPlayedTime: Date
    /// position in the content
    let position: Int
    /// duration of the content
    let duration: Int
}
