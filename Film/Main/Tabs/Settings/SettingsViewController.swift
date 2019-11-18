//
//  SettingsViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

struct Language {
    let localized: String
    let serverValue: String
    
    static var `default`: [Language] {
        return  ["english", "russian"].map { Language(localized: $0.localize(), serverValue: $0) }
    }
}

protocol SettingsViewControllerDelegate: class {
    func logOutPerformed()
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?
    
    let settings: Settings
    let settingsView: SettingsView = SettingsView()
    let languages = Language.default
    let pickerRowHeight: CGFloat = 30
    
    // Alert
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
        
        view = settingsView
        alert = AlertViewController(parent: self)
        dismissKey()
        
        setupActions()
        setupDataFromSettings()
    }
    
    func setupActions() {
        settingsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        settingsView.refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        settingsView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        let languageTapGesture = UITapGestureRecognizer(target: self, action: #selector(switchLanguages))
        settingsView.languageField.addGestureRecognizer(languageTapGesture)
    }
    
    func setupDataFromSettings() {
        settingsView.languageField.text = settings.language
        settingsView.ipAddressField.text = settings.ipAddress
        settingsView.portField.text = settings.port
        settingsView.pickerView.selectLanguage(settings.language)
    }
    
    //----------------------------------------------------------------------
    // MARK: Action
    //----------------------------------------------------------------------
    @objc func switchLanguages() {
        settingsView.togglePickerView()
    }
    
    @objc func saveButtonTapped() {
        let language = settingsView.languageField.text
        let ipAddress = settingsView.ipAddressField.text
        let port = settingsView.portField.text
        
        let errorMessages = [(language.isNilOrEmpty, message: "Please select language".localize()),
                            (ipAddress.isNilOrEmpty, message: "Please enter IP Address".localize()),
                            (port.isNilOrEmpty, message: "Please enter Port number".localize())]
        
        let firstFieldThatsNilOrEmpty = errorMessages.first(where: { $0.0 == true })
        
        if let errorMessage = firstFieldThatsNilOrEmpty?.message {
            alert?.mode = .showMessage(errorMessage)
            return
        }
        
        settings.language = language!
        settings.ipAddress = ipAddress!
        settings.port = port!
        
        settings.saveToUserDefaults()
        
        print(settings)
        
        alert?.mode = .success("Successfully saved")
    }
    
    @objc func refreshButtonTapped() {
        print("Refresh")
    }
    
    @objc func logoutButtonTapped() {
        settings.logout()
        delegate?.logOutPerformed()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        settingsView.languageField.text = settingsView.pickerView.languageSelected()
        settingsView.hidePickerView()
    }
}
