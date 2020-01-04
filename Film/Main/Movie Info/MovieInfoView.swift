//
//  MovieInfoView.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-15.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol MovieViewDelegate: class {
    func playButtonTapped()
    func exitButtonTapped()
}

class MovieInfoView: UIView {
    weak var delegate: MovieViewDelegate?
    static let descriptionFont = Fonts.generateFont(font: "OpenSans-Regular", size: 14)
    var stoppedAtAnchor = NSLayoutConstraint()
    
    
    var posterPicture: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        return imageView
    }()
    
    var exitButton: CustomMarginButton = {
        let button = CustomMarginButton(margin: 40)
        button.setImage(Images.Player.closeImage, for: .normal)
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title".localize()
        label.textColor = .white
        label.font = Fonts.helveticaNeue(size: 20.0)
        
        return label
    }()
    
    var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play".localize(), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1) // #E50914
        button.titleLabel?.font = Fonts.RobotoBold(size: 15.0)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        
        return button
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description".localize()
        label.textColor = .white
        label.font = descriptionFont
        label.numberOfLines = 0
        
        return label
    }()
    
    var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    var stoppedAtView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    class Constraints {
        
        static let padding: CGFloat = 10
        
        static func setPosterPicture(_ imageView: UIImageView, _ parent: UIView) {
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 54.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 134.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 192.0).isActive = true
        }
        
        static func setExitButton(_ button: UIButton, _ parent: UIView) {
            button.topAnchor.constraint(equalTo: parent.topAnchor, constant: 30.0).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -15.0).isActive = true
        }
        
        static func setTitleLabel(_ label: UILabel, _ topNeighbour: UIView) {
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            label.centerXAnchor.constraint(equalTo: topNeighbour.centerXAnchor).isActive = true
        }
        
        static func setPlayButton(_ button: UIButton, _ topNeighbour: UIView, parent: UIView) {
            button.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            button.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10.0).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        }
        
        static func setDescriptionLabel(_ label: UILabel, _ topNeighbour: UIView, parent: UIView) {
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10.0).isActive = true
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10.0).isActive = true
        }
        
        static func setProgressView(_ view: UIView, _ topNeighbour: UIView, _ parent: UIView) {
             view.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 15.0).isActive = true
             view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: padding).isActive = true
             view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -padding).isActive = true
             view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        }
        
        static func setStoppedAt(_ view: UIView, _ parent: UIView) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1) // #191919
        
        addSubviewLayout(posterPicture)
        addSubviewLayout(exitButton)
        addSubviewLayout(titleLabel)
        addSubviewLayout(playButton)
        addSubviewLayout(progressView)
        progressView.addSubviewLayout(stoppedAtView)
        addSubviewLayout(descriptionLabel)
        
        Constraints.setPosterPicture(posterPicture, self)
        Constraints.setExitButton(exitButton, self)
        Constraints.setTitleLabel(titleLabel, posterPicture)
        Constraints.setPlayButton(playButton, titleLabel, parent: self)
        Constraints.setProgressView(progressView, playButton, self)
        Constraints.setStoppedAt(stoppedAtView, progressView)
        Constraints.setDescriptionLabel(descriptionLabel, progressView, parent: self)
        
        stoppedAtAnchor = stoppedAtView.widthAnchor.constraint(equalTo: progressView.widthAnchor, multiplier: 0.5)
        stoppedAtAnchor.isActive = true
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        progressView.isHidden = true
    }

    func changeStoppedAtMultiplier(_ multiplier: Float) {
        playButton.setTitle("Resume".localize(), for: .normal)
        progressView.isHidden = false
        stoppedAtAnchor.isActive = false
        stoppedAtAnchor = stoppedAtView.widthAnchor.constraint(equalTo: progressView.widthAnchor, multiplier: CGFloat(multiplier))
        stoppedAtAnchor.isActive = true
        layoutIfNeeded()
    }
    
    @objc func exitButtonTapped() {
        delegate?.exitButtonTapped()
    }
    
    @objc func playButtonTapped() {
        delegate?.playButtonTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
