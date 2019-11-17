//
//  ChangeSeasonViewController.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-09.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit


protocol ChangeSeasonViewControllerDelegate: class {
    func seasonButtonTapped(season: Int)
    func closeButtonTapped()
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
        
        
        let collectionView = changeSeasonView.seasonCollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.identifier)
        collectionView.alwaysBounceVertical = true
        
        changeSeasonView.exitSeasonSelectorButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }
}

extension ChangeSeasonViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSeasons
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.identifier, for: indexPath) as! SeasonCell
        
        cell.seasonLabel.text = "Season".localize() + " \(indexPath.row + 1)"
        
        if indexPath.row + 1  == selectedSeason {
            cell.seasonLabel.font = Fonts.generateFont(font: "OpenSans-Bold", size: 18.0)
            cell.seasonLabel.textColor = .white
        }
        
        return cell
    }

}

extension ChangeSeasonViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.seasonButtonTapped(season: indexPath.item + 1)
    }
}

extension ChangeSeasonViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // cell size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let bottomInset = 2 * ChangeSeasonView.Constraints.bottomButtonOffset + ChangeSeasonView.Constraints.exitButtonSize
        return UIEdgeInsets(top: 100.0, left: 0, bottom: bottomInset, right: 0) // overall insets of the collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // distance between rows
    }
    
}
