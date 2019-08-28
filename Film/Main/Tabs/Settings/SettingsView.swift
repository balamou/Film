//
//  SettingsView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    let labelTextColor = #colorLiteral(red: 0.2352941176, green: 0.231372549, blue: 0.231372549, alpha: 1) // #3C3B3B
    let labelFont = FontStandard.helveticaBold(size: 18.0)
    
    let textFieldColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1) // #242424
    let textFieldFont = FontStandard.helveticaNeue(size: 16.0)
    
    let buttonsColor =  #colorLiteral(red: 0.3254901961, green: 0.3254901961, blue: 0.3254901961, alpha: 1) // #5363BE
    let buttonsFont = FontStandard.RobotoBold(size: 15.0)
   
    
    lazy var navBar: CustomNavigationBar = {
        return CustomNavigationBar(title: "settings".localize())
    }()
    
    // Labels
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username".localize()
        label.font = labelFont
        label.textColor = labelTextColor
        
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language".localize()
        label.font = labelFont
        label.textColor = labelTextColor
        
        return label
    }()
    
    lazy var ipAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "IP Address".localize()
        label.font = labelFont
        label.textColor = labelTextColor
        
        return label
    }()
    
    lazy var portLabel: UILabel = {
        let label = UILabel()
        label.text = "Port".localize()
        label.font = labelFont
        label.textColor = labelTextColor
        
        return label
    }()
    
    // Textfields
    
    lazy var usernameField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "michelbalamou"
        textField.isEnabled = false
        textField.keyboardAppearance = .dark
        
        return textField
    }()
    
    lazy var languageField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "english"
        textField.keyboardAppearance = .dark
        
        return textField
    }()
    
    lazy var ipAddressField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "192.168.72.46"
        textField.keyboardAppearance = .dark
        
        return textField
    }()
    
    lazy var portField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "9989"
        textField.keyboardAppearance = .dark
        
        return textField
    }()
    
    // Buttons
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save".localize(), for: .normal)
        button.backgroundColor = buttonsColor
        button.titleLabel?.font = buttonsFont
        
        return button
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh".localize(), for: .normal)
        button.backgroundColor = buttonsColor
        button.titleLabel?.font = buttonsFont
        
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout".localize(), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1) // #E50914
        button.titleLabel?.font = buttonsFont
        
        return button
    }()
    
    class Constraints {
        
        static let textFieldHeight: CGFloat = 30.0
        static var distanceBetweenFields: CGFloat = 15.0
        static let buttonsMargin: CGFloat = 20.0
        
        // Labels
        
        static func setUsernameLabel(_ label: UILabel, _ parent: UIView, _ leftNeighbour: UIView) {
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 15.0).isActive = true
            label.centerYAnchor.constraint(equalTo: leftNeighbour.centerYAnchor).isActive = true
        }
        
        static func setLanguageLabel(_ label: UILabel, _ parent: UIView, _ leftNeighbour: UIView) {
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 15.0).isActive = true
            label.centerYAnchor.constraint(equalTo: leftNeighbour.centerYAnchor).isActive = true
        }
        
        static func setIPAddressLabel(_ label: UILabel, _ parent: UIView, _ leftNeighbour: UIView) {
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 15.0).isActive = true
            label.centerYAnchor.constraint(equalTo: leftNeighbour.centerYAnchor).isActive = true
        }
        static func setPortLabel(_ label: UILabel, _ parent: UIView, _ leftNeighbour: UIView) {
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 15.0).isActive = true
            label.centerYAnchor.constraint(equalTo: leftNeighbour.centerYAnchor).isActive = true
        }
        
        // Fields
        static func setUsernameTextField(_ textfield: UITextField, _ topNeighbour: UIView) {
            textfield.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: distanceBetweenFields).isActive = true
            textfield.leadingAnchor.constraint(equalTo: topNeighbour.centerXAnchor, constant: -50.0).isActive = true
            textfield.trailingAnchor.constraint(equalTo: topNeighbour.trailingAnchor, constant: -20.0).isActive = true
            textfield.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        }
        
        static func setLanguageTextField(_ textfield: UITextField, _ topNeighbour: UIView) {
            textfield.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: distanceBetweenFields).isActive = true
            textfield.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            textfield.trailingAnchor.constraint(equalTo: topNeighbour.trailingAnchor).isActive = true
            textfield.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        }
        
        static func setIPAddressTextField(_ textfield: UITextField, _ topNeighbour: UIView) {
            textfield.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: distanceBetweenFields).isActive = true
            textfield.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            textfield.trailingAnchor.constraint(equalTo: topNeighbour.trailingAnchor).isActive = true
            textfield.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        }
        
        static func setPortTextField(_ textfield: UITextField, _ topNeighbour: UIView) {
            textfield.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: distanceBetweenFields).isActive = true
            textfield.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            textfield.trailingAnchor.constraint(equalTo: topNeighbour.trailingAnchor).isActive = true
            textfield.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        }
        
        // Buttons
        
        static func setSaveButton(_ button: UIButton, _ topNeighbour: UIView, _ parent: UIView) {
            button.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: buttonsMargin).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -buttonsMargin).isActive = true
        }
        
        static func setLogoutButton(_ button: UIButton, _ parent: UIView) {
            button.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -20.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: buttonsMargin).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -buttonsMargin).isActive = true
        }
        
        static func setRefreshButton(_ button: UIButton, _ bottomNeighbour: UIView, _ parent: UIView) {
            button.bottomAnchor.constraint(equalTo: bottomNeighbour.topAnchor, constant: -10.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: buttonsMargin).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -buttonsMargin).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        addSubviewLayout(navBar)
        addSubviewLayout(usernameLabel)
        addSubviewLayout(languageLabel)
        addSubviewLayout(ipAddressLabel)
        addSubviewLayout(portLabel)
        
        addSubviewLayout(usernameField)
        addSubviewLayout(languageField)
        addSubviewLayout(ipAddressField)
        addSubviewLayout(portField)
        
        addSubviewLayout(saveButton)
        addSubviewLayout(refreshButton)
        addSubviewLayout(logoutButton)
        
        navBar.setConstraints(parent: self)
        Constraints.setUsernameLabel(usernameLabel, self, usernameField)
        Constraints.setLanguageLabel(languageLabel, self, languageField)
        Constraints.setIPAddressLabel(ipAddressLabel, self, ipAddressField)
        Constraints.setPortLabel(portLabel, self, portField)
        
        Constraints.setUsernameTextField(usernameField, navBar)
        Constraints.setLanguageTextField(languageField, usernameField)
        Constraints.setIPAddressTextField(ipAddressField, languageField)
        Constraints.setPortTextField(portField, ipAddressField)
        
        Constraints.setSaveButton(saveButton, portField, self)
        Constraints.setLogoutButton(logoutButton, self)
        Constraints.setRefreshButton(refreshButton, logoutButton, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
