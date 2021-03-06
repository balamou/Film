//
//  VideoPlayerView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-25.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit
import QuartzCore

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
    
    var slider: CustomHeightSlider = {
        let slider = CustomHeightSlider(trackHeight: 2.0)
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        
        slider.minimumTrackTintColor = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.1764705882, alpha: 1)
        slider.thumbTintColor = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.1764705882, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.6208083034, green: 0.6209152341, blue: 0.6207941771, alpha: 0.5510013204)
        slider.isContinuous = true
        
        return slider
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "S1:E1 \"El Camino\""
        label.textColor = .white
        label.font = Fonts.helveticaNeue(size: 16.0)
        
        return label
    }()
    
    var airPlayButton: CustomMarginButton = {
        let button = CustomMarginButton(horizontalMargin: 30, verticalMargin: 20)
        button.setImage(Images.Player.airPlayImage, for: .normal)
        
        return button
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "56:00"
        label.textColor = .white
        label.font = Fonts.helveticaNeue(size: 15.0)
        
        return label
    }()
    
    var closeButton: CustomMarginButton = {
        let button = CustomMarginButton(horizontalMargin: 30, verticalMargin: 15)
        button.setImage(Images.Player.closeImage, for: .normal)
        
        return button
    }()
    
    // MAIN CONTROLS
    
    var pausePlayButton: PlayPauseButton = {
        let button = PlayPauseButton(state: .paused, size: CGSize(width: 60/2, height: 72/2), horizontalMargin: 20, verticalMargin: 15)
        
        return button
    }()
    
    var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        
        return spinner
    }()
    
    var forward10sButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.Player.forwardImage, for: .normal)
        
        return button
    }()
    
    var backward10sButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.Player.backwardImage, for: .normal)
        
        return button
    }()
    
    var forward10sLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textColor = .white
        label.font = Fonts.helveticaBold(size: 13.0)
        
        return label
    }()
    
    var backward10sLabel: UILabel = {
           let label = UILabel()
           label.text = "10"
           label.textColor = .white
           label.font = Fonts.helveticaBold(size: 13.0)
           
           return label
       }()
    
    var currentPositionLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.isHidden = true
        
        return label
    }()
    
    var audioAndSubtitles: UIButton = {
        let button = UIButton()
        button.setTitle("Audio and subtitles".localize(), for: .normal)
        button.setImage(Images.Player.subtitlesImage, for: .normal)
        button.titleLabel?.font = Fonts.helveticaNeue(size: 15.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        return button
    }()
    
    var nextEpisodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next episode".localize(), for: .normal)
        button.setImage(Images.Player.nextEpisodeImage, for: .normal)
        button.titleLabel?.font = Fonts.helveticaNeue(size: 15.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        return button
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        
        return stackView
    }()
    
    var subtitlesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Audio and subtitles".localize(), for: .normal)
        button.setImage(Images.Player.subtitlesImage, for: .normal)
        button.titleLabel?.font = Fonts.helveticaNeue(size: 15.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        return button
    }()
    
    // VOLUME BAR
    
    var volumeBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.7
        progressView.tintColor = .white
        progressView.trackTintColor = #colorLiteral(red: 0.436260283, green: 0.4363379776, blue: 0.436250031, alpha: 0.5510013204)
        progressView.isHidden = true
        
        return progressView
    }()
    
    var volumeImage: UIImageView = {
        let imageView = UIImageView(image: Images.Player.volumeImage)
        imageView.isHidden = true
        
        return imageView
    }()
    
    var audioAndSubtitlesView: AudioAndSubtilesView = {
        let view = AudioAndSubtilesView()
        view.isHidden = true
        
        return view
    }()
    
    var topSubtitleBox: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Subtitles"
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.53)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.font = Fonts.robotoMonoRegular(size: 15.5)
        
        
        return label
    }()
    
    var bottomSubtitleBox: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Subtitles"
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.53)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.font = Fonts.robotoMonoRegular(size: 15.5)
        
        return label
    }()

    class Constraints {
        
        static let topBottomBarsHeight: CGFloat = 80.0
        static let controlHorizontalSpacing: CGFloat = 141.0
        
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
            label.topAnchor.constraint(equalTo: parent.topAnchor, constant: 33.0).isActive = true
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        static func setAirPlayButton(_ button: UIButton, _ parent: UIView) {
            button.topAnchor.constraint(equalTo: parent.topAnchor, constant: 33).isActive = true
            button.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 21).isActive = true
        }
        
        static func setDurationLabel(_ label: UILabel, _ parent: UIView) {
            let labelDistanceFromBottom: CGFloat = 66.0
            let labelDistanceFromEdge: CGFloat = 20.0
            
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -1 * labelDistanceFromEdge).isActive = true
            label.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -1 * labelDistanceFromBottom).isActive = true
        }
        
        static func setSlider(_ slider: UISlider, _ durationLabel: UILabel, _ parent: UIView) {
            let sliderDistanceFromEdge: CGFloat = 20.0
            let sliderDistanceFromLabel: CGFloat = 10.0
         
            slider.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: sliderDistanceFromEdge).isActive = true
            slider.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -1 * sliderDistanceFromLabel).isActive = true
            slider.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor).isActive = true
        }
        
        static func setPausePlayButton(_ button: UIView, _ parent: UIView) {
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 60/2).isActive = true
            button.heightAnchor.constraint(equalToConstant: 72/2).isActive = true
        }
        
        static func setSpinner(_ spinner: UIActivityIndicatorView, _ parent: UIView) {
            spinner.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        }
        
        static func setForwardButton(_ button: UIButton, _ pause: UIView) {
            button.centerYAnchor.constraint(equalTo: pause.centerYAnchor).isActive = true
            button.centerXAnchor.constraint(equalTo: pause.centerXAnchor, constant: controlHorizontalSpacing).isActive = true
        }
        
        static func setBackwardButton(_ button: UIButton, _ pause: UIView) {
            button.centerYAnchor.constraint(equalTo: pause.centerYAnchor).isActive = true
            button.centerXAnchor.constraint(equalTo: pause.centerXAnchor, constant: -1 * controlHorizontalSpacing).isActive = true
        }
        
        static func setForwardLabel(_ label: UILabel, _ forwardButton: UIButton) {
            label.centerYAnchor.constraint(equalTo: forwardButton.centerYAnchor, constant: 2).isActive = true
            label.centerXAnchor.constraint(equalTo: forwardButton.centerXAnchor).isActive = true
        }
        
        static func setBackwardLabel(_ label: UILabel, _ backwardButton: UIButton) {
            label.centerYAnchor.constraint(equalTo: backwardButton.centerYAnchor, constant: 2).isActive = true
            label.centerXAnchor.constraint(equalTo: backwardButton.centerXAnchor).isActive = true
        }
        
        static func setCloseButton(_ button: UIButton, _ label: UILabel, _ parent: UIView) {
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -30.0).isActive = true
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        }
        
        static func setControlView(_ view: UIView, _ parent: UIView) {
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
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
        
        setupMainViewComponents()
        setupVolumeIndicator()
        setupMainControls()
        setupSecondaryControls()
        
        controlView.addSubview(currentPositionLabel)
        
        setupAudioAndSubstitlesView()
        setupSubtitleBox()
    }
    
    private func setupMainViewComponents() {
        addSubviewLayout(mediaView)
        addSubviewLayout(controlView)
        
        controlView.addSubviewLayout(topBar)
        controlView.addSubviewLayout(bottomBar)
        
        Constraints.setMediaView(mediaView, self)
        Constraints.setControlView(controlView, self)
        
        Constraints.setTopBar(topBar, controlView)
        Constraints.setBottomBar(bottomBar, controlView)
    }
    
    private func setupVolumeIndicator() {
        addSubviewLayout(volumeBar)
        addSubviewLayout(volumeImage)
        
        Constraints.setVolumeBar(volumeBar, self)
        Constraints.setVolumeImage(volumeImage, volumeBar)
    }
    
    private func setupMainControls() {
        controlView.addSubviewLayout(pausePlayButton)
        controlView.addSubviewLayout(forward10sButton)
        controlView.addSubviewLayout(backward10sButton)
        controlView.addSubviewLayout(forward10sLabel)
        controlView.addSubviewLayout(backward10sLabel)
        addSubviewLayout(spinner)
        
        Constraints.setPausePlayButton(pausePlayButton, controlView)
        Constraints.setForwardButton(forward10sButton, pausePlayButton)
        Constraints.setBackwardButton(backward10sButton, pausePlayButton)
        Constraints.setForwardLabel(forward10sLabel, forward10sButton)
        Constraints.setBackwardLabel(backward10sLabel, backward10sButton)
        Constraints.setSpinner(spinner, self)
    }
    
    private func setupSecondaryControls() {
        topBar.addSubviewLayout(titleLabel)
        topBar.addSubviewLayout(closeButton)
        topBar.addSubviewLayout(airPlayButton)
        bottomBar.addSubviewLayout(durationLabel)
        bottomBar.addSubviewLayout(slider)
        
        Constraints.setTitleLabel(titleLabel, topBar)
        Constraints.setCloseButton(closeButton, titleLabel, topBar)
        Constraints.setAirPlayButton(airPlayButton, topBar)
        Constraints.setDurationLabel(durationLabel, bottomBar)
        Constraints.setSlider(slider, durationLabel, bottomBar)
        
        //
        stackView.addArrangedSubview(audioAndSubtitles)
        stackView.addArrangedSubview(nextEpisodeButton)
        
        bottomBar.addSubviewLayout(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupAudioAndSubstitlesView() {
        addSubviewLayout(audioAndSubtitlesView)
        
        audioAndSubtitlesView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        audioAndSubtitlesView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        audioAndSubtitlesView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        audioAndSubtitlesView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func setupSubtitleBox() {
        insertSubview(topSubtitleBox, aboveSubview: mediaView)
        topSubtitleBox.translatesAutoresizingMaskIntoConstraints = false
        
        insertSubview(bottomSubtitleBox, aboveSubview: mediaView)
        bottomSubtitleBox.translatesAutoresizingMaskIntoConstraints = false
        
        bottomSubtitleBox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        bottomSubtitleBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        topSubtitleBox.bottomAnchor.constraint(equalTo: bottomSubtitleBox.topAnchor).isActive = true
        topSubtitleBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func didAppear() {
        applyGradient()
    }
    
    var gradientLayer: CAGradientLayer?
    
    func applyGradient() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = controlView.setGradient(colors: [UIColor.black.setAlpha(0.8), UIColor.black.setAlpha(0.3), UIColor.black.setAlpha(0.8)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
