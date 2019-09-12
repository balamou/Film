//
//  ChangeSeasonView.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-09.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class ChangeSeasonView: UIView {
    
    var seasonCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    var exitSeasonSelectorButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.closeImage, for: .normal)
        
        return button
    }()
    
    class Constraints {
        
        static let bottomButtonOffset: CGFloat = 20
        static let exitButtonSize: CGFloat = 30
        
        static func setSeasonCollectionView(_ collectionView: UICollectionView, _ parent: UIView) {
            collectionView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        }
        
        static func setExitSeasonSelectorButton(_ button: UIButton, _ parent: UIView) {
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -bottomButtonOffset).isActive = true
            button.widthAnchor.constraint(equalToConstant: exitButtonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: exitButtonSize).isActive = true
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .gray
        setBlur()
        
        addSubviewLayout(seasonCollectionView)
        addSubviewLayout(exitSeasonSelectorButton)
        
        Constraints.setSeasonCollectionView(seasonCollectionView, self)
        Constraints.setExitSeasonSelectorButton(exitSeasonSelectorButton, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBlur() {
        guard !UIAccessibility.isReduceTransparencyEnabled else { return }
        
        backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        addSubviewLayout(blurEffectView)
        blurEffectView.fillConstraints(in: self)
    }
}

