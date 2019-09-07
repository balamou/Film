//
//  IdleCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-31.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class IdleCell: UICollectionViewCell {
    
    static let identifier: String = "IdleCell"
    
    var idleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.idleImage
        
        return imageView
    }()
    
    var idleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing watched yet".localize()
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.231372549, blue: 0.231372549, alpha: 1)
        label.font = Fonts.RobotoCondensedBold(size: 25.0)
        
        return label
    }()
    
    class Constraints {
        
        static func setIdleImage(_ imageView: UIImageView, _ parent: UIView) {
            imageView.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: -40.0).isActive = true
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setIdleLabel(_ label: UILabel, _ topNeighbour: UIView) {
            label.centerXAnchor.constraint(equalTo: topNeighbour.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 20.0).isActive = true
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(idleImage)
        addSubviewLayout(idleLabel)
        
        Constraints.setIdleImage(idleImage, self)
        Constraints.setIdleLabel(idleLabel, idleImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

