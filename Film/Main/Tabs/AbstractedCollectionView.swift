//
//  AbstractedCollectionView.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-13.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

struct CellStyle {
    var insets: UIEdgeInsets
    var columnDistance: CGFloat
    var rowDistance: CGFloat
    var size: ((CGFloat, CGFloat) -> CGSize)
}

class Section {
    typealias ConfigureCell = (UICollectionViewCell, Int) -> Void
    
    var cellType: AnyClass
    var identifier: String
    var numberOfItems: Int
    var isShowing: Bool
    var populateCell: ((UICollectionViewCell, Int) -> Void)?
    
    var cellStyle: CellStyle
   
    init(cellType: AnyClass,
         identifier: String,
         cellStyle: CellStyle,
         numberOfItems: Int = 1,
         isShowing: Bool = false,
         populateCell: @escaping ConfigureCell = {_, _ in }) {
        self.cellType = cellType
        self.identifier = identifier
        self.cellStyle = cellStyle
        self.isShowing = isShowing
        self.numberOfItems = numberOfItems
        self.populateCell = populateCell
    }
    
    func hide() {
        isShowing = false
    }
    
    func show() {
        isShowing = true
    }
}


class AbstractedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var sections: [Section] = []
    
    init(sections: [Section]) {
        self.sections = sections
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
        
        sections.forEach {
            collectionView.register($0.cellType, forCellWithReuseIdentifier: $0.identifier)
        }
    }
    
    //----------------------------------------------------------------------
    // MARK: Data source
    //----------------------------------------------------------------------
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sections[section].isShowing {
            return sections[section].numberOfItems
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath)
        section.populateCell?(cell, indexPath.item)
        
        return cell
    }
    
    
    //----------------------------------------------------------------------
    // Scrolling: Flow layout
    //----------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].cellStyle.size(collectionView.frame.width, collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].cellStyle.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].cellStyle.columnDistance // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].cellStyle.rowDistance // distance between rows
    }
}


