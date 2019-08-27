//
//  ShowsViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class ShowsViewController: UIViewController {
    
    var showsView: ShowsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showsView = ShowsView()
        view = showsView
    }
}



