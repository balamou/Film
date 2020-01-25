//
//  ShowCell.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class ShowCell: UICollectionViewCell {
    static let identifier = "ShowCell"
    
    var posterURL: String? = nil {
        didSet {
            posterImageView.image = nil
            if let url = posterURL {
//                posterImageView.loadImage(fromURL: url)
            }
        }
    }
    
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewLayout(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
