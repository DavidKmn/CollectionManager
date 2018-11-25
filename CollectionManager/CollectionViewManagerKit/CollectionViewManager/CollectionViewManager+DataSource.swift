//
//  CollectionViewManager+DataSource.swift
//  CollectionManager
//
//  Created by David on 11/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension CollectionViewManager: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let (model, linker) = self.context(forItemAt: indexPath)
        let cell = linker.getCell(from: collectionView, at: indexPath)
        linker.dispatch(event: .dequeue, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, cell: cell, scrollview: collectionView))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let (model, linker) = self.context(forItemAt: indexPath)
        linker.dispatch(event: .willDisplay, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, cell: cell, scrollview: collectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.linkers.forEach {
            ($0.value as! CollectionViewModelLinkerProtocolFunctions).dispatch(event: .endDisplay, context: InternalCollectionViewModelLinkContext(indexPath: indexPath, cell: cell, scrollview: collectionView))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (model, linker) = self.context(forItemAt: indexPath)
        linker.dispatch(event: .didSelect, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, scrollview: collectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let (model, linker) = self.context(forItemAt: indexPath)
        linker.dispatch(event: .didDeselect, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, scrollview: collectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let (model, linker) = self.context(forItemAt: indexPath)
        return (linker.dispatch(event: .shouldSelect, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, scrollview: collectionView)) as? Bool) ?? true
    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let (model, linker) = self.context(forItemAt: indexPath)
        return (linker.dispatch(event: .shouldDeselect, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, scrollview: collectionView)) as? Bool) ?? true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let (model, linker) = self.context(forItemAt: indexPath)
        return (linker.dispatch(event: .shouldHighlight, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, scrollview: collectionView)) as? Bool) ?? true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let (model, linker) = self.context(forItemAt: indexPath)
        linker.dispatch(event: .didHighlight, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, scrollview: collectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let (model, linker) = self.context(forItemAt: indexPath)
        linker.dispatch(event: .didUnhighlight, context: InternalCollectionViewModelLinkContext(model: model, indexPath: indexPath, scrollview: collectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        guard let layoutChangeHandler = self.onEvents.layoutDidChange, let layout = layoutChangeHandler(fromLayout, toLayout) else {
            return UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        }
        return layout
    }
}

// MARK: Header/Footer methods
extension CollectionViewManager {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.sections[indexPath.section]
        
        var id: String!
        var reusableViewFunction: CollectionHeaderFooterProtocolFunctions? = nil
        let reusableView: UICollectionReusableView!
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = section.header else { return UICollectionReusableView() }
            id = self.reusableViewsRegisterer.registerHeaderFooter(header, kind: kind)
            reusableViewFunction = (header as? CollectionHeaderFooterProtocolFunctions)
        case UICollectionView.elementKindSectionFooter:
            guard let footer = section.footer else { return UICollectionReusableView () }
            id = self.reusableViewsRegisterer.registerHeaderFooter(footer, kind: kind)
            reusableViewFunction = (footer as? CollectionHeaderFooterProtocolFunctions)
        default: return UICollectionReusableView()
        }

        defer {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                _ = reusableViewFunction?.disptach(.dequeue, kind: .header, view: reusableView, section: indexPath.section, collectionView: collectionView)
            case UICollectionView.elementKindSectionFooter:
                _ = reusableViewFunction?.disptach(.dequeue, kind: .footer, view: reusableView, section: indexPath.section, collectionView: collectionView)
            default: break
            }
        }
        
        reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            let header = sections[indexPath.section].header as? CollectionHeaderFooterProtocolFunctions
            _ = header?.disptach(.willDisplay, kind: .header, view: view, section: indexPath.section, collectionView: collectionView)
            self.onEvents.willDisplayHeader?((view, indexPath, collectionView))
        case UICollectionView.elementKindSectionFooter:
            let footer = sections[indexPath.section].footer as? CollectionHeaderFooterProtocolFunctions
            _ = footer?.disptach(.willDisplay, kind: .footer, view: view, section: indexPath.section, collectionView: collectionView)
            self.onEvents.willDisplayFooter?((view, indexPath, collectionView))
        default: break
        }
        view.layer.zPosition = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            let header = sections[indexPath.item].header as? CollectionHeaderFooterProtocolFunctions
            _ = header?.disptach(.endDisplay, kind: .header, view: view, section: indexPath.section, collectionView: collectionView)
            self.onEvents.endDisplayHeader?((view, indexPath, collectionView))
        case UICollectionView.elementKindSectionFooter:
            let footer = sections[indexPath.item].footer as? CollectionHeaderFooterProtocolFunctions
            _ = footer?.disptach(.endDisplay, kind: .footer, view: view, section: indexPath.section, collectionView: collectionView)
            self.onEvents.endDisplayFooter?((view, indexPath, collectionView))
        default: break
        }
    }
}
