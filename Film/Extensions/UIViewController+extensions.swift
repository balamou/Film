//
//  UIViewController+extensions.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildViewController(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func removeSelfAsChildViewController() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
