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
    
    let textFieldRadius: CGFloat = 5
    
    var collapsableView = UIView()
    var pickerView: LanguagePickerView!
    
    var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.logoImage
        
        return imageView
    }()
    
    var topLabel: UILabel = {
        let label = UILabel()
        label.text = "film"
        label.textColor = .white
        label.font = Fonts.RobotoCondensedBold(size: 21.0)
        
        return label
    }()
    
    let verticalStackView = UIStackView()
    
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
    
    lazy var usernameField: CustomTextField = {
        let textField = CustomTextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "michelbalamou"
        textField.keyboardAppearance = .dark
        textField.layer.cornerRadius = textFieldRadius
        
        return textField
    }()
    
    lazy var languageField: CustomTextField = {
        let textField = CustomTextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "english"
        textField.keyboardAppearance = .dark
        textField.layer.cornerRadius = textFieldRadius
        
        return textField
    }()
    
    lazy var ipAddressField: CustomTextField = {
        let textField = CustomTextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "192.168.72.46"
        textField.keyboardAppearance = .dark
        textField.layer.cornerRadius = textFieldRadius
        
        return textField
    }()
    
    lazy var portField: CustomTextField = {
        let textField = CustomTextField()
        textField.backgroundColor = textFieldColor
        textField.textColor = .white
        textField.font = textFieldFont
        textField.text = "9989"
        textField.keyboardAppearance = .dark
        textField.layer.cornerRadius = textFieldRadius
        
        return textField
    }()
    
    // Buttons
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login".localize(), for: .normal)
        button.setTitle("Logging in...", for: .disabled)
        button.backgroundColor = .black
        button.titleLabel?.font = buttonsFont
        button.layer.cornerRadius = 4
        
        return button
    }()
    
    class Constraints {
        
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
        
        // Buttons
        
        static func setLoginButton(_ button: UIButton, _ topNeighbour: UIView, _ parent: UIView) {
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
        addSubviewLayout(loginButton)
        
        Constraints.setTopBar(topBar, self)
        Constraints.setLogoImageView(logoImage, topBar)
        Constraints.setTopLabel(topLabel, topBar)
        
        setupStackViews()
        
        Constraints.setLoginButton(loginButton, verticalStackView, self)
        
        collapsableView.isHidden = true
        let languageTapGesture = UITapGestureRecognizer(target: self, action: #selector(languagesTapped))
        languageField.addGestureRecognizer(languageTapGesture)
    }
    
    @objc func languagesTapped() {
        endEditing(true) // Dismiss keyboard
        
        UIView.animate(withDuration: 0.3) {
            let hiddenValue = self.collapsableView.isHidden
            self.collapsableView.isHidden.toggle()
            self.collapsableView.layer.opacity = hiddenValue ? 1.0 : 0.0
        }
    }
    
    func hideLanguagePicker() {
        guard !collapsableView.isHidden else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.collapsableView.isHidden = true
            self.collapsableView.layer.opacity = 0.0
        }
    }
    
    func setupStackViews() {
        verticalStackView.axis = .vertical
        addSubviewLayout(verticalStackView)
        
        let elements = [(usernameLabel, usernameField),
                        (languageLabel, languageField),
                        (ipAddressLabel, ipAddressField),
                        (portLabel, portField)]
        
        var counter = 0
        elements.forEach {
            if counter == 2 {
                pickerView = LanguagePickerView { [weak self] language in
                    self?.languageField.text = language
                }
                collapsableView.addSubviewLayout(pickerView)
                pickerView.fillConstraints(in: collapsableView)
                
                collapsableView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
                verticalStackView.addArrangedSubview(collapsableView)
            }
            
            let horizontalStackView = UIStackView()
            
            horizontalStackView.addArrangedSubview($0.0)
            horizontalStackView.addArrangedSubview($0.1)
            
            $0.0.widthAnchor.constraint(equalTo: $0.1.widthAnchor, multiplier: 0.5).isActive = true
            
            horizontalStackView.distribution = .fillProportionally
            horizontalStackView.isLayoutMarginsRelativeArrangement = true
            horizontalStackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
            
            verticalStackView.addArrangedSubview(horizontalStackView)
            counter += 1
        }
        
        verticalStackView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
