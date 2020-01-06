//
//  CustomButton.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class CustomMarginButton: UIButton {
    private var horizontalMargin: CGFloat
    private var verticalMargin: CGFloat
    private var debugView: UIView?
    
    init(horizontalMargin: CGFloat, verticalMargin: CGFloat) {
        self.horizontalMargin = horizontalMargin
        self.verticalMargin = verticalMargin
        super.init(frame: .zero)
    }
    
    convenience init(margin: CGFloat = 10.0) {
        self.init(horizontalMargin: margin, verticalMargin: margin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // increase touch area for control in all directions by margin
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let biggerFrame = bounds.insetBy(dx: -horizontalMargin, dy: -verticalMargin)
        
        return biggerFrame.contains(point)
    }
    
    override func draw(_ rect: CGRect) {
        setupDebuggerView()
    }
    
    private func setupDebuggerView() {
        guard Debugger.showButtonMargins else { return }
        guard debugView == nil else { return }
        
        clipsToBounds = false
    
        debugView = UIView(frame: bounds.insetBy(dx: -horizontalMargin, dy: -verticalMargin))
        debugView?.backgroundColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.2)
        debugView?.isUserInteractionEnabled = false
        addSubview(debugView!)
    }
}
