//
//  CGRect+extensions.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


extension CGRect {
    
    func addToWidth(_ value: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.size.width + value, height: self.size.height)
    }
}
