//
//  CustomTextField.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-15.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
