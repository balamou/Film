//
//  EndPoint.swift
//  Film
//
//  Created by Michel Balamou on 2019-11-17.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct RequestData {
    var baseURL: String
    var endPoint: EndPoint
    var method: HTTPMethod
    var data: Data?
}

enum EndPoint {
    case login(username: String)
    case signup(username: String)
    
    case watched(userId: Int)
    
    case shows(start: Int, quantity: Int, language: String)
    case movies(start: Int, quantity: Int, language: String)
    
    case show(showId: Int, season: Int)
    case episodes(showId: Int, userId: Int, season: Int)
    
    case movie(movieId: Int, userId: Int)
    
    /// `id` is movie id or episode id
    case updateStoppedAt(userId: Int, id: Int, type: FilmType)
    
    case nextEpisode(episodeId: Int, userId: Int)
    
    case timestamp(episodeId: Int)
    
    case videoURL(id: Int, type: FilmType)
    
    case posters
    
    var path: String {
        switch self {
        case let .login(username):
            return "/login/\(username)"
        case let .signup(username):
            return "/signup/\(username)"
            
        case let .watched(userId):
            return "/watched/\(userId)"
        case let .shows(start, quantity, language):
            return "/shows/\(start)/\(quantity)/\(language)"
        case let .movies(start, quantity, language):
            return "/movies/\(start)/\(quantity)/\(language)"
            
        case let .show(showId, season):
            return "/show/\(showId)/\(season)"
        case let .episodes(showId, userId, season):
            return "/episodes/\(showId)/\(userId)/\(season)"
            
        case let .movie(movieId, userId):
            return "/movie/\(movieId)/\(userId)"
        
        case let .updateStoppedAt(userId, id, type):
            return "/updateStoppedAt/\(userId)/\(id)/\(type)"
            
        case let .nextEpisode(episodeId, userId):
            return "/next_episode/\(episodeId)/\(userId)"
        
        case let .timestamp(episodeId):
            return "/episode_timestamps/\(episodeId)"
            
        case let .videoURL(id, type):
            return "/video_url/\(id)/\(type)"
        
        case .posters:
            return "/posters"
        }
    }
}
