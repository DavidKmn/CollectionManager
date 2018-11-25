//
//  Diff+Helpers.swift
//  CollectionManager
//
//  Created by David on 01/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

internal struct SectionChanges {
    private var inserts = IndexSet()
    private var deletes = IndexSet()
    private var updates = IndexSet()
    private var moves: [(from: Int, to: Int)] = []
    
    var hasChanges: Bool {
        return (self.inserts.count > 0 || self.deletes.count > 0 || self.updates.count > 0 || self.moves.count > 0)
    }
    
    static func getChanges(from oldSections: [CollectionSection], to newSections: [CollectionSection]) -> SectionChanges {
        let diffResult = diff(old: oldSections, new: newSections)
        var sectionChanges = SectionChanges()
        diffResult.forEach { (change) in
            switch change {
            case .delete(let index, _):
                sectionChanges.deletes.insert(index)
            case .insert(let index, _):
                sectionChanges.inserts.insert(index)
            case .move(let fromIndex, let toIndex, _):
                sectionChanges.moves.append( (from: fromIndex, to: toIndex))
            case .update(let index, _):
                sectionChanges.updates.insert(index)
            }
        }
        return sectionChanges
    }
    
    func applyChanges(toCollection collectionView: UICollectionView?) {
        guard let cv = collectionView, self.hasChanges else { return }
        cv.deleteSections(self.deletes)
        cv.insertSections(self.inserts)
        self.moves.forEach { (to, from) in
            cv.moveSection(from, toSection: to)
        }
        cv.reloadSections(self.updates)
    }
}

internal struct SectionItemsChanges {
    
    let insertions: [IndexPath]
    let deletions: [IndexPath]
    let updates: [IndexPath]
    let moves: [(from: IndexPath, to: IndexPath)]
    
    init(insertions: [IndexPath],
        deletions: [IndexPath],
        updates:[IndexPath],
        moves: [(from: IndexPath, to: IndexPath)]) {
        self.insertions = insertions
        self.deletions = deletions
        self.updates = updates
        self.moves = moves
    }
    
    
    static func getChanges(from oldItems: [DiffableModel], to newItems: [DiffableModel], inSection section: Int) -> SectionItemsChanges {
            let diff = HeckelDiff()
            
            let diffResult = diff.performDiff(old: oldItems, new: newItems)
            
            var deletions = [IndexPath]()
            var insertions = [IndexPath]()
            var updates = [IndexPath]()
            var moves = [(from: IndexPath, to: IndexPath)]()

            diffResult.forEach { (change) in
                switch change {
                case .insert(let index, _):
                    insertions.append(IndexPath(item: index, section: section))
                case .delete(let index, _):
                    deletions.append(IndexPath(item: index, section: section))
                case .update(let index, _):
                    updates.append(IndexPath(item: index, section: section))
                case .move(let fromIndex, let toIndex, _):
                    moves.append((from: IndexPath(item: fromIndex, section: section), to: IndexPath(item: toIndex, section: section)))
                }
            }
            
        return SectionItemsChanges(insertions: insertions, deletions: deletions, updates: updates, moves: moves)
    }
    
    func applyChangesToItems(inCollection collectionView: UICollectionView?) {
        guard let cv = collectionView else { return }
        
        cv.performBatchUpdates({
            cv.deleteItems(at: self.deletions)
            cv.insertItems(at: self.insertions)
            self.moves.forEach { cv.moveItem(at: $0.from, to: $0.to) }
            cv.reloadItems(at: self.updates)
        }, completion: nil)
    }
}
