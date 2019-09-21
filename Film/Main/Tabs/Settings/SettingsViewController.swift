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
        
        settingsView.pickerView.dataSource = self
        settingsView.pickerView.delegate = self
        
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
        
        let indexOfLanguageSelected = languages.firstIndex { $0.serverValue == settings.language } ?? 0
        settingsView.pickerView.selectRow(indexOfLanguageSelected, inComponent: 0, animated: false)
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

        if let errorMessage = errorMessages.first(where: { $0.0 == true })?.message {
            alert?.mode = .showMessage(errorMessage)
            return
        }
        
        settings.language = language!
        settings.ipAddress = ipAddress!
        settings.port = port!
        
        settings.saveToUserDefaults()
        
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
        let tap = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        let row = settingsView.pickerView.selectedRow(inComponent: 0)
        settingsView.languageField.text = languages[row].localized
        settingsView.hidePickerView()
    }
}


extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settingsView.languageField.text = languages[row].localized
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerRowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].localized
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let language = languages[row].localized
        let component = NSAttributedString(string: language, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        return component
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
}
