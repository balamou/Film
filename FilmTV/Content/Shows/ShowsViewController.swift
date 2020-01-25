//
//  ShowsViewController.swift
//  FilmTV
//
//  Created by Michel Balamou on 2020-01-24.
//  Copyright © 2020 ElasticPanda. All rights reserved.
//

import UIKit

struct ShowItem: Decodable {
    var id: Int
    var title: String
    var posterURL: String?
}


class ShowsViewController: UIViewController {
    private var dataSection: Section!
    private var data: [ShowItem] = [ShowItem(id: 4, title: "Rick and morty", posterURL: "http://"), ShowItem(id: 5, title: "Game of thrones", posterURL: "http://")]
    
    override func viewDidLoad() {
        initializeSections()
    }
    
    //----------------------------------------------------------------------
    // MARK: Sections
    //----------------------------------------------------------------------
    private func initializeSections() {
        dataSection = Section(cellType: ShowCell.self, identifier: ShowCell.identifier)
        dataSection.numberOfItems = data.count
        configureSections()
        
        
        addCollectionView(sections: [dataSection])
    }
    
    private func configureSections() {
        dataSection.cellStyle = CellStyle(insets: .zero, columnDistance: 10.0, rowDistance: 20.0)
        
        dataSection.cellStyle.size = { width, _ -> CGSize in CGSize(width: 300, height: 400)}//ShowCell.calculateCellSize(collectionViewWidth: width) }
        
        dataSection.populateCell = { [weak self] cell, row in
            guard let self = self else { return }
            guard self.data.count > row else { return }
            
            let showCell = cell as! ShowCell
//            showCell.posterURL = self.data[row].posterURL
        }
        
        dataSection.show()
    }
    
    //----------------------------------------------------------------------
    // MARK: Collection View
    //----------------------------------------------------------------------
    private func addCollectionView(sections: [Section]) {
        let collectionVC = GeneralCollectionViewController(sections: sections)
        addChildViewController(child: collectionVC)
        
        // Setup collection view
        let collectionView = collectionVC.collectionView!
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
