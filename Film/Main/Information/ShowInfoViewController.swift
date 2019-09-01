//
//  ShowInfoViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-08-27.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ShowInfoViewControllerDelegate: AnyObject {
    func exitButtonTapped()
    func playButtonTapped()
    func thumbnailTapped()
}


class ShowInfoViewController: UIViewController {
    
    var showView: ShowInfoView!
    weak var delegate: ShowInfoViewControllerDelegate?
    var data: Series = Series.getMock()
    var seriesPresenter: SeriesPresenter? = nil {
        didSet {
            if let seriesPresenter = seriesPresenter {
                loadSeries(seriesPresenter: seriesPresenter)
            } else {
                delegate?.exitButtonTapped()
                // TODO: SHOW ERROR
            }
        }
    }
    
    // API
    //var apiManager:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showView = ShowInfoView()
        view = showView
        
        setupCollectionView()
    }
    
    //----------------------------------------------------------------------
    // MARK: Status bar
    //----------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //----------------------------------------------------------------------
    // MARK: Collection View
    //----------------------------------------------------------------------
    
    var episodesCollectionView: UICollectionView!
    
    func setupCollectionView() {
        episodesCollectionView = showView.episodesCollectionView
        
        episodesCollectionView.dataSource = self
        episodesCollectionView.delegate = self
        episodesCollectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.identifier)
        episodesCollectionView.alwaysBounceVertical = false
        
        episodesCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }
}

//----------------------------------------------------------------------
// MARK: API calls
//----------------------------------------------------------------------
extension ShowInfoViewController {
    
    func loadSeries(seriesPresenter: SeriesPresenter) {
        
    }
    
}


//----------------------------------------------------------------------
// MARK: Delegate action
//----------------------------------------------------------------------

extension ShowInfoViewController: HeaderViewDelegate {
    
    func exitButtonTapped() {
        delegate?.exitButtonTapped()
    }
    
    func playButtonTapped() {
        // Play last watched episode
        delegate?.playButtonTapped()
    }
    
    func seasonButtonTapped() {
        // Open ChangeSeasonVC
        print("Change season")
    }
    
}

extension ShowInfoViewController: EpisodeCellDelegate {
    
    func thumbnailTapped() {
        // Play episode
        delegate?.thumbnailTapped()
    }
    
}

//----------------------------------------------------------------------
// MARK: Data Source
//----------------------------------------------------------------------
extension ShowInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.identifier, for: indexPath) as! EpisodeCell
        cell.delegate = self
        let episode = data.episodes[indexPath.item]
        
        cell.episodeTitleLabel.text = episode.constructTitle()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        header.delegate = self
        
        header.titleLabel.text = data.title
        header.descriptionLabel.text = data.description ?? ""
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 440)
    }
    
}

//----------------------------------------------------------------------
// MARK: Flow layout
//----------------------------------------------------------------------
extension ShowInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 176) // size of a cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0) // overall insets of the collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0 // distance between rows
    }
}

