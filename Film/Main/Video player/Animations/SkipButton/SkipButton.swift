//
//  SkipButton.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-07.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class SkipButton: UIButton {
    private enum DisplayState {
        case shown
        case hidden
    }
    
    private var displayState: DisplayState = .hidden
    
    private var parentView: UIView
    private let buttonText: String
    private var initialWidth: CGFloat!
    private var labelWidth: CGFloat!
    
    private var widthConstraint: NSLayoutConstraint?
    private var labelWidthConstraint: NSLayoutConstraint?
    
    private var action: (() -> Void)?
    
    private struct Constants {
        static let animationDuration = 0.3
        
        /// Label margins
        static let leftMargin: CGFloat = 15
        static let rightMargin: CGFloat = 15
        
        /// Amount of the button is going to be clipped for animation
        static let clippedButtonWidth: CGFloat = 20.0
        
        static let labelFont = UIFont(name: "Arial", size: 16.0)
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = buttonText
        label.font = Constants.labelFont
        label.textColor = .white
        label.lineBreakMode = .byClipping
        
        return label
    }()
        
    private class Constraints {
        static func setSkipButton(_ button: UIButton, _ parent: UIView) {
            button.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -20.0).isActive = true
            button.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -90.0).isActive = true
        }
        
        static func setLabel(_ label: UILabel, _ parent: UIView) {
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: Constants.leftMargin).isActive = true
            label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -Constants.rightMargin).isActive = true
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        }
    }
    
    init(parentView: UIView, buttonText: String) {
        self.parentView = parentView
        self.buttonText = buttonText
        super.init(frame: .zero)
        
        setProperties(title: buttonText)
        addSubviews()
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setProperties(title: String) {
        adjustsImageWhenHighlighted = false
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Constants.labelFont
        titleLabel?.lineBreakMode = .byClipping
        
        backgroundColor = #colorLiteral(red: 0.1833875477, green: 0.1844216585, blue: 0.186948508, alpha: 1)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: Constants.leftMargin, bottom: 8, right: Constants.rightMargin)
        layer.cornerRadius = 2
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.3413020372, green: 0.338840127, blue: 0.3431904018, alpha: 1)
    }
    
    private func addSubviews() {
        parentView.addSubviewLayout(self)
        addSubviewLayout(label)
        Constraints.setSkipButton(self, parentView)
        Constraints.setLabel(label, self)
    }
    
    private func setupInitialState() {
        parentView.layoutIfNeeded()
        initialWidth = frame.size.width // get full button width with label
        
        widthConstraint = widthAnchor.constraint(equalToConstant: initialWidth - Constants.clippedButtonWidth)
        widthConstraint?.isActive = true
        
        setTitle("", for: .normal) // hide text label
        alpha = 0.0
        parentView.layoutIfNeeded()
    }
    
    func animateShow() {
        guard case .hidden = displayState else { return }
        
        widthConstraint?.constant = initialWidth
        
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.alpha = 1.0
            self.parentView.layoutIfNeeded()
        })
        
        displayState = .shown
    }
    
    func animateHide() {
        guard case .shown = displayState else { return }
        
        widthConstraint?.constant = initialWidth - Constants.clippedButtonWidth
        
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.alpha = 0.0
            self.parentView.layoutIfNeeded()
        })
        
        displayState = .hidden
    }
    
    func attachAction(action: @escaping () -> Void) {
        self.action = action
        
        addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc private func tappedButton() {
        action?()
    }
}
