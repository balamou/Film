//
//  ShowsCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class ShowsCell: UICollectionViewCell {
    
    static let identifier: String = "ShowsCell"
    static let cellSize = CGSize(width: 110, height: 160) 
    
    var posterURL: String? = nil {
        didSet {
            if let url = posterURL {
                posterImageView.downloaded(from: url)
            }
        }
    }
    
    
    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    class Constraints {
        
        static func setPosterImageView(_ imageView: UIImageView, _ parent: UIView) {
            imageView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        addSubviewLayout(posterImageView)
        
        Constraints.setPosterImageView(posterImageView, self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
