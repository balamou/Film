//
//  AnimationManager.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-06.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

enum AnimationDirection {
    case forward
    case backward
}

class AnimationManager {
    private let label: UILabel
    private let button: UIButton
    private let animationDirection: AnimationDirection
    
    private var view: UIView!
    private var leadingConstraint: NSLayoutConstraint?
    private var animator: Animator!
    
    private lazy var forward10sButton: UIButton = {
        let button = UIButton()
        
        button.setImage(getArrowImage(), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.isHidden = true
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    private var whiteCircledView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35.0/2.0
        view.backgroundColor = .white
        view.isHidden = true
        view.alpha = 0.6
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private lazy var forward10sLabel: UILabel = {
        let label = UILabel()
        label.text = getLabelText()
        label.textColor = .white
        label.isHidden = true
        label.font = Fonts.helveticaBold(size: 14.0)
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    
    class Constraints {
        
        static func setForwardButton(_ button: UIButton, _ parent: UIView, horizontalDistance: CGFloat) {
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: horizontalDistance).isActive = true
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
    
    init(_ view: UIView, button: UIButton, label: UILabel, animationDirection: AnimationDirection) {
        self.button = button
        self.label = label
        self.animationDirection = animationDirection
        self.view = view
        setup(view: view)
    }
    
    private func setup(view: UIView) {
        view.addSubviewLayout(whiteCircledView)
        view.addSubviewLayout(forward10sLabel)
        view.addSubviewLayout(forward10sButton)
        
        Constraints.setForwardButton(forward10sButton, view, horizontalDistance: getButtonLocation())
        Constraints.setForwardLabel(forward10sLabel, forward10sButton)
        Constraints.whiteCircle(whiteCircledView, forward10sButton)
        
        leadingConstraint = getInitialConstraint()
        leadingConstraint?.isActive = true
        
        animator = setupAnimator()
        
        view.layoutIfNeeded()
    }
    
    private func setupAnimator() -> Animator {
        let first = AnimationBlock(duration: 0.2, time: .curveEaseOut, before: {
            self.forward10sButton.isHidden = false
            self.forward10sLabel.isHidden = false
            self.whiteCircledView.isHidden = false
            
            self.leadingConstraint?.isActive = false
            self.leadingConstraint = self.getFinalConstraint()
            self.leadingConstraint?.isActive = true
        }, after: {
            self.whiteCircledView.alpha = 0.0
            self.view.layoutIfNeeded()
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
        label.alpha = 0.0
        button.alpha = 0.0
           
        recoilLoop()
        animator.finally(key: "show_original_buttons", {
            self.label.alpha = 1.0
            self.button.alpha = 1.0
        }).finally(key: "completion", completion).animate()
    }
    
    private func recoilLoop() {
        UIView.animate(withDuration: 0.1, animations: {
            self.forward10sButton.transform = CGAffineTransform(rotationAngle: (self.getAngleRotation() * .pi)/180.0)
        }, completion: { fin in
            UIView.animate(withDuration: 0.12, animations: {
                self.forward10sButton.transform = CGAffineTransform(rotationAngle: (0 * .pi)/180.0)
                self.view.layoutSubviews()
            })
        })
    }
    
    private func finalState() {
        leadingConstraint?.isActive = false
        leadingConstraint = getInitialConstraint()
        leadingConstraint?.isActive = true
        
        forward10sLabel.alpha = 1.0
        forward10sLabel.isHidden = true
        
        forward10sButton.alpha = 1.0
        forward10sButton.isHidden = true
        
        whiteCircledView.alpha = 0.6
        whiteCircledView.isHidden = true
        view.layoutIfNeeded()
    }
    
}

extension AnimationManager {
    
    func getArrowImage() -> UIImage? {
        switch animationDirection {
        case .forward:
            return Images.Player.forwardImage
        case .backward:
            return Images.Player.backwardImage
        }
    }
    
    func getLabelText() -> String {
        switch animationDirection {
        case .forward:
            return "+10"
        case .backward:
            return "-10"
        }
    }
    
    func getButtonLocation() -> CGFloat {
        switch animationDirection {
        case .forward:
            return 141.0
        case .backward:
            return -141.0
        }
    }
    
    func getInitialConstraint() -> NSLayoutConstraint {
        switch animationDirection {
        case .forward:
            return forward10sLabel.leadingAnchor.constraint(equalTo: forward10sButton.trailingAnchor)
        case .backward:
            return forward10sLabel.trailingAnchor.constraint(equalTo: forward10sButton.leadingAnchor)
        }
    }
    
    func getFinalConstraint() -> NSLayoutConstraint {
        switch animationDirection {
        case .forward:
            return forward10sLabel.leadingAnchor.constraint(equalTo: forward10sButton.trailingAnchor, constant: 30.0)
        case .backward:
            return forward10sLabel.trailingAnchor.constraint(equalTo: forward10sButton.leadingAnchor, constant: -30.0)
        }
    }
    
    func getAngleRotation() -> CGFloat {
        switch animationDirection {
        case .forward:
            return 30.0
        case .backward:
            return -30.0
        }
    }
    
}
