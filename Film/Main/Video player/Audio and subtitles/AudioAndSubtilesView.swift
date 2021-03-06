//
//  AudioAndSubtilesView.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-19.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

protocol AudioAndSubtilesViewDelegate: class {
    func subtitlesOnOffTapped()
}

class AudioAndSubtilesView: UIView {
    weak var delegate: AudioAndSubtilesViewDelegate?
    var audioTrackButtons: [(button: UIButton, track: String)] = []
    private var turnSubtitlesOn = true
    
    var audioLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio tracks".localize()
        label.textColor = .white
        label.font = Fonts.helveticaBold(size: 16.0)
        
        return label
    }()
    
    var audioButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        
        return stackView
    }()
    
    var closeButton: CustomMarginButton = {
        let button = CustomMarginButton(horizontalMargin: 30, verticalMargin: 15)
        button.setImage(Images.Player.closeImage, for: .normal)
        
        return button
    }()
    
    var subtitlesOnOffButton: UIButton = {
        let button = UIButton()
        button.setTitle("Turn subtitles: On", for: .normal)
        button.titleLabel?.font = Fonts.helveticaBold(size: 16.0)
        
        return button
    }()
    
    func setup(with mediaPlayer: VLCMediaPlayer) {
        guard let audioTracks = mediaPlayer.audioTrackNames?.compactMap({ $0 as? String}) else {
            return
        }
        let currentIndex = mediaPlayer.currentAudioTrackIndex
        
        audioTrackButtons.forEach { $0.button.removeFromSuperview() }
        
        audioTrackButtons = audioTracks.enumerated().dropFirst(1).map { (offset, track) in
            let audioButton = ButtonActionable()
            audioButtonStackView.addArrangedSubview(audioButton)
            audioButton.attachAction { [weak mediaPlayer, weak self] button in
                mediaPlayer?.currentAudioTrackIndex = Int32(offset)
                self?.resetButonColors(currentTrack: offset)
            }
            
            return (audioButton, guessTrackLanguage(from: track))
        }
        
        resetButonColors(currentTrack: Int(currentIndex))
    }
    
    private func guessTrackLanguage(from track: String) -> String {
        let trackTitle = track.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trackTitle ~= "(ru|rus|russian|ру|рус|русский)" {
            return "Russian".localize()
        }
        
        if trackTitle ~= "(en|eng|english|анг|английский)" {
            return "English".localize()
        }
        
        return trackTitle
    }
    
    private func resetButonColors(currentTrack: Int) {
        audioTrackButtons.enumerated().forEach { (offset, item) in
            let trackTitle = item.track
            
            if offset == currentTrack - 1 {
                item.button.setTitle("\u{2713} \(trackTitle)", for: .normal)
                item.button.setTitleColor(.white, for: .normal)
                item.button.titleLabel?.font = Fonts.helveticaBold(size: 16.0)
            } else {
                item.button.setTitle("    \(trackTitle)", for: .normal)
                item.button.setTitleColor(.gray, for: .normal)
                item.button.titleLabel?.font = Fonts.helveticaNeue(size: 16.0)
            }
        }
    }
    
    struct Constraints {
        static func setCloseButton(_ button: UIButton, _ parent: UIView) {
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -30.0).isActive = true
            button.topAnchor.constraint(equalTo: parent.topAnchor, constant: 30.0).isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        setBlur()
        setupConstraints()
        
        closeButton.addTarget(self, action: #selector(closeAudioAndSubtitles), for: .touchUpInside)
        subtitlesOnOffButton.addTarget(self, action: #selector(subtitlesOnOffButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        addSubviewLayout(closeButton)
        Constraints.setCloseButton(closeButton, self)
        
        addSubviewLayout(audioLabel)
        audioLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        audioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        
        addSubviewLayout(audioButtonStackView)
        audioButtonStackView.topAnchor.constraint(equalTo: audioLabel.bottomAnchor, constant: 20).isActive = true
        audioButtonStackView.leadingAnchor.constraint(equalTo: audioLabel.leadingAnchor, constant: 20).isActive = true
        
        // On Off subtitles
        
        addSubviewLayout(subtitlesOnOffButton)
        subtitlesOnOffButton.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        subtitlesOnOffButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -80).isActive = true
    }
    
    @objc func closeAudioAndSubtitles() {
        self.hide()
    }
    
    @objc func subtitlesOnOffButtonTapped() {
        delegate?.subtitlesOnOffTapped()
        
        if turnSubtitlesOn {
            subtitlesOnOffButton.setTitle("Turn subtitles: Off", for: .normal)
            turnSubtitlesOn = false
        } else {
            subtitlesOnOffButton.setTitle("Turn subtitles: On", for: .normal)
            turnSubtitlesOn = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBlur() {
        guard !UIAccessibility.isReduceTransparencyEnabled else { return }
        
        backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        addSubviewLayout(blurEffectView)
        blurEffectView.fillConstraints(in: self)
    }
    
}


class ButtonActionable: UIButton {
    private var action: ((UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(buttonActionableTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonActionableTapped() {
        action?(self)
    }
    
    func attachAction(_ action: @escaping (UIButton) -> Void) {
        self.action = action
    }
}
