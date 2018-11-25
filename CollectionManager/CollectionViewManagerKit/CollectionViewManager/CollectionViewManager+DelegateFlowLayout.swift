//
//  CollectionViewManager+DelegateFlowLayout.swift
//  CollectionManager
//
//  Created by David on 16/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension CollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let (model, linker) = self.context(forItemAt: indexPath)
        switch itemSize {
        case .default:
            guard let size = linker.dispatch(event: .itemSize, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, cell: nil, scrollview: collectionView)) as? CGSize else {
                return CGSize.zero
            }
            return size
        case .autoLayout(let estimated):
            return estimated
        case .fixed(let size):
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sections[section].insetForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.sections[section].minimumInterimSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sections[section].itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let footer = sections[section].footer as? CollectionHeaderFooterProtocolFunctions
        guard let size = footer?.disptach(.referenceSize, kind: .footer, view: nil, section: section, collectionView: collectionView) as? CGSize else {
            return .zero
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = sections[section].header as? CollectionHeaderFooterProtocolFunctions
        guard let size = header?.disptach(.referenceSize, kind: .header, view: nil, section: section, collectionView: collectionView) as? CGSize else {
            return .zero
        }
        return size
    }
}
