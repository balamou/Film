//
//  ViewControllerFactory.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import Foundation

class ViewControllerFactory {
    
    func createVideoPlayerController() -> VideoPlayerController {
        return VideoPlayerController()
    }

    func createShowsViewController() -> ShowsViewController {
        return ShowsViewController()
    }
}
