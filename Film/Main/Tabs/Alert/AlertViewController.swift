//
//  AlertViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-29.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


enum AlertMode {
    case hidden
    case showMessage(String)
}

class AlertViewController: UIViewController {
    var alertView: AlertView!
    var mode: AlertMode = .hidden {
        didSet {
            switch mode {
            case .hidden:
                alertView.isHidden = true
            case .showMessage(let error):
                alertView.isHidden = false
                alertView.messageLabel.text = error
                
                alertView.startAnimatingDown()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView = AlertView()
        self.view = alertView
    }
    
    func addAsChild(_ parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(view)
        self.didMove(toParent: parent)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        setViewConstraints(view, parent.view)
    }
    
    func setViewConstraints(_ warning: UIView, _ view: UIView) {
        warning.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        warning.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        warning.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warning.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
}

