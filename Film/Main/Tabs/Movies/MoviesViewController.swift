//
//  MoviesViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class MoviewsViewController: UIViewController {
    
    var moviewView: MoviesView!
    var collectionVC: AbstractedCollectionViewController!
    
    var data = [Watched]()
    let apiManager: WatchedAPI = MockWatchedAPI()
    
    // Sections
    var sections: [Section] = []
    var dataSection: Section!
    var idleSection: Section!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviewView = MoviesView()
        view = moviewView
        
        initializeSections()
        addCollectionView()
        initialLoadWatching()
    }
    
    func initializeSections() {
        
        let idleCellStyle = CellStyle(insets: .zero,
                                      columnDistance: 0,
                                      rowDistance: 0,
                                      size: { width, height in CGSize(width: width, height: height) })
        
        let dataSectionStyle = CellStyle(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), columnDistance: 10.0, rowDistance: 20.0) {
            width, _ -> CGSize in
            WatchingCell.calculateCellSize(collectionViewWidth: width)
        }
        
        idleSection = Section(cellType: IdleCell.self,
                                   identifier: "IdleCell",
                                   cellStyle: idleCellStyle,
                                   numberOfItems: 1,
                                   isShowing: true,
                                   populateCell: { _, _ in })
        
        dataSection = Section(cellType: WatchingCell.self,
                               identifier: "WatchingCell",
                               cellStyle: dataSectionStyle,
                               numberOfItems: 0,
                               isShowing: true)
        { [weak self] cell, row in
            guard let self = self else { return }
            
            let watchedCell = cell as! WatchingCell
            
            guard self.data.count > row else { return }
            
            watchedCell.populate(watched: self.data[row])
        }
        
        sections = [idleSection, dataSection]
    }
    
    func addCollectionView() {
        collectionVC = AbstractedCollectionViewController(sections: sections)
        collectionVC.collectionView.alwaysBounceVertical = true
        
        addChildViewController(child: collectionVC)
        guard let collectionView = collectionVC.view else { return }
        
        [collectionView.topAnchor.constraint(equalTo: moviewView.navBar.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].activate()
    }
    
    func initialLoadWatching() {
        apiManager.getWatched { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let watched):
                self.data = watched
                
                self.dataSection.numberOfItems = watched.count
                self.dataSection.isShowing = true
                self.idleSection.isShowing = false
                
                self.collectionVC.collectionView.reloadData()
            case .failure(_):
                return
            }
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension Array where Element: NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
}
