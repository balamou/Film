//
//  ChangeSeasonViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-09.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ChangeSeasonViewControllerDelegate: AnyObject {
    func seasonButtonTapped(season: Int)
    func closedButtonTapped()
}

class ChangeSeasonViewController: UIViewController {
    
    weak var delegate: ChangeSeasonViewControllerDelegate?
    var changeSeasonView: ChangeSeasonView!
    var totalSeasons: Int
    var selectedSeason: Int
    
    
    init(totalSeasons: Int, selectedSeason: Int) {
        self.totalSeasons = totalSeasons
        self.selectedSeason = selectedSeason
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeSeasonView = ChangeSeasonView()
        view = changeSeasonView
        
        changeSeasonView.seasonCollectionView.dataSource = self
        changeSeasonView.seasonCollectionView.delegate = self
        changeSeasonView.seasonCollectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.identifier)
        
        changeSeasonView.exitSeasonSelectorButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        delegate?.closedButtonTapped()
    }
}

extension ChangeSeasonViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSeasons
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.identifier, for: indexPath) as! SeasonCell
        
        cell.seasonLabel.text = "\(indexPath.row + 1)"
        
        if indexPath.row + 1  == selectedSeason {
            cell.seasonLabel.font = Fonts.helveticaBold(size: 15.0)
        }
        
        return cell
    }

}

extension ChangeSeasonViewController: UICollectionViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.seasonButtonTapped(season: indexPath.row + 1)
    }
}

extension ChangeSeasonViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30) // cell size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero // overall insets of the collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // distance between rows
    }
    
    
}
