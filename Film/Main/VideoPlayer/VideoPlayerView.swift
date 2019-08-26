//
//  VideoPlayerView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class VideoPlayerView: UIView {
    
    var mediaView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var controlView: UIView = {
        let view = UIView()
        view.isHidden = false
        
        return view
    }()
    
    var topBar: UIView = {
        let view = UIView()
        
        return view
    }()
    
    
    var bottomBar: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        
        slider.minimumTrackTintColor = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.1764705882, alpha: 1)
        slider.thumbTintColor = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.1764705882, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
        slider.isContinuous = true
        
        return slider
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "S1:E1 \"El Camino\""
        label.textColor = .white
//        print( UIFont.familyNames.reduce("") { $0 + "\n" + $1 })
//        print( UIFont.fontNames(forFamilyName: "Helvetica Neue").reduce("") { $0 + "\n" + $1 })
        
        let customFont = UIFont(name: "HelveticaNeue", size: 16.0) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.font = customFont
        
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "56:00"
        label.textColor = .white
        
        let customFont = UIFont(name: "HelveticaNeue", size: 15.0) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.font = customFont
        
        return label
    }()
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        button.imageView?.contentMode = ContentMode.scaleAspectFit
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        
        return button
    }()
    
    // MAIN CONTROLS
    
    var pausePlayButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        button.imageView?.contentMode = ContentMode.scaleAspectFit
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        
        return button
    }()
    
    var forward10sButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "forward"), for: .normal)
        button.imageView?.contentMode = ContentMode.scaleAspectFit
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        
        return button
    }()
    
    var backward10sButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "backward"), for: .normal)
        button.imageView?.contentMode = ContentMode.scaleAspectFit
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.fill
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        
        return button
    }()
    
    var currentPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.isHidden = true
        
        return label
    }()
    
    var nextEpisodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next episode", for: .normal)
        let img = #imageLiteral(resourceName: "Next_episode")
        button.setImage(img, for: .normal)
        
        let customFont = UIFont(name: "HelveticaNeue", size: 15.0) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        button.titleLabel?.font = customFont
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        return button
    }()
    
    // VOLUME BAR
    
    var volumeBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.7
        progressView.tintColor = .white
        progressView.trackTintColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
        progressView.isHidden = true
        
        return progressView
    }()
    
    var volumeImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Volume"))
        imageView.isHidden = true
        
        return imageView
    }()
    
    
    class Constraints {
        
        static let topBottomBarsHeight: CGFloat = 80.0
        static let controlHorizontalSpacing: CGFloat = 150.0
        
        static func setMediaView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        }
        
        static func setTopBar(_ view: UIView, _ parent: UIView) {
            view.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: topBottomBarsHeight).isActive = true
        }
        
        static func setBottomBar(_ view: UIView, _ parent: UIView) {
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        }
        
        static func setTitleLabel(_ label: UILabel, _ parent: UIView) {
            label.topAnchor.constraint(equalTo: parent.topAnchor, constant: 30.0).isActive = true
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setDurationLabel(_ label: UILabel, _ parent: UIView) {
            let labelDistanceFromBottom: CGFloat = 50.0
            let labelDistanceFromEdge: CGFloat = 20.0
            
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -1 * labelDistanceFromEdge).isActive = true
            label.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -1 * labelDistanceFromBottom).isActive = true
        }
        
        static func setSlider(_ slider: UISlider, _ durationLabel: UILabel, _ parent: UIView) {
            let sliderDistanceFromEdge: CGFloat = 25.0
         
            slider.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: sliderDistanceFromEdge).isActive = true
            slider.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -15.0).isActive = true
            slider.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor).isActive = true
        }
        
        static func setPausePlayButton(_ button: UIButton, _ parent: UIView) {
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 41.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
        
        static func setForwardButton(_ button: UIButton, _ pause: UIView) {
            button.centerYAnchor.constraint(equalTo: pause.centerYAnchor).isActive = true
            button.centerXAnchor.constraint(equalTo: pause.centerXAnchor, constant: controlHorizontalSpacing).isActive = true
            
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
        
        static func setBackwardButton(_ button: UIButton, _ pause: UIView) {
            button.centerYAnchor.constraint(equalTo: pause.centerYAnchor).isActive = true
            button.centerXAnchor.constraint(equalTo: pause.centerXAnchor, constant: -1 * controlHorizontalSpacing).isActive = true
            
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        }
        
        static func setCloseButton(_ button: UIButton, _ label: UILabel, _ parent: UIView) {
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -30.0).isActive = true
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
            button.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        }
        
        static func setControlView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        }
        
        static func setNextEpisodeButton(_ button: UIButton, _ parent: UIView) {
            button.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -20.0).isActive = true
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        // VOLUME BAR
        static func setVolumeBar(_ progressView: UIProgressView, _ parent: UIView) {
            progressView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 10.0).isActive = true
            progressView.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 0.5).isActive = true
            progressView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setVolumeImage(_ image: UIImageView, _ rightNeighbour: UIView) {
            image.centerYAnchor.constraint(equalTo: rightNeighbour.centerYAnchor).isActive = true
            image.trailingAnchor.constraint(equalTo: rightNeighbour.leadingAnchor, constant: -15.0).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubviewLayout(mediaView)
        
        addSubviewLayout(controlView)
        controlView.addSubviewLayout(topBar)
        controlView.addSubviewLayout(bottomBar)
        
        topBar.addSubviewLayout(titleLabel)
        bottomBar.addSubviewLayout(durationLabel)
        bottomBar.addSubviewLayout(slider)
        
        controlView.addSubview(currentPositionLabel)
        
        Constraints.setMediaView(mediaView, self)
        Constraints.setControlView(controlView, self)
        Constraints.setTopBar(topBar, controlView)
        Constraints.setBottomBar(bottomBar, controlView)
        
        Constraints.setTitleLabel(titleLabel, topBar)
        Constraints.setDurationLabel(durationLabel, bottomBar)
        Constraints.setSlider(slider, durationLabel, bottomBar)
        
        // CONTROLLS
        controlView.addSubviewLayout(pausePlayButton)
        controlView.addSubviewLayout(forward10sButton)
        controlView.addSubviewLayout(backward10sButton)
        topBar.addSubviewLayout(closeButton)
        
        Constraints.setPausePlayButton(pausePlayButton, controlView)
        Constraints.setForwardButton(forward10sButton, pausePlayButton)
        Constraints.setBackwardButton(backward10sButton, pausePlayButton)
        Constraints.setCloseButton(closeButton, titleLabel, topBar)
        
        bottomBar.addSubviewLayout(nextEpisodeButton)
        Constraints.setNextEpisodeButton(nextEpisodeButton, bottomBar)
        
        // VOLUME
        addSubviewLayout(volumeBar)
        addSubviewLayout(volumeImage)
        
        Constraints.setVolumeBar(volumeBar, self)
        Constraints.setVolumeImage(volumeImage, volumeBar)
    }
    
    func didAppear() {
        applyGradient()
    }
    
    func applyGradient() {
        controlView.setGradient(colors: [UIColor.black.setAlpha(0.8), UIColor.black.setAlpha(0), UIColor.black.setAlpha(0.8)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
