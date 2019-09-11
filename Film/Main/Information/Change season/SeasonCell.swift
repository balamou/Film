//
//  SeasonCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-10.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class SeasonCell: UICollectionViewCell {
    
    static let identifier: String = "SeasonCell"
    
    var seasonLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    class Constraints {
        
        static func setSeasonLabel(_ label: UILabel, _ parent: UIView) {
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(seasonLabel)
        
        Constraints.setSeasonLabel(seasonLabel, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
