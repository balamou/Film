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
    private let originalLabel: UILabel
    private let originalButton: UIButton
    private let animationDirection: AnimationDirection
    
    private var view: UIView!
    private var leadingConstraint: NSLayoutConstraint?
    private var animator: Animator!
    
    private lazy var button: UIButton = {
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
    
    private lazy var label: UILabel = {
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
        self.originalButton = button
        self.originalLabel = label
        self.animationDirection = animationDirection
        self.view = view
        setup(view: view)
    }
    
    private func setup(view: UIView) {
        view.addSubviewLayout(whiteCircledView)
        view.addSubviewLayout(label)
        view.addSubviewLayout(button)
        
        Constraints.setForwardButton(button, view, horizontalDistance: getButtonLocation())
        Constraints.setForwardLabel(label, button)
        Constraints.whiteCircle(whiteCircledView, button)
        
        leadingConstraint = getInitialConstraint()
        leadingConstraint?.isActive = true
        
        animator = setupAnimator()
        
        view.layoutIfNeeded()
    }
    
    private func setupAnimator() -> Animator {
        let first = AnimationBlock(duration: 0.2, time: .curveEaseOut, before: {
            self.button.isHidden = false
            self.label.isHidden = false
            self.whiteCircledView.isHidden = false
            
            self.leadingConstraint?.isActive = false
            self.leadingConstraint = self.getFinalConstraint()
            self.leadingConstraint?.isActive = true
            
            self.originalLabel.alpha = 0.0
            self.originalButton.alpha = 0.0
        }, after: {
            self.whiteCircledView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
        
        let second = AnimationBlock(duration: 0.3, delay: 0.4, time: .curveLinear, after: {
            self.label.alpha = 0.0
            self.button.alpha = 0.0
        })
        
        let third = AnimationBlock(duration: 0.2, time: .curveLinear, after: {
            self.originalLabel.alpha = 1.0
            self.originalButton.alpha = 1.0
        })
        
        return Animator(first).then(second).then(third).finally {
            self.finalState()
        }
    }
    
    func animate(completion: @escaping (() -> Void) = {}) {
        recoilLoop()
        animator.finally(key: "completion", completion).animate()
    }
    
    /// Recoils the forward/backward loop by 30 degrees and back
    private func recoilLoop() {
        UIView.animate(withDuration: 0.1, animations: {
            self.button.transform = CGAffineTransform(rotationAngle: (self.getAngleRotation() * .pi)/180.0)
        }, completion: { fin in
            UIView.animate(withDuration: 0.12, animations: {
                self.button.transform = CGAffineTransform(rotationAngle: (0 * .pi)/180.0)
                self.view.layoutSubviews()
            })
        })
    }
    
    private func finalState() {
        leadingConstraint?.isActive = false
        leadingConstraint = getInitialConstraint()
        leadingConstraint?.isActive = true
        
        label.alpha = 1.0
        label.isHidden = true
        
        button.alpha = 1.0
        button.isHidden = true
        
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
            return label.leadingAnchor.constraint(equalTo: button.trailingAnchor)
        case .backward:
            return label.trailingAnchor.constraint(equalTo: button.leadingAnchor)
        }
    }
    
    func getFinalConstraint() -> NSLayoutConstraint {
        switch animationDirection {
        case .forward:
            return label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 30.0)
        case .backward:
            return label.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -30.0)
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
