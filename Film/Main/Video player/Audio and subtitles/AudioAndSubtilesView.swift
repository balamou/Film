//
//  AudioAndSubtilesView.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-19.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class AudioAndSubtilesView: UIView {
    
    var audioTrackButtons: [UIButton] = []
    
    var audioLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio tracks".localize()
        label.textColor = .white
        label.font = Fonts.helveticaBold(size: 15.0)
        
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
    
    func setup(with mediaPlayer: VLCMediaPlayer) {
        guard let audioTracks = mediaPlayer.audioTrackNames?.compactMap({ $0 as? String}) else {
            return
        }
        let currentIndex = mediaPlayer.currentAudioTrackIndex
        
        audioTrackButtons.forEach { $0.removeFromSuperview() }
        
        audioTrackButtons = audioTracks.enumerated().dropFirst(1).map { (offset, track) in
            let audioButton = ButtonActionable()
            audioButton.setTitle(track.trimmingCharacters(in: .whitespacesAndNewlines), for: .normal)
            audioButton.setTitleColor(.gray, for: .normal)
            audioButton.titleLabel?.font = Fonts.helveticaNeue(size: 15.0)
            
            audioButtonStackView.addArrangedSubview(audioButton)
            
            if offset == currentIndex {
                audioButton.setTitleColor(.white, for: .normal)
                audioButton.titleLabel?.font = Fonts.helveticaBold(size: 15.0)
            }
            
            audioButton.attachAction { [weak mediaPlayer, weak self] button in
                mediaPlayer?.currentAudioTrackIndex = Int32(offset)
                self?.resetButonColors(currentTrack: offset)
            }
            
            return audioButton
        }
    }
    
    func resetButonColors(currentTrack: Int) {
        audioTrackButtons.enumerated().forEach { (offset, button) in
            if offset == currentTrack - 1 {
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = Fonts.helveticaBold(size: 15.0)
            } else {
                button.setTitleColor(.gray, for: .normal)
                button.titleLabel?.font = Fonts.helveticaNeue(size: 15.0)
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
        
        addSubviewLayout(closeButton)
        Constraints.setCloseButton(closeButton, self)
        
        addSubviewLayout(audioLabel)
        audioLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        audioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        
        addSubviewLayout(audioButtonStackView)
        audioButtonStackView.topAnchor.constraint(equalTo: audioLabel.bottomAnchor, constant: 10).isActive = true
        audioButtonStackView.leadingAnchor.constraint(equalTo: audioLabel.leadingAnchor, constant: 20).isActive = true
        
        closeButton.addTarget(self, action: #selector(closeAudioAndSubtitles), for: .touchUpInside)
    }
    
    @objc func closeAudioAndSubtitles() {
        self.hide()
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
