//
//  MoviesView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class MoviesView: UIView {
    
    lazy var navBar: CustomNavigationBar = {
        // automatically adds itself to the hiearchy
        return CustomNavigationBar(title: "movies".localize(), parent: self)
    }()
    
    class Constraints {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        let _ = navBar.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
