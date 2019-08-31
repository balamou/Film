//
//  CustomButton.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class CustomMarginButton: UIButton {
    var margin: CGFloat = 10.0
    
    // increase touch area for control in all directions by margin
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let biggerFrame = bounds.insetBy(dx: -margin, dy: -margin)
        
        return biggerFrame.contains(point)
    }
}
