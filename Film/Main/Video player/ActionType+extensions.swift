//
//  ActionType+extensions.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-08.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

extension ActionType: Encodable {
    enum CodingKeys: String, CodingKey { // This is what the server will have
        case type
        case from
        case to
    }
    
    enum ActionTypeStatus: String, Codable { // This is what we will have
        case skip
        case nextEpisode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .skip(from: from, to: to):
            try container.encode(ActionTypeStatus.skip, forKey: .type)
            try container.encode(from, forKey: .from)
            try container.encode(to, forKey: .to)
        case let .nextEpisode(from: from):
            try container.encode(ActionTypeStatus.nextEpisode, forKey: .type)
            try container.encode(from, forKey: .from)
        }
    }
}

extension ActionType: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(ActionTypeStatus.self, forKey: .type)

        switch status {
        case .skip:
            let from = try container.decode(Int.self, forKey: .from)
            let to = try container.decode(Int.self, forKey: .to)
            self = .skip(from: from, to: to)
        case .nextEpisode:
            let from = try container.decode(Int.self, forKey: .from)
            self = .nextEpisode(from: from)
        }
    }
}
