//
//  WatchingView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class WatchingView: UIView {
    
    var vanityBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    var navBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    var tabLabel: UILabel = {
        let label = UILabel()
        label.text = "watching"
        label.textColor = .white
        label.font = UIFont(name: "RobotoCondensed-Bold", size: 21.0) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
       
        return label
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = ImageConstants.logoImage
        
        return imageView
    }()
    
    // IDLE
    var idleView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var idleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageConstants.idleImage
        
        return imageView
    }()
    
    var idleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing watched yet"
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.231372549, blue: 0.231372549, alpha: 1)
        label.font = UIFont(name: "RobotoCondensed-Bold", size: 25.0) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        
        return label
    }()
    
    class Constraints {
        
        static let navigationBarHeight: CGFloat = 67.0
        
        static func setVanityBar(_ view: UIView, _ parent: UIView) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        }
        
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
        
        // IDLE
        static func setIdleView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        }
        
        static func setIdleImage(_ imageView: UIImageView, _ parent: UIView) {
            imageView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setIdleLabel(_ label: UILabel, _ topNeighbour: UIView) {
            label.centerXAnchor.constraint(equalTo: topNeighbour.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 20.0).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        addSubviewLayout(vanityBar)
        addSubviewLayout(navBar)
        navBar.addSubviewLayout(tabLabel)
        navBar.addSubviewLayout(logoImage)
        
        addSubviewLayout(idleView)
        idleView.addSubviewLayout(idleImage)
        idleView.addSubviewLayout(idleLabel)
        
        Constraints.setVanityBar(vanityBar, self)
        Constraints.setNavBar(navBar, self)
        Constraints.setTabLabel(tabLabel, navBar)
        Constraints.setLogoImage(logoImage, tabLabel, navBar)
        
        Constraints.setIdleView(idleView, self)
        Constraints.setIdleImage(idleImage, idleView)
        Constraints.setIdleLabel(idleLabel, idleImage)
        
        idleView.bottomAnchor.constraint(equalTo: idleLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
