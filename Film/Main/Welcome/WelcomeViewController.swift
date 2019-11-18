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
        welcomeView.signUpButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        dismissKey()
        configureWithSettings()
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
        guard let username = welcomeView.usernameField.text, !username.isEmpty else {
            alert?.mode = .showMessage("Please enter a username".localize())
            return
        }
        
        signup(username: username)
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
        
        captureServerInfoFromFields()
        
        apiManager?.login(username: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userId):
                if userId > 0 {
                    self.updateSettings(with: userId, isLogged: true)
                    
                    self.delegate?.onSuccessfullLogin()
                } else {
                    self.alert?.mode = .showMessage("Username does not exist")
                }
            case .failure(let error):
                self.alert?.mode = .showMessage(error.toString)
            }
            
            self.welcomeView.loginButton.isEnabled = true
        }
    }
    
    func signup(username: String) {
        welcomeView.signUpButton.isEnabled = false
        
        captureServerInfoFromFields()
        
        apiManager?.signUp(username: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userId):
                if userId > 0 {
                    self.updateSettings(with: userId, isLogged: true)
                    
                    self.delegate?.onSuccessfullLogin()
                } else {
                    self.alert?.mode = .showMessage("Username does not exist")
                }
            case .failure(let error):
                self.alert?.mode = .showMessage(error.toString)
            }
            
            self.welcomeView.signUpButton.isEnabled = true
        }
    }
    
    func captureServerInfoFromFields() {
        settings.ipAddress = welcomeView.ipAddressField.text!
        settings.port = welcomeView.portField.text!
    }
    
    func updateSettings(with userId: Int, isLogged: Bool) {
        settings.isLogged = isLogged
        settings.userId = userId
        settings.username = welcomeView.usernameField.text!
        settings.language = welcomeView.languageField.text!
        settings.ipAddress = welcomeView.ipAddressField.text!
        settings.port = welcomeView.portField.text!
        settings.saveToUserDefaults()
    }
    
}

extension WelcomeViewController {
    
    func dismissKey() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        welcomeView.hideLanguagePicker()
    }
}
