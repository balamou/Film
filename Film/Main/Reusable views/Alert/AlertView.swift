//
//  AlertView.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class AlertView: UIView {
    
    var isAnimating = false
    let animationUpDownDuration = 0.4
    let messageDuration = 1.6
    
    var backgroundViewTopAnchor = NSLayoutConstraint()
    var backgroundViewBottomAnchor = NSLayoutConstraint()
    
    let errorColor = #colorLiteral(red: 1, green: 0.2813572288, blue: 0.3109254241, alpha: 1).withAlphaComponent(0.9) // #FF5F5F
    let successColor = #colorLiteral(red: 0, green: 0.8392156863, blue: 0, alpha: 1).withAlphaComponent(0.9) // #00D600
    let neutralColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).withAlphaComponent(0.9) // #999999
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = errorColor
        
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Warning message"
        label.textColor = UIColor.white
        label.font = Fonts.generateFont(font: "OpenSans-Bold", size: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    class Constraints {
        
        static func setBackgroundView(_ roundView: UIView, _ view: UIView) {
            roundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            roundView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            roundView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        static func setMessageLabel(_ label: UILabel, _ view: UIView) {
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        isHidden = true
        
        addSubviewLayout(backgroundView)
        backgroundView.addSubviewLayout(messageLabel)
        
        Constraints.setBackgroundView(backgroundView, self)
        Constraints.setMessageLabel(messageLabel, backgroundView)
        
        // Setup animation anchors
        backgroundViewTopAnchor = backgroundView.bottomAnchor.constraint(equalTo: topAnchor)
        backgroundViewBottomAnchor = backgroundView.topAnchor.constraint(equalTo: topAnchor)
        backgroundViewTopAnchor.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Animation
    var currentPosition: [NSLayoutConstraint]?
    
    func startAnimatingDown() {
        if isAnimating == true {
            return // TODO: Add to a queue or interupt current animation
        }
        
        isAnimating = true
        backgroundViewTopAnchor.isActive = false
        backgroundViewBottomAnchor.isActive = true
    
        UIView.animate(withDuration: animationUpDownDuration, animations: {
            self.layoutIfNeeded()
        }, completion: { finished in
            self.startAnimatingUp()
        })
    }
    
    func startAnimatingUp() {
        
        backgroundViewBottomAnchor.isActive = false
        backgroundViewTopAnchor.isActive = true
        
        UIView.animate(withDuration: animationUpDownDuration, delay: messageDuration, options: [], animations: {
            self.layoutIfNeeded()
        }, completion: {  finished in
            self.isHidden = true
            self.isAnimating = false
        })
    
    }
}
