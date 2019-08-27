//
//  WatchingView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class WatchingView: UIView {
    
    lazy var navBar: CustomNavigationBar = {
        return CustomNavigationBar(title: "watching".localize(), showLogo: true)
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
        label.text = "Nothing watched yet".localize()
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.231372549, blue: 0.231372549, alpha: 1)
        label.font = FontStandard.RobotoCondensedBold(size: 25.0)
        
        return label
    }()
    
    class Constraints {
        
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
        
        addSubviewLayout(navBar)
        navBar.setConstraints(parent: self)
        
        addSubviewLayout(idleView)
        idleView.addSubviewLayout(idleImage)
        idleView.addSubviewLayout(idleLabel)
        
        Constraints.setIdleView(idleView, self)
        Constraints.setIdleImage(idleImage, idleView)
        Constraints.setIdleLabel(idleLabel, idleImage)
        
        idleView.bottomAnchor.constraint(equalTo: idleLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
