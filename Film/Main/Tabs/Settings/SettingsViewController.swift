//
//  SettingsViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    var settingsView: SettingsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView = SettingsView()
        view = settingsView
    }
}
