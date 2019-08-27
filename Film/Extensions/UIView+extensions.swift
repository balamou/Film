//
//  UIView+extensions.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviewLayout(_ view: UIView){
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    func setGradient(colors: [UIColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        
        self.layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }
}
