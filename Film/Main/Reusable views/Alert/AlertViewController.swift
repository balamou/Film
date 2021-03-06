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
    case success(String)
    case neutral(String)
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
                alertView.backgroundView.backgroundColor = alertView.errorColor
                
                alertView.startAnimatingDown()
            case .success(let message):
                alertView.isHidden = false
                alertView.messageLabel.text = message
                alertView.backgroundView.backgroundColor = alertView.successColor
            
                alertView.startAnimatingDown()
            case .neutral(let message):
                alertView.isHidden = false
                alertView.messageLabel.text = message
                alertView.backgroundView.backgroundColor = alertView.neutralColor
                
                alertView.startAnimatingDown()
            }
        }
    }
    
    init(parent: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        addAsChild(parent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

