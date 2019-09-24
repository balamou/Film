//
//  ShowInfoView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class ShowInfoView: UIView {
    
    var episodesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1) // #191919
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    class Constraints {
        
        static func setEpisodesCollectionView(_ collectionView: UICollectionView, _ parent: UIView) {
            collectionView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            collectionView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            collectionView.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(episodesCollectionView)
        Constraints.setEpisodesCollectionView(episodesCollectionView, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

