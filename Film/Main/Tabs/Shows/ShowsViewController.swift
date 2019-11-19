//
//  ShowsViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol ShowsDelegate: class {
    func showsViewController(_ showsViewController: ShowsViewController, selected series: SeriesPresenter)
}

enum ShowsViewControllerState {
    case loading
    case idle
    case hasData([SeriesPresenter], isLast: Bool)
}

class ShowsViewController: UIViewController {
    
    weak var delegate: ShowsDelegate?
    var apiManager: SeriesAPI?
    var alert: AlertViewController?
    
    private var showsView: ShowsView = ShowsView()
    private var data = [SeriesPresenter]()
    
    private var state: ShowsViewControllerState = .loading {
        didSet { switchState(state) }
    }
    
    // Params
    private let numberOfShowsToLoad = 9
    private var isInfiniteScrollEnabled: Bool = true
    private var isFetchingMore: Bool = false
    
    // Collection view
    private var collectionView: UICollectionView!
    
    // Sections
    private var sections: [Section] = []
    private var dataSection: Section!
    private var idleSection: Section!
    private var loadingSection: Section!
    private var loadingMoreSection: Section!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = showsView
        
        alert = AlertViewController(parent: self)
        
        initializeSections()
        addCollectionView()
        initialLoadSeries()
        
        state = .loading
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
        
        configureSections()
    }
    
    func configureSections() {
        dataSection.cellStyle = CellStyle(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), columnDistance: 10.0, rowDistance: 20.0)
        loadingMoreSection.cellStyle = CellStyle(insets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0), columnDistance: 0, rowDistance: 0)
        
        dataSection.cellStyle.size = { width, _ -> CGSize in ShowsCell.calculateCellSize(collectionViewWidth: width) }
        loadingMoreSection.cellStyle.size = { (width, _) -> CGSize in CGSize(width: width, height: 50) }
        
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
        
        dataSection.selectedCell = { [weak self] row in
            guard let self = self else { return }
            
            self.delegate?.showsViewController(self, selected: self.data[row])
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Collection View
    //----------------------------------------------------------------------
    func addCollectionView() {
        let collectionVC = AbstractedCollectionViewController(sections: sections)
        collectionVC.scrollingDelegate = self
        addChildViewController(child: collectionVC)
        
        collectionVC.addPullOnRefresh(for: { [weak self] in
            self?.refreshOnPull()
        })
        
        // Setup collection view
        collectionView = collectionVC.collectionView
        
        [collectionView.topAnchor.constraint(equalTo: showsView.navBar.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].activate()
    }
    
}

//----------------------------------------------------------------------
// MARK: State machine
//----------------------------------------------------------------------
extension ShowsViewController {
    
    func switchState(_ newState: ShowsViewControllerState) {
        collectionView.alwaysBounceVertical = true
        sections.forEach { $0.hide() }
        isInfiniteScrollEnabled = false
        data = []
        
        switch newState {
        case .loading:
            loadingSection.show()
            collectionView.alwaysBounceVertical = false // do not bounce when loading
        case .idle:
            idleSection.show()
        case .hasData(let series, isLast: let isLast):
            dataSection.show()
            
            data = series
            dataSection.numberOfItems = data.count
            isInfiniteScrollEnabled = !isLast // maybe
        }
        
        collectionView.reloadData()
    }
    
}

//----------------------------------------------------------------------
// Scrolling: "Infinite Scroll"
//----------------------------------------------------------------------
extension ShowsViewController: ScrollingDelegate {
    
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
extension ShowsViewController {
    
    func initialLoadSeries() {
        apiManager?.getSeries(start: 0, quantity: numberOfShowsToLoad) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let series, let isLast)):
                self.state = series.isEmpty ? .idle : .hasData(series, isLast: isLast)
                
            case .failure(let error):
                self.alert?.mode = .showMessage(error.toString)
                self.state = .idle
            }
        }
    }
    
    func loadMoreOnDragDown() {
        apiManager?.getSeries(start: data.count, quantity: numberOfShowsToLoad) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success((let series, let isLast)):
                let appendNewData = self.data + series
                self.state = appendNewData.isEmpty ? .idle : .hasData(appendNewData, isLast: isLast)
                
            case .failure(let error):
                self.alert?.mode = .showMessage(error.toString)
                self.loadingMoreSection.hide()
                self.collectionView.reloadSections(IndexSet(integer: 3)) // refresh the section with the spinner
            }
            
            self.isFetchingMore = false
        }
    }
    
    func refreshOnPull() {
        apiManager?.getSeries(start: 0, quantity: numberOfShowsToLoad) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success((let series, let isLast)):
                self.state = series.isEmpty ? .idle : .hasData(series, isLast: isLast)
                
            case .failure(let error):
                self.alert?.mode = .showMessage(error.toString)
            }
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
}

