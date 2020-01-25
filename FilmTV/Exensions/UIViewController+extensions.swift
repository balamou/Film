//
//  UIViewController+extensions.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
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
