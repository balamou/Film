//
//  WatchingViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class WatchingViewController: UIViewController {
    
    var watchingView: WatchingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchingView = WatchingView()
        view = watchingView
        
        // TMP CODE
        tmpCODE()
    }
    
    // TMP CODE+++
    func tmpCODE() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tmpCODETap))
        watchingView.logoImage.isUserInteractionEnabled = true
        watchingView.logoImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func tmpCODETap() {
        let playerVC = VideoPlayerController()
        
        self.navigationController?.pushViewController(playerVC, animated: false)
    }
    // TMP CODE---
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    //----------------------------------------------------------------------
    // Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
