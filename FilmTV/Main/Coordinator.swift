//
//  Coordinator.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

class Coordinator {
    
    private let factory = ViewControllerFactory()
    
    func start() -> UIViewController {
        return factory.createShowsViewController()
    }
    
}
