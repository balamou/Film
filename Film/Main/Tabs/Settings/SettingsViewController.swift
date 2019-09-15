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
}

class SettingsViewController: UIViewController {
    
    var settingsView: SettingsView = SettingsView()
    var languages = [Language(localized: "english".localize(), serverValue: "english"),
                    Language(localized: "russian".localize(), serverValue: "russian")]
    let pickerRowHeight: CGFloat = 30
    
    // Alert
    var alert: AlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = settingsView
        alert = AlertViewController(parent: self)
        
        
        settingsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        settingsView.refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        settingsView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        dismissKey()
        
        settingsView.pickerView.dataSource = self
        settingsView.pickerView.delegate = self
        
        let languageTapGesture = UITapGestureRecognizer(target: self, action: #selector(switchLanguages))
        settingsView.languageField.addGestureRecognizer(languageTapGesture)
    }
    
    //----------------------------------------------------------------------
    // MARK: Action
    //----------------------------------------------------------------------
    @objc func switchLanguages() {
        settingsView.togglePickerView()
    }
    
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
