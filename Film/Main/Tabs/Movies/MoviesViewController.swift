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
    var testBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviewView = MoviesView()
        view = moviewView
        
        let sections: [Section] = [
            Section(cellType: IdleCell.self,
                    identifier: "IdleCell",
                    size: { width, height in CGSize(width: width, height: height) },
                    insets: .zero,
                    columnDistance: 10.0,
                    rowDistance: 20.0,
                    isShowing: { self.testBool },
                    numberOfItems: 1,
                    populateCell: { cell, row in
            }),
            Section(cellType: WatchingCell.self,
                    identifier: "WatchingCell",
                    size: { _, _ in CGSize(width: 100, height: 200)},
                    insets: .zero,
                    columnDistance: 10.0,
                    rowDistance: 20.0,
                    isShowing: { !self.testBool },
                    numberOfItems: 4,
                    populateCell: { cell, row in
                        
            })
        ]
        
        collectionVC = AbstractedCollectionViewController(sections: sections)
        
        addCollectionView()
        
        // TEST
        let logoImage = moviewView.navBar.logoImage
        logoImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(testFunc))
        logoImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func testFunc() {
        testBool.toggle()
        collectionVC.collectionView.reloadData()
    }
    
    func addCollectionView() {
        addChildViewController(child: collectionVC)
        guard let collectionView = collectionVC.view else { return }
        
        [collectionView.topAnchor.constraint(equalTo: moviewView.navBar.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].activate()
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
