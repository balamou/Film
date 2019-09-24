//
//  WatchingViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol WatchingViewControllerDelegate: AnyObject {
    func playTapped(watched: Watched)
    func moreInfoTapped(watched: Watched)
}

enum WatchingViewControllerMode {
    case idle
    case loading
    case hasData([Watched])
}

class WatchingViewController: UIViewController {
    
    weak var delegate: WatchingViewControllerDelegate?
    
    var watchingView: WatchingView = WatchingView()
    var data = [Watched]()
    var apiManager: WatchedAPI?
    
    // Collection view
    var collectionVC: AbstractedCollectionViewController!
    var collectionView: UICollectionView!
    
    // Sections
    var sections: [Section] = []
    var dataSection: Section!
    var idleSection: Section!
    var loadingSection: Section!
    
    // Alert
    var alert: AlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = watchingView
        
        alert = AlertViewController(parent: self)
        
        initializeSections()
        addCollectionView()
        initialLoadWatching()
        setupPullToRefresh()
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //----------------------------------------------------------------------
    // MARK: Sections
    //----------------------------------------------------------------------
    func initializeSections() {
        idleSection = Section(cellType: IdleCell.self, identifier: IdleCell.identifier)
        dataSection = Section(cellType: WatchingCell.self, identifier: WatchingCell.identifier)
        loadingSection = Section(cellType: LoadingWaitCell.self, identifier: LoadingWaitCell.identifier)
        loadingSection.show()
        
        sections = [idleSection, dataSection, loadingSection]
        configureDataPopulation()
    }
    
    func configureDataPopulation() {
        dataSection.cellStyle = CellStyle(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                                          columnDistance: 10.0,
                                          rowDistance: 20.0) {
                                            width, _ -> CGSize in
                                            WatchingCell.calculateCellSize(collectionViewWidth: width)
        }
        
        dataSection.populateCell = { [weak self] cell, row in
            guard let self = self else { return }
            guard self.data.count > row else { return }
            
            let watchedCell = cell as! WatchingCell
            watchedCell.populate(watched: self.data[row])
            watchedCell.delegate = self
            watchedCell.id = row
        }
    }
    
    func addCollectionView() {
        collectionVC = AbstractedCollectionViewController(sections: sections)
        addChildViewController(child: collectionVC)
        
        // Setup collection view
        collectionView = collectionVC.collectionView
        collectionView.alwaysBounceVertical = true
        
        [collectionView.topAnchor.constraint(equalTo: watchingView.navBar.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].activate()
    }
    
    func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTriggered(_:)), for: .valueChanged)
    }
    
    @objc func refreshTriggered(_ sender: UIRefreshControl) {
        refreshOnPull {
            sender.endRefreshing()
        }
    }
    
}


//----------------------------------------------------------------------
// MARK: API calls
//----------------------------------------------------------------------
extension WatchingViewController {
    
    func initialLoadWatching() {
        apiManager?.getWatched { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let watched):
                self.data = watched
                
                self.dataSection.numberOfItems = watched.count
                self.dataSection.show()
                self.loadingSection.hide()
                
                self.collectionView.reloadData()
            case .failure(_):
                return
            }
        }
    }
    
    func refreshOnPull(completion: @escaping () -> ()) {
        apiManager?.getWatched { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let watched):
                self.sections.forEach { $0.hide() }
                
                if watched.isEmpty {
                    self.idleSection.show()
                    self.collectionView.reloadSections(IndexSet(integersIn: 0...1)) // reload both sections
                } else {
                    self.dataSection.show()
                    self.dataSection.numberOfItems = watched.count
                    self.collectionView.reloadSections(IndexSet(integersIn: 0...1)) // reload both sections
                }
                
            case .failure(let error):
                self.alert?.mode = .showMessage(error.getDescription())
            }
            
            completion()
        }
    }
}


//----------------------------------------------------------------------
// MARK: Delegate
//----------------------------------------------------------------------
extension WatchingViewController: WatchingCellDelegate {
    
    func playButtonTapped(row: Int) {
        delegate?.playTapped(watched: data[row])
    }
    
    func informationButtonTapped(row: Int) {
        delegate?.moreInfoTapped(watched: data[row])
    }
    
}
