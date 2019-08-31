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
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.3294117647, blue: 0.3803921569, alpha: 1)
        
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Warning message"
        label.textColor = UIColor.white
        label.font = FontStandard.helveticaNeue(size: 15.0)
        
        return label
    }()
    
    class Constraints {
        
        static func setMessageLabel(_ label: UILabel, _ view: UIView) {
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        // Animation
        
        static func topPosition(_ roundView: UIView, _ view: UIView) -> [NSLayoutConstraint] {
            return [roundView.bottomAnchor.constraint(equalTo: view.topAnchor),
            roundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundView.widthAnchor.constraint(equalToConstant: 300),
            roundView.heightAnchor.constraint(equalToConstant: 60)]
        }
        
        static func bottomPosition(_ roundView: UIView, _ view: UIView) -> [NSLayoutConstraint] {
            return [roundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            roundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundView.widthAnchor.constraint(equalToConstant: 300),
            roundView.heightAnchor.constraint(equalToConstant: 60)]
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        isHidden = true
        
        addSubviewLayout(backgroundView)
        backgroundView.addSubviewLayout(messageLabel)
        
        pickNewConstraints(Constraints.topPosition(backgroundView, self))
        Constraints.setMessageLabel(messageLabel, backgroundView)
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
        pickNewConstraints(Constraints.bottomPosition(backgroundView, self))
    
        UIView.animate(withDuration: animationUpDownDuration, animations: {
            self.layoutIfNeeded()
        }, completion: { finished in
            self.startAnimatingUp()
        })
    }
    
    func startAnimatingUp() {
        
        pickNewConstraints(Constraints.topPosition(backgroundView, self))
     
        UIView.animate(withDuration: animationUpDownDuration, delay: messageDuration, options: [], animations: {
            self.layoutIfNeeded()
        }, completion: {  finished in
            self.isHidden = true
            self.isAnimating = false
        })
    
    }
    
    func pickNewConstraints(_ constraints: [NSLayoutConstraint]) {
        
        if let currentPosition = currentPosition {
            NSLayoutConstraint.deactivate(currentPosition)
        }
        
        currentPosition = constraints
        NSLayoutConstraint.activate(constraints)
    }
}
