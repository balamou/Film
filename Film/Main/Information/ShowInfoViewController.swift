//
//  ShowInfoViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class ShowInfoViewController: UIViewController {
    
    var showView: ShowInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showView = ShowInfoView()
        view = showView
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
