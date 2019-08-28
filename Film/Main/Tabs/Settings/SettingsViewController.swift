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
        
        settingsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        settingsView.refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        settingsView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        dismissKey()
    }
    
    //----------------------------------------------------------------------
    // MARK: Action
    //----------------------------------------------------------------------
    @objc func saveButtonTapped() {
        print("Save")
    }
    
    @objc func refreshButtonTapped() {
        print("Refresh")
    }
    
    @objc func logoutButtonTapped() {
        print("Logout")
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SettingsViewController {
    
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

