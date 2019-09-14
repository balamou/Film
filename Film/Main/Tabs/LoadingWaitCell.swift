//
//  LoadingCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-14.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class LoadingWaitCell: UICollectionViewCell {
    
    static let identifier: String = "LoadingWaitCell"
    
    var spinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        
        return activityIndicator
    }()
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading...".localize()
        label.textColor = .white // NOTE: this is about to be deprecated
        label.font = Fonts.RobotoCondensedBold(size: 18.0)
        
        return label
    }()
    
    class Constraints {
  
        static func setSpinner(_ activityIndicator: UIActivityIndicatorView, _ parent: UIView) {
            activityIndicator.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: -20).isActive = true
            activityIndicator.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setLoadingLabel(_ label: UILabel, _ topNeihgbour: UIView) {
            label.topAnchor.constraint(equalTo: topNeihgbour.bottomAnchor, constant: 10.0).isActive = true
            label.centerXAnchor.constraint(equalTo: topNeihgbour.centerXAnchor).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(spinner)
        addSubviewLayout(loadingLabel)
        
        Constraints.setSpinner(spinner, self)
        Constraints.setLoadingLabel(loadingLabel, spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

