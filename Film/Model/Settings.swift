//
//  Settings.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-31.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import Foundation


class Settings {
    private var defaults: UserDefaults
    
    var isLogged = false
    var username: String?
    var language = "english"
    var ipAddress = "192.168.72.46"
    var port = "9989"
    
    var basePath: String {
        return "http://\(ipAddress):\(port)"
    }
    
    enum Keys {
        static let isLogged = "film.isLogged"
        static let username = "film.username"
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
        username = defaults.string(forKey: Keys.username)
        language = defaults.string(forKey: Keys.language) ?? language
        ipAddress = defaults.string(forKey: Keys.ipAddress) ?? ipAddress
        port = defaults.string(forKey: Keys.port) ?? port
    }
    
    func saveToUserDefaults() {
        defaults.set(isLogged, forKey: Keys.isLogged)
        defaults.set(username, forKey: Keys.username)
        defaults.set(language, forKey: Keys.language)
        defaults.set(ipAddress, forKey: Keys.ipAddress)
        defaults.set(port, forKey: Keys.port)
    }
    
    func description() -> String {
        var desc = "isLogged: \(isLogged)\n"
        desc += "username: \(String(describing: username))\n"
        desc += "language: \(language)\n"
        desc += "ipAddress: \(ipAddress)\n"
        desc += "port: \(port)"
        
        return desc
    }
    
    func logout() {
        copy(self, Settings.default)
        saveToUserDefaults()
    }
}

extension Settings {
    
    static var `default`: Settings {
        let settings = Settings()
        settings.isLogged = false
        settings.username = nil
        settings.language = "english"
        settings.ipAddress = "192.168.72.46"
        settings.port = "9989"
        
        return settings
    }
    
    func copy(_ lhs: Settings, _ rhs: Settings) {
        lhs.isLogged = rhs.isLogged
        lhs.language = rhs.language
        lhs.ipAddress = rhs.ipAddress
        lhs.port = rhs.port
    }
    
}


