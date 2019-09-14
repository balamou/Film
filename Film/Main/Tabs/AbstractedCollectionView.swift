//
//  AbstractedCollectionView.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-13.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

protocol AbstractedCell {
    associatedtype DataType
    
    static var identifier: String { get }
    func populate(with dataItem: DataType)
}

class Section {
    var cellType: AnyClass
    var identifier: String
    var numberOfItems: Int
    var populateCell: ((UICollectionViewCell, Int) -> Void)?
    
    var size: CGSize
    var insets: UIEdgeInsets
    var columnDistance: CGFloat
    var rowDistance: CGFloat
    
    var isShowing: () -> Bool
    
    init(cellType: AnyClass,
         identifier: String,
         size: CGSize,
         insets: UIEdgeInsets,
         columnDistance: CGFloat,
         rowDistance: CGFloat,
         isShowing: @escaping (() -> Bool),
         numberOfItems: Int,
         populateCell: ((UICollectionViewCell, Int) -> Void)?) {
        self.cellType = cellType
        self.identifier = identifier
        self.size = size
        self.insets = insets
        self.columnDistance = columnDistance
        self.rowDistance = rowDistance
        self.isShowing = isShowing
        self.numberOfItems = numberOfItems
        self.populateCell = populateCell
    }
}


class AbstractedCollectionViewController<DataType>: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var sections: [Section] = []
    
    init(sections: [Section]) {
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if sections[section].isShowing() {
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
        return sections[indexPath.section].size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].columnDistance // distance between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].rowDistance // distance between rows
    }
}


