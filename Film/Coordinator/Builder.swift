//
//  Builder.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class Builder {
    
    func createWatchingViewController(delegate: WatchingViewControllerDelegate?) -> WatchingViewController {
        let watchingVC = WatchingViewController()
        watchingVC.delegate = delegate
        watchingVC.tabBarItem = UITabBarItem(title: "Watching".localize(), image: ImageConstants.watchingImage, tag: 0)
        
        return watchingVC
    }
    
    func createShowViewController(delegate: ShowsDelegate?) -> ShowsViewController {
        let showsVC = ShowsViewController()
        showsVC.apiManager = MockSeriesAPI()
        showsVC.delegate = delegate
        showsVC.tabBarItem = UITabBarItem(title: "Shows".localize(), image: ImageConstants.showsImage, tag: 1)
        
        return showsVC
    }
    
    func createMoviesViewController() -> MoviewsViewController {
        let moviesVC = MoviewsViewController()
        moviesVC.tabBarItem = UITabBarItem(title: "Movies".localize(), image: ImageConstants.moviesImage, tag: 2)
        
        return moviesVC
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings".localize(), image: ImageConstants.settingsImage, tag: 3)
        
        return settingsVC
    }
}
