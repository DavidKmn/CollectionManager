//
//  CollectionViewManager+Prefetching.swift
//  CollectionManager
//
//  Created by David on 11/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension CollectionViewManager: UICollectionViewDataSourcePrefetching {
    
    internal class PrefetchModelsGroup {
        let linker: CollectionViewModelLinkerProtocolFunctions
        var models: [DiffableModel] = []
        var indexPaths: [IndexPath] = []
        
        public init(linker: CollectionViewModelLinkerProtocolFunctions) {
            self.linker = linker
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        self.prefetchModelsGroups(forIndexPaths: indexPaths).forEach { (prefetchedModelsGroup) in
            prefetchedModelsGroup.linker.dispatch(event: .prefetch, context: InternalCollectionViewModelLinkContext(models: prefetchedModelsGroup.models, indexPaths: prefetchedModelsGroup.indexPaths, scrollview: collectionView))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        self.prefetchModelsGroups(forIndexPaths: indexPaths).forEach { (prefetchedModelsGroup) in
            prefetchedModelsGroup.linker.dispatch(event: .cancelPrefetch, context: InternalCollectionViewModelLinkContext(models: prefetchedModelsGroup.models, indexPaths: prefetchedModelsGroup.indexPaths, scrollview: collectionView))
        }
    }
}
