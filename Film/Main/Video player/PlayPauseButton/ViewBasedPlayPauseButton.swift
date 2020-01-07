//
//  PlayPauseButton.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-06.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

enum PlayPauseState2 {
    case playing // ▐▐
    case paused  // ►
}

class PlayPauseButton2: UIView {
    private let shape: ShapeComponent
    private let color: UIColor
    
    private var leftLayer: CAShapeLayer!
    private var rightLayer: CAShapeLayer!
    
    private var state: PlayPauseState2
    private var tapAction: ((PlayPauseState2) -> Void)?
    private let animationDuration: CFTimeInterval = 0.2
    
    /**
    Creates a button with a custom animation

    - Parameter state: The initial state of the button `.paused` (►) or `.playing` (▐▐ ). It is **.paused** by default
    - Parameter color: The color of the shape. White by default
    - Parameter frame: Frame of the view
    - Parameter shape: Contains the bezier paths that are used for rendering the button
    */
    init(state: PlayPauseState2 = .paused, color: UIColor = .white, frame: CGRect = .zero, shape: ShapeComponent? = nil) {
        self.state = state
        self.color = color
        self.shape = shape ?? RelativeShape(width: frame.width, height: frame.height)
        super.init(frame: frame)
        leftLayer = createLayer(color: color)
        rightLayer = createLayer(color: color)
        setup()
    }
    
    func addAction(action tapAction: @escaping (PlayPauseState2) -> Void) {
        self.tapAction = tapAction
    }
    
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedButton))
        addGestureRecognizer(tap)
        
        setupInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc private func tappedButton() {
        switch state {
        case .playing:
            setupAnimation(leftLayer, from: shape.pauseLeft(), to: shape.playLeft(), duration: animationDuration)
            setupAnimation(rightLayer, from: shape.pauseRight(), to: shape.playRight(), duration: animationDuration)
            state = .paused
        case .paused:
            setupAnimation(leftLayer, from: shape.playLeft(), to: shape.pauseLeft(), duration: animationDuration)
            setupAnimation(rightLayer, from: shape.playRight(), to: shape.pauseRight(), duration: animationDuration)
            state = .playing
        }
        tapAction?(state)
    }
    
    private func setupInitialState() {
        switch state {
        case .playing:
            leftLayer.path = shape.pauseLeft().cgPath
            rightLayer.path = shape.pauseRight().cgPath
        case .paused:
            leftLayer.path = shape.playLeft().cgPath
            rightLayer.path = shape.playRight().cgPath
        }
    }
    
    private func createLayer(color: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.fillColor = color.cgColor
        layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    @discardableResult
    private func setupAnimation(_ shapeLayer: CAShapeLayer, from intitalShape: UIBezierPath, to finalShape: UIBezierPath, duration: CFTimeInterval) -> CABasicAnimation {
        shapeLayer.path = intitalShape.cgPath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = finalShape.cgPath
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        animation.repeatCount = .zero
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: animation.keyPath)
        return animation
    }
}

