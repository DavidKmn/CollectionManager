//
//  Change.swift
//  CollectionManager
//
//  Created by David on 01/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

/// The computed changes from diff
///
/// - insert: Insert an item at index
/// - delete: Delete an item from index
/// - update: update an item at index with another item
/// - move: Move the same item from this index to another index
internal enum Change<T> {
    /// - insert: A insertation step.
    case insert(index: Int, item: T)
    
    /// - delete: A deletion step.
    case delete(index: Int, item: T)
    
    /// - move: A move step.
    case move(from: Int, to: Int, item: T)
    
    /// update: A update step.
    case update(index: Int, item: T)
    
    /// A debug string describing the diff step.
    public var debugDescription: String {
        switch self {
            
        case .insert(let index, let item):
            return "+\(index)@\(item)"
            
        case .delete(let index, let item):
            return "-\(index)@\(item)"
            
        case .move(from: let from, to: let to, item: let item):
            return "\(from)>\(to)@\(item)"
            
        case .update(index: let index, item: let item):
            return "!\(index)@\(item)"
            
        }
    }
}
