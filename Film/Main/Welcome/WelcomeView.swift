//
//  WelcomeView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    let labelTextColor = #colorLiteral(red: 0.2352941176, green: 0.231372549, blue: 0.231372549, alpha: 1) // #3C3B3B
    let labelFont = Fonts.helveticaBold(size: 18.0)
    
    let textFieldColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1) // #242424
    let textFieldFont = Fonts.helveticaNeue(size: 16.0)
    
    let buttonsColor =  #colorLiteral(red: 0.3254901961, green: 0.3254901961, blue: 0.3254901961, alpha: 1) // #5363BE
    let buttonsFont = Fonts.RobotoBold(size: 15.0)
    
    
    var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageConstants.logoImage
        
        return imageView
    }()
    
    var topLabel: UILabel = {
        let label = UILabel()
        label.text = "film"
        label.textColor = .white
        label.font = Fonts.RobotoCondensedBold(size: 21.0)
        
        return label
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
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start".localize(), for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = buttonsFont
        
        return button
    }()
    
    class Constraints {
        
        static let textFieldHeight: CGFloat = 30.0
        static var distanceBetweenFields: CGFloat = 15.0
        static let buttonsMargin: CGFloat = 20.0
        
        static func setTopBar(_ view: UIView, _ parent: UIView) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 198.0).isActive = true
        }
        
        static func setLogoImageView(_ imageView: UIImageView, _ parent: UIView) {
            imageView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 50.0).isActive = true
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 87.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 87.0).isActive = true
        }
        
        static func setTopLabel(_ label: UILabel, _ parent: UIView) {
            label.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -10.0).isActive = true
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
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
        
        static func setStartButton(_ button: UIButton, _ topNeighbour: UIView, _ parent: UIView) {
            button.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 60.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: buttonsMargin).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -buttonsMargin).isActive = true
        }
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        addSubviewLayout(topBar)
        topBar.addSubviewLayout(logoImage)
        topBar.addSubviewLayout(topLabel)
        addSubviewLayout(usernameLabel)
        addSubviewLayout(languageLabel)
        addSubviewLayout(ipAddressLabel)
        addSubviewLayout(portLabel)
        
        addSubviewLayout(usernameField)
        addSubviewLayout(languageField)
        addSubviewLayout(ipAddressField)
        addSubviewLayout(portField)
        
        addSubviewLayout(startButton)
        
        Constraints.setTopBar(topBar, self)
        Constraints.setLogoImageView(logoImage, topBar)
        Constraints.setTopLabel(topLabel, topBar)
        Constraints.setUsernameLabel(usernameLabel, self, usernameField)
        Constraints.setLanguageLabel(languageLabel, self, languageField)
        Constraints.setIPAddressLabel(ipAddressLabel, self, ipAddressField)
        Constraints.setPortLabel(portLabel, self, portField)
        
        Constraints.setUsernameTextField(usernameField, topBar)
        Constraints.setLanguageTextField(languageField, usernameField)
        Constraints.setIPAddressTextField(ipAddressField, languageField)
        Constraints.setPortTextField(portField, ipAddressField)
        
        Constraints.setStartButton(startButton, portField, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
