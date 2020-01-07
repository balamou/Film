//
//  PlayPauseButton.swift
//  Film
//
//  Created by Michel Balamou on 2020-01-06.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class PlayPauseButton: CustomMarginButton {
    private let shape: ShapeComponent
    private let color: UIColor
    
    private var leftLayer: CAShapeLayer!
    private var rightLayer: CAShapeLayer!
    
    private var playState: PlayPauseState
    private let animationDuration: CFTimeInterval = 0.2
    
    enum PlayPauseState {
        case playing // ▐▐
        case paused  // ►
    }
    
    /**
    Creates a button with a custom animation

    - Parameter state: The initial state of the button `.paused` (►) or `.playing` (▐▐ ) (default **.paused**)
    - Parameter color: The color of the shape (default *white*)
    - Parameter size: size of the icon
    - Parameter shape: Contains the bezier paths that are used for rendering the button
    - Parameter horizontalMargin: increased button's horizontal tap area
    - Parameter verticalMargin: increased button's vertical tap area
    */
    init(state: PlayPauseState = .paused,
         color: UIColor = .white,
         size: CGSize = .zero,
         shape: ShapeComponent? = nil,
         horizontalMargin: CGFloat = 0.0,
         verticalMargin: CGFloat = 0.0) {
        self.playState = state
        self.color = color
        self.shape = shape ?? RelativeShape(width: size.width, height: size.height)
        let frame = CGRect(origin: .zero, size: size)
        
        super.init(horizontalMargin: horizontalMargin, verticalMargin: verticalMargin)
        leftLayer = createLayer(color: color, frame: frame)
        rightLayer = createLayer(color: color, frame: frame)
        setupInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // switches to ▐▐ icon
    func play() {
        guard case .paused = playState else { return }
        
        setupAnimation(leftLayer, from: shape.playLeft(), to: shape.pauseLeft(), duration: animationDuration)
        setupAnimation(rightLayer, from: shape.playRight(), to: shape.pauseRight(), duration: animationDuration)
        playState = .playing
    }
    
    // switched to ► icon
    func pause() {
        guard case .playing = playState else { return }
        
        setupAnimation(leftLayer, from: shape.pauseLeft(), to: shape.playLeft(), duration: animationDuration)
        setupAnimation(rightLayer, from: shape.pauseRight(), to: shape.playRight(), duration: animationDuration)
        playState = .paused
    }
    
    private func setupInitialState() {
        switch playState {
        case .playing:
            leftLayer.path = shape.pauseLeft().cgPath
            rightLayer.path = shape.pauseRight().cgPath
        case .paused:
            leftLayer.path = shape.playLeft().cgPath
            rightLayer.path = shape.playRight().cgPath
        }
    }
    
    private func createLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
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
