//
//  HeaderView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol HeaderViewDelegate: AnyObject {
    func exitButtonTapped()
    func playButtonTapped()
    func seasonButtonTapped()
}


class HeaderView: UICollectionReusableView {
    
    static let identifier = "HeaderView"
    weak var delegate: HeaderViewDelegate?
    var posterURL: String? = nil {
        didSet {
            if let url = posterURL {
                posterPicture.downloaded(from: url)
            }
        }
    }
    
    
    
    var posterPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        return imageView
    }()
    
    var exitButton: CustomMarginButton = {
        let button = CustomMarginButton()
        button.margin = 40.0
        button.backgroundColor = .red
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .white
        label.font = FontStandard.helveticaNeue(size: 20.0)
        
        return label
    }()
    
    var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.03529411765, blue: 0.07843137255, alpha: 1) // #E50914
        button.titleLabel?.font = FontStandard.RobotoBold(size: 15.0)
        
        return button
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = FontStandard.helveticaNeue(size: 14.0)
        
        return label
    }()
    
    var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    var seasonButton: UIButton = {
        let button = UIButton()
        button.setTitle("Season 1", for: .normal)
        button.titleLabel?.textColor = .white
        
        return button
    }()
    
    class Constraints {
        
        static func setPosterPicture(_ imageView: UIImageView, _ parent: UIView) {
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 54.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 134.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 192.0).isActive = true
        }
        
        static func setExitButton(_ button: UIButton, _ parent: UIView) {
            button.topAnchor.constraint(equalTo: parent.topAnchor, constant: 30.0).isActive = true
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -15.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
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
        
        static func setDividerView(_ view: UIView, _ topNeighbour: UIView, parent: UIView) {
            view.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        }
        
        static func setSeasonButton(_ button: UIButton, _ topNeighbour: UIView, parent: UIView) {
            button.topAnchor.constraint(equalTo: topNeighbour.topAnchor, constant: 10.0).isActive = true
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom code for layout
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1) // #191919
        
        addSubviewLayout(posterPicture)
        addSubviewLayout(exitButton)
        addSubviewLayout(titleLabel)
        addSubviewLayout(playButton)
        addSubviewLayout(descriptionLabel)
        addSubviewLayout(dividerView)
        addSubviewLayout(seasonButton)
        
        Constraints.setPosterPicture(posterPicture, self)
        Constraints.setExitButton(exitButton, self)
        Constraints.setTitleLabel(titleLabel, posterPicture)
        Constraints.setPlayButton(playButton, titleLabel, parent: self)
        Constraints.setDescriptionLabel(descriptionLabel, playButton, parent: self)
        Constraints.setDividerView(dividerView, descriptionLabel, parent: self)
        Constraints.setSeasonButton(seasonButton, dividerView, parent: self)
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        seasonButton.addTarget(self, action: #selector(seasonButtonTapped), for: .touchUpInside)
    }
    
    func populateData(series: Series) {
        
        titleLabel.text = series.title
        descriptionLabel.text = series.description ?? ""
        posterURL = series.posterURL
        let seasonSelected = "Season".localize() + " \(series.seasonSelected)"
        seasonButton.setTitle(seasonSelected, for: .normal)
        
    }
    
    @objc func exitButtonTapped() {
        delegate?.exitButtonTapped()
    }
    
    @objc func playButtonTapped() {
        delegate?.playButtonTapped()
    }
    
    @objc func seasonButtonTapped() {
        delegate?.seasonButtonTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
