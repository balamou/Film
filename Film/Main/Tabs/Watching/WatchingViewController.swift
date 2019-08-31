//
//  WatchingViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-26.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol WatchingViewControllerDelegate {
    func playTapped()
    func moreInfoTapped()
}

enum WatchingViewControllerMode {
    case idle
    case loading
    case hasData([Watched])
}

class WatchingViewController: UIViewController {
    
    var mode: WatchingViewControllerMode = .loading {
        didSet {
            switchedMode(newMode: mode)
        }
    }
    var data: [Watched] = []
    
    var watchingView: WatchingView!
    var delegate: WatchingViewControllerDelegate?
    var apiManager: WatchedAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchingView = WatchingView()
        view = watchingView
        
        setupCollectionView()
        initialLoadWatching()
        
        // TMP
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTMP))
        watchingView.navBar.logoImage.isUserInteractionEnabled = true
        watchingView.navBar.logoImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedTMP() {
        
        switch mode{
        case .idle:
            mode = .loading
        case .loading:
            mode = .hasData(data + Watched.getRandomMock())
        case .hasData(_):
            mode = .idle
        }
        
    }
    
    func switchedMode(newMode: WatchingViewControllerMode) {
        switch mode {
        case .idle:
            watchingView.idleView.isHidden = false
            watchingView.loadingView.isHidden = true
            watchingView.collectionView.isHidden = true
        case .loading:
            watchingView.idleView.isHidden = true
            watchingView.loadingView.isHidden = false
            watchingView.collectionView.isHidden = true
        case .hasData(let freshData):
            watchingView.idleView.isHidden = true
            watchingView.loadingView.isHidden = true
            watchingView.collectionView.isHidden = false
            
            self.data = freshData
            watchingView.collectionView.reloadData()
        }
    }
    
    //----------------------------------------------------------------------
    // Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //----------------------------------------------------------------------
    // Collection View
    //----------------------------------------------------------------------
    weak var collectionView: UICollectionView!
    
    func setupCollectionView() {
        collectionView = watchingView.collectionView
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WatchingCell.self, forCellWithReuseIdentifier: WatchingCell.identifier)
        collectionView.alwaysBounceVertical = true
    }
    
}


//----------------------------------------------------------------------
// MARK: API calls
//----------------------------------------------------------------------
extension WatchingViewController {
    
    func initialLoadWatching() {
        apiManager?.getWatched {
            [weak self] watched, error in
            if let error = error {
                // TODO: Set alert
            } else {
                self?.mode = .hasData(watched)
            }
        }
    }
}

//----------------------------------------------------------------------
// MARK: Watching Cell Actions
//----------------------------------------------------------------------
extension WatchingViewController: WatchingCellDelegate {
    
    func playButtonTapped() {
        delegate?.playTapped()
    }
    
    func informationButtonTapped() {
        delegate?.moreInfoTapped()
    }
}


//----------------------------------------------------------------------
// MARK: Data Source
//----------------------------------------------------------------------
extension WatchingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchingCell.identifier, for: indexPath) as! WatchingCell
        
        let data = self.data[indexPath.item]
        cell.delegate = self
        cell.viewedLabel.text = data.label
        cell.progress = data.stoppedAt
        cell.posterURL = data.posterURL
        
        return cell
    }
}


//----------------------------------------------------------------------
// MARK: Flow Layout
//----------------------------------------------------------------------
extension WatchingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 197) // size of a cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0) // overall insets of the collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0 // distance between rows
    }
}
