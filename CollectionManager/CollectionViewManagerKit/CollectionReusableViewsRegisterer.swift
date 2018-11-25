//
//  CollectionReusableViewsRegisterer.swift
//  CollectionManager
//
//  Created by David on 08/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit
/// Keeps the status of the registration of both cell and header/footer reusable identifiers
final class CollectionReusableViewsRegisterer {
    
    let collectionView: UICollectionView
    private var cellReuseIdentifiers: Set<String> = []
    private var headerReuseIdentifiers: Set<String> = []
    private var footerReuseIdentifiers: Set<String> = []
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    /// Registers Headers and Footers for a section
    func registerHeaderFooter(_ headerFooter: CollectionSectionProtocol, kind: String) -> String {
        let identifier = headerFooter.reuseIdentifier
        if (kind == UICollectionView.elementKindSectionHeader && self.headerReuseIdentifiers.contains(identifier)) ||
            (kind == UICollectionView.elementKindSectionFooter && self.footerReuseIdentifiers.contains(identifier)) {
            return identifier
        }
        
        let bundle = Bundle(for: headerFooter.viewClass)
        if let _ = bundle.path(forResource: identifier, ofType: "nib") {
            let nib = UINib(nibName: identifier, bundle: bundle)
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        } else {
            collectionView.register(headerFooter.viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
        return identifier
    }
    /// Registers Cell
    @discardableResult
    func registerCell(forLinker linker: ViewModelLinkerProtocol) -> Bool {
        let reuseIdentifier = linker.cellReuseIdentifier
        guard cellReuseIdentifiers.contains(reuseIdentifier) == false else {
            return false
        }
        
        let bundle = Bundle.init(for: linker.cellClass)
        if let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") {
            let nib = UINib(nibName: reuseIdentifier, bundle: bundle)
            collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            collectionView.register(linker.cellClass, forCellWithReuseIdentifier: reuseIdentifier)
        }
        cellReuseIdentifiers.insert(reuseIdentifier)
        return true
    }
}
