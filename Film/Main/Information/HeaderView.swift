//
//  HeaderView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    static let identifier = "HeaderView"
    
    var posterPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        
        return imageView
    }()
    
    var exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .white
        label.font = FontStandard.RobotoBold(size: 20.0)
        
        return label
    }()
    
    var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1) // #E50914
        button.titleLabel?.font = FontStandard.RobotoBold(size: 15.0)
        
        return button
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .white
        
        return label
    }()
    
    
    class Constraints {
        
        static func setPosterPicture(_ imageView: UIImageView, _ parent: UIView) {
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 54.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 134.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 192.0).isActive = true
        }
        
        static func setExitButton(_ button: UIButton, _ parent: UIView) {
            button.topAnchor.constraint(equalTo: parent.topAnchor, constant: 30.0).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -15.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        }
        
        static func setTitleLabel(_ label: UILabel, _ topNeighbour: UIView) {
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            label.centerXAnchor.constraint(equalTo: topNeighbour.centerXAnchor).isActive = true
        }
        
        static func setPlayButton(_ button: UIButton, _ topNeighbour: UIView, parent: UIView) {
            button.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            button.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10.0).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        }
        
        static func setDescriptionLabel(_ label: UILabel, _ topNeighbour: UIView, parent: UIView) {
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10.0).isActive = true
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10.0).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom code for layout
        
        backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        addSubviewLayout(posterPicture)
        addSubviewLayout(exitButton)
        addSubviewLayout(titleLabel)
        addSubviewLayout(playButton)
        addSubviewLayout(descriptionLabel)
        
        Constraints.setPosterPicture(posterPicture, self)
        Constraints.setExitButton(exitButton, self)
        Constraints.setTitleLabel(titleLabel, posterPicture)
        Constraints.setPlayButton(playButton, titleLabel, parent: self)
        Constraints.setDescriptionLabel(descriptionLabel, playButton, parent: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
