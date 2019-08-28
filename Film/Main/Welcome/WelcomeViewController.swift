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
        
        dismissKey()
        
        welcomeView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func startButtonTapped() {
        print("Start tapped")
    }
    
    //----------------------------------------------------------------------
    // Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension WelcomeViewController {
    
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
