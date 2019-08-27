//
//  ShowsView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class ShowsView: UIView {
    
    lazy var navBar: CustomNavigationBar = {
        return CustomNavigationBar(title: "shows".localize())
    }()
    
    var showListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    class Constraints {
        
        static func setShowListCollectionView(_ collectionView: UICollectionView, _ navBar: UIView, _ parent: UIView) {
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
            collectionView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            collectionView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        
        addSubviewLayout(navBar)
        addSubviewLayout(showListCollectionView)
        
        navBar.setConstraints(parent: self)
        Constraints.setShowListCollectionView(showListCollectionView, navBar, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
