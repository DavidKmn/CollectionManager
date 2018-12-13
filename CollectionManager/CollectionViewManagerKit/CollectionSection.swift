//
//  CollectionSection.swift
//  CollectionManager
//
//  Created by David on 07/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

open class CollectionSection: Equatable, DiffableModel {
    
    /// Section Identifier
    public var UUID: String = NSUUID().uuidString
    
    /// Items inside the collection
    public private(set) var models: [DiffableModel]
    
    public var insetForSection: UIEdgeInsets = .zero
    public var minimumInterimSpacing: CGFloat = CGFloat.leastNormalMagnitude
    public var itemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    public var lineSpacing: CGFloat = 0
    
    public var header: CollectionSectionProtocol?
    public var footer: CollectionSectionProtocol?
    
    /// Temporary removed models, it's used to pass the correct model
    /// to didEndDisplay event; after sent it will be removed automatically.
    private var temporaryRemovedModels: [IndexPath : DiffableModel] = [:]
    
    private weak var manager: CollectionViewManager?
    
    public init(models: [DiffableModel]?, header: CollectionSectionProtocol? = nil, footer: CollectionSectionProtocol? = nil) {
        self.models = models ?? []
        self.header = header
        self.footer = footer
    }
    
    public static func == (lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        return (lhs.primaryKeyValue == rhs.primaryKeyValue)
    }
    
    public var primaryKeyValue: Int {
        return UUID.hashValue
    }
    
    public func set(with models: [DiffableModel]) {
        self.models = models
    }
    
    public func add(model: DiffableModel, at index: Int? = nil) {
        if let index = index, index < self.models.count {
            models.insert(model, at: index)
        } else {
            models.append(model)
        }
    }
    
    public func add(models: [DiffableModel], at index: Int? = nil) {
        guard let index = index, index < self.models.count else {
            self.models.append(contentsOf: models)
            return
        }
        self.models.insert(contentsOf: models, at: index)
    }
    
    public func getLastElement() -> DiffableModel? {
        return models.last
    }
    
    public func removeLast() -> DiffableModel? {
        return self.models.removeLast()
    }
    
    @discardableResult
    public func remove(at index: Int) -> DiffableModel? {
        guard index < models.count else { return nil }
        return self.models.remove(at: index)
    }
    
    @discardableResult
    public func remove(atIndicies indicies: [Int]) -> [DiffableModel]? {
        var removed: [DiffableModel] = []
        indicies.reversed().forEach {
            if $0 < self.models.count {
                removed.append(self.models.remove(at: $0))
            }
        }
        return removed
    }
    
    @discardableResult
    public func removeAll(keepingCapacity: Bool = true) -> Int {
        let count = self.models.count
        self.models.removeAll(keepingCapacity: keepingCapacity)
        return count
    }
    
    public func move(from startIndex: Int, to destinationIndex: Int) {
        guard startIndex < self.models.count, destinationIndex < self.models.count else {
            return
        }
        let removed = self.models.remove(at: startIndex)
        self.models.insert(removed, at: destinationIndex)
    }
}
