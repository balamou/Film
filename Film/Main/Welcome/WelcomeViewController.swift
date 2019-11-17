//
//  WelcomeViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol WelcomeViewControllerDelegate: class {
    func onSuccessfullLogin()
}


class WelcomeViewController: UIViewController {
    weak var delegate: WelcomeViewControllerDelegate?
    
    let settings: Settings
    let welcomeView: WelcomeView = WelcomeView()
    var apiManager: WelcomeAPI?
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
        
        welcomeView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        dismissKey()
        configureWithSettings()
        
        let languageTapGesture = UITapGestureRecognizer(target: self, action: #selector(languagesTapped))
        welcomeView.languageField.addGestureRecognizer(languageTapGesture)
    }
    
    @objc func languagesTapped() {
        UIView.animate(withDuration: 0.3) {
            let hiddenValue = self.welcomeView.collapsableView.isHidden
            self.welcomeView.collapsableView.isHidden.toggle()
            self.welcomeView.collapsableView.layer.opacity = hiddenValue ? 1.0 : 0.0
        }
    }
    
    func configureWithSettings() {
        welcomeView.languageField.text = settings.language
        welcomeView.ipAddressField.text = settings.ipAddress
        welcomeView.portField.text = settings.port
    }
    
    // TODO: rename to login
    @objc func loginButtonTapped() {
        guard let username = welcomeView.usernameField.text, !username.isEmpty else {
            alert?.mode = .showMessage("Please enter a username".localize())
            return
        }
        
        login(username: username)
    }
    
    @objc func signupButtonTapped() {
        
    }
    
    //----------------------------------------------------------------------
    // Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//----------------------------------------------------------------------
// Mark: API calls
//----------------------------------------------------------------------
extension WelcomeViewController {
    
    func login(username: String) {
        welcomeView.loginButton.isEnabled = (apiManager == nil)
        
        apiManager?.login(username: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let doesUserExist):
                if doesUserExist {
                    self.settings.username = username
                    self.settings.isLogged = true
                    
                    self.delegate?.onSuccessfullLogin()
                } else {
                    self.alert?.mode = .showMessage("Username does not exist")
                }
                break
            case .failure(_):
                // TODO: show specific error
                self.alert?.mode = .showMessage("An error occured")
                break
            }
            
            self.welcomeView.loginButton.isEnabled = true
        }
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