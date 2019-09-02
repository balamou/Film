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
    
    
    var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1) // #2F2F2F
        
        return imageView
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
    
    var episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "1. Episode 1"
        label.textColor = .white
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "57 min"
        label.textColor = .gray
        label.font = FontStandard.helveticaNeue(size: 12.0)
        
        return label
    }()
    
    var plotLabel: UILabel = {
        let label = UILabel()
        label.text = "Plot"
        label.textColor = .white
        label.font = FontStandard.helveticaNeue(size: 15.0)
        label.numberOfLines = 0
        label.textAlignment = .justified
        
        return label
    }()
    
    var playEpisodeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.playImage, for: .normal)
        
        return button
    }()
    
    
    class Constraints {
        
        static func setThumbnailView(_ imageView: UIImageView, _ parent: UIView) {
            imageView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 10.0).isActive = true
            imageView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 130.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        }
        
        static func setProgressView(_ view: UIView, _ topNeighbour: UIView) {
            view.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: topNeighbour.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        }
        
        static func setStoppedAtView(_ view: UIView, _ parent: UIView, progress: CGFloat) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: progress).isActive = true
        }
        
        static func setEpisodeTitleLabel(_ label: UILabel, _ leftNeighbour: UIView) {
            label.leadingAnchor.constraint(equalTo: leftNeighbour.trailingAnchor, constant: 10.0).isActive = true
            label.topAnchor.constraint(equalTo: leftNeighbour.topAnchor).isActive = true
        }

        static func setDurationLabel(_ label: UILabel, _ topNeighbour: UIView) {
            label.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor).isActive = true
        }
        
        static func setPlotLabel(_ label: UILabel, _ topNeighbour: UIView, _ parent: UIView) {
            label.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10.0).isActive = true
        }
        
        static func setPlayEpisodeButton(_ button: UIButton, _ thumnailView: UIView) {
            button.topAnchor.constraint(equalTo: thumnailView.topAnchor).isActive = true
            button.leadingAnchor.constraint(equalTo: thumnailView.leadingAnchor).isActive = true
            button.widthAnchor.constraint(equalTo: thumnailView.widthAnchor).isActive = true
            button.heightAnchor.constraint(equalTo: thumnailView.heightAnchor).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1) // #191919
        
        addSubviewLayout(thumbnail)
        addSubviewLayout(progressView)
        progressView.addSubviewLayout(stoppedAtView)
        addSubviewLayout(episodeTitleLabel)
        addSubviewLayout(durationLabel)
        addSubviewLayout(plotLabel)
        addSubviewLayout(playEpisodeButton)
        
        Constraints.setThumbnailView(thumbnail, self)
        Constraints.setProgressView(progressView, thumbnail)
        Constraints.setStoppedAtView(stoppedAtView, progressView, progress: 0.2)
        Constraints.setEpisodeTitleLabel(episodeTitleLabel, thumbnail)
        Constraints.setDurationLabel(durationLabel, episodeTitleLabel)
        Constraints.setPlotLabel(plotLabel, thumbnail, self)
        Constraints.setPlayEpisodeButton(playEpisodeButton, thumbnail)
        
        playEpisodeButton.addTarget(self, action: #selector(thumbnailTapped), for: .touchUpInside)
        
        reset()
    }
    
    func populate(episode: Episode) {
        
        episodeTitleLabel.text = episode.constructTitle()
        if let url = episode.thumbnailURL {
            thumbnail.downloaded(from: url)
        }
        durationLabel.text = episode.durationInMinutes()
        plotLabel.text = episode.plot
        
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
