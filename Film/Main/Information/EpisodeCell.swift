//
//  EpisodeCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol EpisodeCellDelegate: AnyObject {
    func thumbnailTapped()
}

class EpisodeCell: UICollectionViewCell {
    
    static let identifier: String = "EpisodeCell"
    weak var delegate: EpisodeCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        
//        thumbnail.addTarget(self, action: #selector(thumbnailTapped), for: .touchUpInside)
        
        reset()
    }
    
    @objc func thumbnailTapped() {
        delegate?.thumbnailTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func reset() {
    }
    
}
