//
//  DiffableModel.swift
//  CollectionManager
//
//  Created by David on 01/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

public protocol DiffableModel {
    /// Implementation of the protocol require the presence of id property which is used
    /// to uniquely identify an model. This is used by the Diff to evaluate
    /// what cells are removed/moved or deleted from table/collection and provide the right
    /// animation without an explicitly animation set.
    var primaryKeyValue: Int { get }
}

extension DiffableModel where Self : AnyObject {
    public var primaryKeyValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
}
