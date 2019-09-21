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
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        isLogged = defaults.bool(forKey: "isLogged")
        username = defaults.string(forKey: "username")
        language = defaults.string(forKey: "language") ?? language
        ipAddress = defaults.string(forKey: "ipAddress") ?? ipAddress
        port = defaults.string(forKey: "port") ?? port
    }
    
    func saveToUserDefaults() {
        defaults.set(isLogged, forKey: "isLogged")
        defaults.set(username, forKey: "username")
        defaults.set(language, forKey: "language")
        defaults.set(ipAddress, forKey: "ipAddress")
        defaults.set(port, forKey: "port")
    }
    
    func description() -> String {
        var desc = "isLogged: \(isLogged)\n"
        desc += "username: \(String(describing: username))\n"
        desc += "language: \(language)\n"
        desc += "ipAddress: \(ipAddress)\n"
        desc += "port: \(port)"
        
        return desc
    }
}


