//
//  WatchingCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class WatchingCell: UICollectionViewCell {
    
    static var identifier: String = "WatchingCell"
    
    lazy var viewedLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        
        return label
    }()
    
    
    class Constraints {
        
        static func setViewedLabel(_ label: UILabel, _ parent: UIView) {
            label.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -5.0).isActive = true
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubviewLayout(viewedLabel)
        
        Constraints.setViewedLabel(viewedLabel, self)
        
        reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
        viewedLabel.textAlignment = .center
    }
}
