//
//  UIColor+extensions.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

extension UIColor {
    
    func setAlpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}
