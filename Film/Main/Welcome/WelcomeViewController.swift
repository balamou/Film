//
//  WelcomeViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol WelcomeViewControllerDelegate: AnyObject {
    func startButtonTapped()
}


class WelcomeViewController: UIViewController {
    weak var delegate: WelcomeViewControllerDelegate?
    
    var welcomeView: WelcomeView = WelcomeView()
    var alert: AlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = welcomeView
        alert = AlertViewController(parent: self)
        
        dismissKey()
        
        welcomeView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc func startButtonTapped() {
        // TODO: check credentials/server availability
        delegate?.startButtonTapped()
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
