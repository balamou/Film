//
//  ShowsView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ShowsViewDelegate: AnyObject {
    func refreshCollectionView(completion: @escaping () -> ())
}


class ShowsView: UIView {

    weak var delegate: ShowsViewDelegate?
    
    lazy var navBar: CustomNavigationBar = {
        return CustomNavigationBar(title: "shows".localize(), showLogo: true)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        addSubviewLayout(navBar)
        navBar.setConstraints(parent: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
