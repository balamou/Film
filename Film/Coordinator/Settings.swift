//
//  Settings.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-31.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


class Settings: CustomStringConvertible {
    private var defaults: UserDefaults
    
    var isLogged = false
    var username: String?
    var userId: Int?
    var language = "english"
    var ipAddress = "192.168.72.46"
    var port = "9989"
    
    var basePath: String {
        return "http://\(ipAddress):\(port)"
    }
    
    var description: String {
        return """
        isLogged:  \(isLogged)
        userId:    \(userId.description)
        username:  \(username.description)
        language:  \(language)
        ipAddress: \(ipAddress)
        port:      \(port)
        """
    }
    
    enum Keys {
        static let isLogged = "film.isLogged"
        static let username = "film.username"
        static let userId = "film.userId"
        static let language = "film.language"
        static let ipAddress = "film.ipAddress"
        static let port = "film.port"
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        isLogged = defaults.bool(forKey: Keys.isLogged)
        userId = defaults.integer(forKey: Keys.userId)
        username = defaults.string(forKey: Keys.username)
        language = defaults.string(forKey: Keys.language) ?? language
        ipAddress = defaults.string(forKey: Keys.ipAddress) ?? ipAddress
        port = defaults.string(forKey: Keys.port) ?? port
    }
    
    func saveToUserDefaults() {
        defaults.set(isLogged, forKey: Keys.isLogged)
        defaults.set(userId, forKey: Keys.userId)
        defaults.set(username, forKey: Keys.username)
        defaults.set(language, forKey: Keys.language)
        defaults.set(ipAddress, forKey: Keys.ipAddress)
        defaults.set(port, forKey: Keys.port)
    }
    
    func logout() {
        copy(self, Settings.default)
        saveToUserDefaults()
    }
    
    func createPath(with path: String?) -> String? {
        guard let path = path else {
            return nil
        }
        
        return "\(basePath)/\(path)"
    }
}

extension Settings {
    
    static var `default`: Settings {
        let settings = Settings()
        settings.isLogged = false
        settings.userId = nil
        settings.username = nil
        settings.language = "english"
        settings.ipAddress = "192.168.72.46"
        settings.port = "9989"
        
        return settings
    }
    
    func copy(_ lhs: Settings, _ rhs: Settings) {
        lhs.isLogged = rhs.isLogged
        lhs.userId = rhs.userId
        lhs.username = rhs.username
        lhs.language = rhs.language
        lhs.ipAddress = rhs.ipAddress
        lhs.port = rhs.port
    }
    
}
