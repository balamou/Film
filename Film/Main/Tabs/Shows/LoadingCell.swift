//
//  LoadingCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    
    static var identifier = "LoadingCell"
    
    var spinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        
        return activityIndicator
    }()
    
    class Constants {
        
        static func setSpinnder(_ activityIndicator: UIActivityIndicatorView, _ parent: UIView) {
            activityIndicator.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(spinner)
        
        Constants.setSpinnder(spinner, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

