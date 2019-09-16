//
//  Builder.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-30.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol Builder {
    func createWelcomeViewController() -> WelcomeViewController
    
    func createWatchingViewController(delegate: WatchingViewControllerDelegate?) -> WatchingViewController
    func createShowViewController(delegate: ShowsDelegate?) -> ShowsViewController
    func createMoviesViewController(delegate: MoviesDelegate?) -> MoviesViewController
    func createSettingsViewController() -> SettingsViewController
    
    func createShowInfoViewController(delegate: ShowInfoViewControllerDelegate?, series: SeriesPresenter) -> ShowInfoViewController
    func createMovieInfoViewController(delegate: MovieInfoViewControllerDelegate?, movie: MoviesPresenter) -> MovieInfoViewController
}


class StandardBuilder: Builder {
    
    func createWelcomeViewController() -> WelcomeViewController {
        let welcomeVC = WelcomeViewController()
        
        return welcomeVC
    }
    
    
    func createWatchingViewController(delegate: WatchingViewControllerDelegate?) -> WatchingViewController {
        let watchingVC = WatchingViewController()
        watchingVC.delegate = delegate
        watchingVC.apiManager = MockWatchedAPI()
        watchingVC.tabBarItem = UITabBarItem(title: "Watching".localize(), image: Images.watchingImage, tag: 0)
        
        return watchingVC
    }
    
    func createShowViewController(delegate: ShowsDelegate?) -> ShowsViewController {
        let showsVC = ShowsViewController()
        let apiManager: SeriesAPI = MockSeriesAPI()
        
        showsVC.apiManager = apiManager
        showsVC.delegate = delegate
        showsVC.tabBarItem = UITabBarItem(title: "Shows".localize(), image: Images.showsImage, tag: 1)
        
        return showsVC
    }
    
    func createMoviesViewController(delegate: MoviesDelegate?) -> MoviesViewController {
        let moviesVC = MoviesViewController()
        let apiManager: MoviesAPI = MockMoviesAPI()
        
        moviesVC.apiManager = apiManager
        moviesVC.delegate = delegate
        moviesVC.tabBarItem = UITabBarItem(title: "Movies".localize(), image: Images.moviesImage, tag: 2)
       
        return moviesVC
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings".localize(), image: Images.settingsImage, tag: 3)
        
        return settingsVC
    }
    
    func createShowInfoViewController(delegate: ShowInfoViewControllerDelegate?, series: SeriesPresenter) -> ShowInfoViewController {
        let apiManager = MockSeriesInfoAPI()
        let showInfoVC = ShowInfoViewController(seriesPresenter: series)
        showInfoVC.delegate = delegate
        showInfoVC.apiManager = apiManager
        
        return showInfoVC
    }
    
    func createMovieInfoViewController(delegate: MovieInfoViewControllerDelegate?, movie: MoviesPresenter) -> MovieInfoViewController {
        // TODO: pass movie to MovieInfo
        let apiManager = MockMovieInfoAPI()
        let movieInfoVC = MovieInfoViewController()
        movieInfoVC.delegate = delegate
        movieInfoVC.apiManager = apiManager
        
        return movieInfoVC
    }
}
