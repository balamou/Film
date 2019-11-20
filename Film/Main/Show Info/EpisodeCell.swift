//
//  EpisodeCell.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol EpisodeCellDelegate: class {
    func thumbnailTapped()
}

class EpisodeCell: UICollectionViewCell {
    
    static let identifier: String = "EpisodeCell"
    weak var delegate: EpisodeCellDelegate?
    var stoppedAtConstraint: NSLayoutConstraint?
    
    static let plotFont = Fonts.generateFont(font: "OpenSans-Regular", size: 14)
    static let maximumPlotCharacters = 180
    
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
        label.font = Fonts.helveticaNeue(size: 12.0)
        
        return label
    }()
    
    var plotLabel: UILabel = {
        let label = UILabel()
        label.text = "Plot"
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) // #999999
        label.font = EpisodeCell.plotFont
        label.numberOfLines = 0
        
        return label
    }()
    
    var playEpisodeButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.ShowInfo.playEpisode, for: .normal)
        
        return button
    }()
    
    
    class Constraints {
        
        static let margins: CGFloat = 16
        
        static func setThumbnailView(_ imageView: UIImageView, _ parent: UIView) {
            imageView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 10.0).isActive = true
            imageView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: margins).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 130.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        }
        
        static func setProgressView(_ view: UIView, _ topNeighbour: UIView) {
            view.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: topNeighbour.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        }
        
        static func setStoppedAtView(_ view: UIView, _ parent: UIView) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        }
        
        static func setEpisodeTitleLabel(_ label: UILabel, _ leftNeighbour: UIView, _ parent: UIView) {
            label.leadingAnchor.constraint(equalTo: leftNeighbour.trailingAnchor, constant: 10.0).isActive = true
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -margins).isActive = true
            label.topAnchor.constraint(equalTo: leftNeighbour.topAnchor).isActive = true
        }

        static func setDurationLabel(_ label: UILabel, _ topNeighbour: UIView) {
            label.leadingAnchor.constraint(equalTo: topNeighbour.leadingAnchor).isActive = true
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor).isActive = true
        }
        
        static func setPlotLabel(_ label: UILabel, _ topNeighbour: UIView, _ parent: UIView) {
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: margins).isActive = true
            label.topAnchor.constraint(equalTo: topNeighbour.bottomAnchor, constant: 10.0).isActive = true
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -margins).isActive = true
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
        Constraints.setStoppedAtView(stoppedAtView, progressView)
        switchMultiplier(multiplier: 0.5)
        Constraints.setEpisodeTitleLabel(episodeTitleLabel, thumbnail, self)
        Constraints.setDurationLabel(durationLabel, episodeTitleLabel)
        Constraints.setPlotLabel(plotLabel, thumbnail, self)
        Constraints.setPlayEpisodeButton(playEpisodeButton, thumbnail)
        
        playEpisodeButton.addTarget(self, action: #selector(thumbnailTapped), for: .touchUpInside)
    }
    
    func populate(episode: Episode) {
        
        episodeTitleLabel.text = episode.constructTitle()
        if let url = episode.thumbnailURL {
            thumbnail.downloaded(from: url)
        }
        durationLabel.text = episode.durationInMinutes()
        plotLabel.text = episode.plot?.truncate(EpisodeCell.maximumPlotCharacters)
        
        if let stoppedAt = episode.stoppedAt {
            progressView.isHidden = false
            switchMultiplier(multiplier: Float(stoppedAt)/Float(episode.duration))
        } else {
            progressView.isHidden = true
        }
    }
    
    func switchMultiplier(multiplier: Float) {
        stoppedAtConstraint?.isActive = false
        stoppedAtConstraint = stoppedAtView.widthAnchor.constraint(equalTo: progressView.widthAnchor, multiplier: CGFloat(multiplier))
        stoppedAtConstraint?.isActive = true
    }
    
    @objc func thumbnailTapped() {
        delegate?.thumbnailTapped()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getEstimatedSize(plot: String?, collectionViewWidth: CGFloat) -> CGSize {
        guard var plot = plot, !plot.isEmpty else {
            return CGSize(width: collectionViewWidth, height: 90)
        }
        
        plot = plot.truncate(maximumPlotCharacters)
        
        let labelMargins: CGFloat = 2 * Constraints.margins
        let approximateWidthOfDescription: CGFloat = collectionViewWidth - labelMargins
        let approximateHeightOfDescription: CGFloat = 1000.0 // arbitrary large value
        let attributes = [NSAttributedString.Key.font : plotFont]
        
        let size = CGSize(width: approximateWidthOfDescription, height: approximateHeightOfDescription)
        let estimatedFrame = NSString(string: plot).boundingRect(with: size,
                                                                        options: .usesLineFragmentOrigin,
                                                                        attributes: attributes,
                                                                        context: nil)
        
        return CGSize(width: collectionViewWidth, height: estimatedFrame.height + 90 + 10)
    }
}
