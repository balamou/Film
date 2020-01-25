//
//  UIView+extensions.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviewLayout(_ view: UIView){
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    func setGradient(colors: [UIColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        
        layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }
    
    func fillConstraints(in parent: UIView) {
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    }
}
