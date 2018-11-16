//
//  DiffingAlgorithmProtocol.swift
//  CollectionManager
//
//  Created by David on 01/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

internal protocol DiffingAlgorithm {
    func performDiff(old: [DiffableModel], new: [DiffableModel]) -> [Change<DiffableModel>]
}

extension DiffingAlgorithm {
    func performPreprocessing(old: [DiffableModel], new: [DiffableModel]) -> [Change<DiffableModel>]? {
        switch (old.isEmpty, new.isEmpty) {
        case (true, true):
            // empty
            return []
        case (true, false):
            // all .insert
            return new.enumerated().map { (arg) -> Change<DiffableModel> in
                let (index, item) = arg
                return .insert(index: index, item: item)
            }
        case (false, true):
            // all .delete
            return old.enumerated().map { (arg) -> Change<DiffableModel> in
                let (index, item) = arg
                return .delete(index: index, item: item)
            }
        default:
            return nil
        }
    }
}
