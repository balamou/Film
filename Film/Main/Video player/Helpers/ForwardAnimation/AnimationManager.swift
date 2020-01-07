//
//  AnimationManager.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-06.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class AnimationManager {
    private let forwardLabel: UILabel
    private let forwardButton: UIButton
    
    var forward10sButton: UIButton = {
        let button = UIButton()
        
        button.setImage(Images.Player.forwardImage, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.isHidden = true
        
        return button
    }()
    
    var whiteCircledView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35.0/2.0
        view.backgroundColor = .white
        view.isHidden = true
        view.alpha = 0.6
        
        return view
    }()
    
    var forward10sLabel: UILabel = {
        let label = UILabel()
        label.text = "+10"
        label.textColor = .white
        label.isHidden = true
        label.font = Fonts.helveticaBold(size: 13.0)
        
        return label
    }()
    
    
    class Constraints {
        static let controlHorizontalSpacing: CGFloat = 141.0
        
        static func setForwardButton(_ button: UIButton, _ parent: UIView) {
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: controlHorizontalSpacing).isActive = true
            button.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 35).isActive = true
            button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        }
        
        static func setForwardLabel(_ label: UILabel, _ forwardButton: UIButton) {
            label.centerYAnchor.constraint(equalTo: forwardButton.centerYAnchor, constant: 2).isActive = true
        }
        
        static func whiteCircle(_ view: UIView, _ button: UIView) {
            view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 3).isActive = true
            view.widthAnchor.constraint(equalToConstant: 33).isActive = true
            view.heightAnchor.constraint(equalToConstant: 33).isActive = true
        }
    }
        
    var viewSafe: UIView!
    var leadingConstraint: NSLayoutConstraint?
    var animator: Animator!
    
    init(forwardButton: UIButton, forwardLabel: UILabel) {
        self.forwardButton = forwardButton
        self.forwardLabel = forwardLabel
    }
    
    func setup(view: UIView) {
        view.addSubviewLayout(whiteCircledView)
        view.addSubviewLayout(forward10sLabel)
        view.addSubviewLayout(forward10sButton)
        
        Constraints.setForwardButton(forward10sButton, view)
        Constraints.setForwardLabel(forward10sLabel, forward10sButton)
        Constraints.whiteCircle(whiteCircledView, forward10sButton)
        
        leadingConstraint = forward10sLabel.leadingAnchor.constraint(equalTo: forward10sButton.trailingAnchor)
        leadingConstraint?.isActive = true
        
        animator = setupAnimator()
    
        self.viewSafe = view
        view.layoutIfNeeded()
    }
    
    private func setupAnimator() -> Animator {
        let first = AnimationBlock(duration: 0.2, time: .curveEaseOut, before: {
            self.forward10sButton.isHidden = false
            self.forward10sLabel.isHidden = false
            self.whiteCircledView.isHidden = false
            
            self.leadingConstraint?.isActive = false
            self.leadingConstraint = self.forward10sLabel.leadingAnchor.constraint(equalTo: self.forward10sButton.trailingAnchor, constant: 30.0)
            self.leadingConstraint?.isActive = true
        }, after: {
            self.whiteCircledView.alpha = 0.0
            self.viewSafe.layoutIfNeeded()
        })
        
        let second = AnimationBlock(duration: 0.3, delay: 0.4, time: .curveLinear, after: {
            self.forward10sLabel.alpha = 0.0
            self.forward10sButton.alpha = 0.0
        })
        
        return Animator(first).then(second).finally {
            self.finalState()
        }
    }
    
    func animate(completion: @escaping (() -> Void) = {}) {
        forwardLabel.alpha = 0.0
        forwardButton.alpha = 0.0
           
        recoilLoop()
        animator.finally(key: "show_original_buttons", {
            self.forwardLabel.alpha = 1.0
            self.forwardButton.alpha = 1.0
        }).finally(key: "completion", completion).animate()
    }
    
    private func recoilLoop() {
        UIView.animate(withDuration: 0.1, animations: {
            self.forward10sButton.transform = CGAffineTransform(rotationAngle: (30.0 * .pi)/180.0)
        }, completion: { fin in
            UIView.animate(withDuration: 0.12, animations: {
                self.forward10sButton.transform = CGAffineTransform(rotationAngle: (0 * .pi)/180.0)
                self.viewSafe.layoutSubviews()
            })
        })
    }
    
    private func finalState() {
        leadingConstraint?.isActive = false
        leadingConstraint = forward10sLabel.leadingAnchor.constraint(equalTo: forward10sButton.trailingAnchor)
        leadingConstraint?.isActive = true
        
        forward10sLabel.alpha = 1.0
        forward10sLabel.isHidden = true
        
        forward10sButton.alpha = 1.0
        forward10sButton.isHidden = true
        
        whiteCircledView.alpha = 0.6
        whiteCircledView.isHidden = true
        self.viewSafe.layoutIfNeeded()
    }
    
}
