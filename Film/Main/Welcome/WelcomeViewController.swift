//
//  WelcomeViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController {
    
    var welcomeView: WelcomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView = WelcomeView()
        view = welcomeView
    }
}
