//
//  ViewedContent+extensions.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-11.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

extension ViewedContent.ContentID: Encodable {
    enum CodingKeys: String, CodingKey { // This is what the server will have
        case type
        case id
        case showId
        case seasonNumber
        case episodeNumber
    }
    
    enum ContentIDStatus: String, Codable { // This is what we will have
        case movie
        case episode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .movie(id: id):
            try container.encode(ContentIDStatus.movie, forKey: .type)
            try container.encode(id, forKey: .id)
        case let .episode(id: id, showId: showId, seasonNumber: seasonNumber, episodeNumber: episodeNumber):
            try container.encode(ContentIDStatus.episode, forKey: .type)
            try container.encode(id, forKey: .id)
            try container.encode(showId, forKey: .showId)
            try container.encode(seasonNumber, forKey: .seasonNumber)
            try container.encode(episodeNumber, forKey: .episodeNumber)
        }
    }
}

extension ViewedContent.ContentID: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(ContentIDStatus.self, forKey: .type)

        switch status {
        case .movie:
            let id = try container.decode(Int.self, forKey: .id)
            self = .movie(id: id)
        case .episode:
            let id = try container.decode(Int.self, forKey: .id)
            let showId = try container.decode(Int.self, forKey: .showId)
            let seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
            let episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
            self = .episode(id: id, showId: showId, seasonNumber: seasonNumber, episodeNumber: episodeNumber)
        }
    }
}
