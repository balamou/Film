//
//  WatchingCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class WatchingCell: UICollectionViewCell {
    
    static var identifier: String = "WatchingCell"
    
    var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        return imageView
    }()
    
    var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1) // #262626
        
        return view
    }()
    
    var stoppedAtView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1) // #E50914
        
        return view
    }()
    
    var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    var viewedLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        label.font = FontStandard.RobotoBold(size: 15.0)
        
        return label
    }()
    
    var informationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageConstants.informationImage
        
        return imageView
    }()
    
    class Constraints {
        
        static func setPosterImage(_ imageView: UIImageView, _ progressView: UIView, _ parent: UIView) {
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        }
        
        static func setProgressView(_ view: UIView, _ bottomNeighbour: UIView, _ parent: UIView) {
            view.bottomAnchor.constraint(equalTo: bottomNeighbour.topAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        }
        
        static func setStoppedAt(_ view: UIView, _ parent: UIView) {
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 0.5).isActive = true
        }
        
        
        static func setBottomBar(_ view: UIView, _ parent: UIView) {
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        }
        
        static func setViewedLabel(_ label: UILabel, _ parent: UIView) {
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 5.0).isActive = true
            label.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        }
        
        static func setInformationImage(_ imageView: UIImageView, _ parent: UIView) {
            imageView.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10.0).isActive = true
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        addSubviewLayout(bottomBar)
        addSubviewLayout(posterImage)
        bottomBar.addSubviewLayout(viewedLabel)
        addSubviewLayout(progressView)
        progressView.addSubviewLayout(stoppedAtView)
        bottomBar.addSubviewLayout(informationImage)
        
        Constraints.setBottomBar(bottomBar, self)
        Constraints.setViewedLabel(viewedLabel, bottomBar)
        Constraints.setProgressView(progressView, bottomBar, self)
        Constraints.setStoppedAt(stoppedAtView, progressView)
        Constraints.setInformationImage(informationImage, bottomBar)
        Constraints.setPosterImage(posterImage, progressView, self)
        
        reset()
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
