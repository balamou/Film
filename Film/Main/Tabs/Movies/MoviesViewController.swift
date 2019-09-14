//
//  MoviesViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


class MoviewsViewController: UIViewController {
    
    var moviewView: MoviesView = MoviesView()
    
    var data = [SeriesPresenter]()
    let apiManager: SeriesAPI? = MockSeriesAPI()
    
    // Params
    let numberOfShowsToLoad = 9
    var isInfiniteScrollEnabled: Bool = true
    var isFetchingMore: Bool = false
    
    // Collection view
    var collectionVC: AbstractedCollectionViewController!
    var collectionView: UICollectionView!
    
    // Sections
    var sections: [Section] = []
    var dataSection: Section!
    var idleSection: Section!
    var loadingSection: Section!
    var loadingMoreSection: Section!
    
    // Alert
    var alert: AlertViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = moviewView
        
        alert = AlertViewController(parent: self)
        
        initializeSections()
        addCollectionView()
        initialLoadSeries()
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
        dataSection = Section(cellType: ShowsCell.self, identifier: ShowsCell.identifier)
        loadingSection = Section(cellType: LoadingWaitCell.self, identifier: LoadingWaitCell.identifier)
        loadingMoreSection = Section(cellType: LoadingCell.self, identifier: LoadingCell.identifier)
        loadingSection.show()
        
        sections = [idleSection, dataSection, loadingSection, loadingMoreSection]
        
        configureDataPopulation()
    }
    
    func configureDataPopulation() {
        dataSection.cellStyle = CellStyle(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                                          columnDistance: 10.0,
                                          rowDistance: 20.0) {
                                            width, _ -> CGSize in
                                            ShowsCell.calculateCellSize(collectionViewWidth: width)
        }
        
        loadingMoreSection.cellStyle = CellStyle(insets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0), columnDistance: 0, rowDistance: 0, size: { (width, _) -> CGSize in
            CGSize(width: width, height: 50)
        })
        
        loadingMoreSection.populateCell = { cell, row in
            let loadingMoreCell = cell as! LoadingCell
            loadingMoreCell.spinner.startAnimating()
        }
        
        dataSection.populateCell = { [weak self] cell, row in
            guard let self = self else { return }
            guard self.data.count > row else { return }
            
            let showCell = cell as! ShowsCell
            showCell.posterURL = self.data[row].posterURL
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Collection View
    //----------------------------------------------------------------------
    func addCollectionView() {
        collectionVC = AbstractedCollectionViewController(sections: sections)
        collectionVC.scrollingDelegate = self
        addChildViewController(child: collectionVC)
        
        // Setup collection view
        collectionView = collectionVC.collectionView
        collectionView.alwaysBounceVertical = true
        
        [collectionView.topAnchor.constraint(equalTo: moviewView.navBar.bottomAnchor),
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
// Scrolling: "Infinite Scroll"
//----------------------------------------------------------------------
extension MoviewsViewController: ScrollingDelegate {
    
    func batchFetch() {
        if !isFetchingMore && isInfiniteScrollEnabled {
            loadingMoreSection.show()
            collectionView.reloadSections(IndexSet(integer: 3))
            isFetchingMore = true
            
            loadMoreOnDragDown()
        }
    }
}

//----------------------------------------------------------------------
// MARK: API Calls
//----------------------------------------------------------------------
extension MoviewsViewController {
    
    func initialLoadSeries() {
        apiManager?.getSeries(start: 0, quantity: numberOfShowsToLoad) { [weak self] series, isLast, error in
            guard let self = self else { return }
            self.sections.forEach { $0.hide() }
            
            if let error = error {
                // TODO: Show idle image/icon with error message (probably a new cell section)
                self.alert?.mode = .showMessage(error)
                self.idleSection.show()
                self.collectionView.reloadData()
            } else {
                self.data = series
                self.dataSection.numberOfItems = self.data.count
                self.dataSection.show()
                self.isInfiniteScrollEnabled = !isLast
                
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func loadMoreOnDragDown() {
        apiManager?.getSeries(start: data.count, quantity: numberOfShowsToLoad) { [weak self] series, isLast, error in
            guard let self = self else { return }
            
            if let error = error {
                self.alert?.mode = .showMessage(error) // show alert
                self.loadingMoreSection.hide()
                self.collectionView.reloadSections(IndexSet(integer: 3)) // refresh the section with the spinner
            } else {
                self.data += series
                self.dataSection.numberOfItems = self.data.count
                self.loadingMoreSection.hide()
                self.isInfiniteScrollEnabled = !isLast
                
                self.collectionView.reloadData()
            }
            
            self.isFetchingMore = false
        }
    }
    
    func refreshOnPull(completion: @escaping () -> ()) {
        apiManager?.getSeries(start: 0, quantity: numberOfShowsToLoad) { [weak self] series, isLast, error in
            guard let self = self else { return }
            
            if let error = error {
                self.alert?.mode = .showMessage(error) // show alert
            } else {
                self.data = series
                self.dataSection.numberOfItems = series.count
                self.isInfiniteScrollEnabled = !isLast
                self.collectionView.reloadData()
            }
            
            completion()
        }
    }
    
}
