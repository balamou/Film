//
//  ShowInfoView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol ShowInfoViewDelegate: class {
    func didTapExit()
}


class ShowInfoView: UIView {
    
    weak var delegate: ShowInfoViewDelegate?
    
    var episodesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1) // #191919
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    var exitButton: CustomMarginButton = {
        let button = CustomMarginButton(margin: 20)
        button.setImage(Images.ShowInfo.exitImage, for: .normal)
        
        return button
    }()
    
    class Constraints {
        
        static func setEpisodesCollectionView(_ collectionView: UICollectionView, _ parent: UIView) {
            collectionView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            collectionView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            collectionView.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        }
        
        static func setExitButton(_ button: UIButton, _ parent: UIView) {
            button.topAnchor.constraint(equalTo: parent.topAnchor, constant: 30).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(episodesCollectionView)
        addSubviewLayout(exitButton)
        
        Constraints.setEpisodesCollectionView(episodesCollectionView, self)
        Constraints.setExitButton(exitButton, self)
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
    }
    
    @objc func exitButtonTapped() {
        delegate?.didTapExit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

