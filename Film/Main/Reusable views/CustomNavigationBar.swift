//
//  Custom.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class CustomNavigationBar: UIView {
    
    var navBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    var tabLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = .white
        label.font = Fonts.RobotoCondensedBold(size: 21.0)
        
        return label
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = ImageConstants.logoImage
        
        return imageView
    }()
    
    class Constraints {
        
        static let navigationBarHeight: CGFloat = 67.0
        
        static func set(_ view: UIView, parent: UIView) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        }
        
        //
        
        static func setNavBar(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: navigationBarHeight).isActive = true
        }
        
        static func setTabLabel(_ label: UILabel, _ parent: UIView) {
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        }
        
        static func setLogoImage(_ imageView: UIImageView, _ rightNeighbour: UIView, _ parent: UIView) {
            imageView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 15.0).isActive = true
            imageView.centerYAnchor.constraint(equalTo: rightNeighbour.centerYAnchor).isActive = true
            
            imageView.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubviewLayout(navBar)
        navBar.addSubviewLayout(tabLabel)
        navBar.addSubviewLayout(logoImage)
        
        Constraints.setNavBar(navBar, self)
        Constraints.setTabLabel(tabLabel, navBar)
        Constraints.setLogoImage(logoImage, tabLabel, navBar)
    }
    
    convenience init(title: String, showLogo: Bool = false) {
        self.init()
        tabLabel.text = title
        
        logoImage.isHidden = !showLogo
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setConstraints(parent: UIView) {
        Constraints.set(self, parent: parent)
        self.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    }
}
