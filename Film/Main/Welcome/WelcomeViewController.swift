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
    
    let settings: Settings
    let welcomeView: WelcomeView = WelcomeView()
    var alert: AlertViewController?
    
    init(settings: Settings) {
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = welcomeView
        alert = AlertViewController(parent: self)
        
        dismissKey()
        
        welcomeView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        welcomeView.languageField.text = settings.language
        welcomeView.ipAddressField.text = settings.ipAddress
        welcomeView.portField.text = settings.port
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
