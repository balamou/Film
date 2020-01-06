//
//  CustomHeightSlider.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-03.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class CustomHeightSlider: UISlider {
    private let trackHeight: CGFloat
    
    init(trackHeight: CGFloat) {
        self.trackHeight = trackHeight
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = trackHeight
        return newBounds
    }
}
