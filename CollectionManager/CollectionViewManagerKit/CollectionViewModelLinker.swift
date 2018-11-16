//
//  CollectionViewModelLinker.swift
//  CollectionManager
//
//  Created by David on 10/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

/// Connects and identifies a pair of model & cell used to represent the data
open class CollectionViewModelLinker<Model: DiffableModel, Cell: CellProtocol>: CollectionViewModelLinkerProtocol, CustomStringConvertible, CollectionViewModelLinkerProtocolFunctions {
    
    public var modelType: Any.Type = Model.self
    public var cellType: Any.Type = Cell.self
    
    public var cellReuseIdentifier: String = Cell.reuseIdentifier
    
    public var cellClass: AnyClass = Cell.self
    
    public var description: String {
        return "Linked -> Model Type: \(String(describing: self.modelType)) & Cell Type: \(String(describing: self.cellType))"
    }
    
    /// Initialize a new linker and allows its configuration via builder callback.
    ///
    /// - Parameter configuration: configuration callback
    public init(_ config: ((CollectionViewModelLinker) -> Void)? = nil) {
        config?(self)
    }
    
    public struct Events<Model, Cell> {
        public typealias EventContext = Context<Model, Cell>
        
        public var dequeue: ((EventContext) -> Void)? = nil
        
        public var shouldSelect: ((EventContext) -> Bool)? = nil
        public var shouldDeselect: ((EventContext) -> Bool)? = nil
        public var didSelect: ((EventContext) -> Void)? = nil
        public var didDeselect: ((EventContext) -> Void)? = nil
        public var didHighlight: ((EventContext) -> Void)? = nil
        public var didUnhighlight: ((EventContext) -> Void)? = nil
        public var shouldHighlight: ((EventContext) -> Bool)? = nil
        public var willDisplay: ((_ cell: Cell, _ path: IndexPath) -> Void)? = nil
        public var endDisplay: ((_ cell: Cell, _ path: IndexPath) -> Void)? = nil
        public var shouldShowEditMenu: ((EventContext) -> Bool)? = nil
        public var canPerformEditAction: ((EventContext) -> Bool)? = nil
        public var performEditAction: ((_ ctx: EventContext, _ selector: Selector, _ sender: Any?) -> Void)? = nil
        public var canFocus: ((EventContext) -> Bool)? = nil
        
        public var itemSize: ((EventContext) -> CGSize)? = nil
        
        // Prefetching
        public var prefetch: ((_ items: [Model], _ paths: [IndexPath], _ collection: UICollectionView) -> Void)? = nil
        public var cancelPrefetch: ((_ items: [Model], _ paths: [IndexPath], _ collection: UICollectionView) -> Void)? = nil
        
        public var shouldSpringLoad: ((EventContext) -> Bool)? = nil
    }
    
    /// Events for Linker
    public var onEvent = CollectionViewModelLinker.Events<Model, Cell>()
    
    /// Instances of the Context are generated automatically and received from events; you don't need to allocate on your own.
    public struct Context<Model, Cell> {
        public let indexPath: IndexPath
        /// Represents the model instance
        public let model: Model
        public private(set) weak var collectionView: UICollectionView?
        /// Internal cell representation, may be = nil for some events
        private let _cell: Cell?
        /// Represents the cell instance
        public var cell: Cell? {
            guard let c = _cell else {
                return collectionView?.cellForItem(at: self.indexPath) as? Cell
            }
            return c
        }
        
        internal init(model: DiffableModel, cell: CellProtocol?, indexPath: IndexPath, collectionView: UICollectionView) {
            self.model = model as! Model
            self._cell = cell as? Cell
            self.indexPath = indexPath
            self.collectionView = collectionView
        }
        
        internal init (internalGenericContext: InternalCollectionViewModelLinkContext) {
            self.model = (internalGenericContext.model as! Model)
            self._cell = (internalGenericContext.cell as? Cell)
            self.indexPath = internalGenericContext.indexPath!
            self.collectionView = (internalGenericContext.container as! UICollectionView)
        }
        
    }
    
    func dispatch(event: CollectionViewModelLinkerEventType, context: InternalCollectionViewModelLinkContext) -> Any? {
        switch event {
        case .dequeue:
            guard let handler = self.onEvent.dequeue else { return nil }
            handler(Context<Model, Cell>(internalGenericContext: context))
        case .shouldSelect:
            guard let handler = self.onEvent.shouldSelect else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        case .shouldDeselect:
            guard let handler = self.onEvent.shouldDeselect else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        case .didSelect:
            guard let handler = self.onEvent.didSelect else { return nil }
            handler(Context<Model, Cell>(internalGenericContext: context))
        case .didDeselect:
            guard let handler = self.onEvent.didDeselect else { return nil }
            handler(Context<Model, Cell>(internalGenericContext: context))
        case .didHighlight:
            guard let handler = self.onEvent.didHighlight else { return nil }
            handler(Context<Model, Cell>(internalGenericContext: context))
        case .didUnhighlight:
            guard let handler = self.onEvent.didUnhighlight else { return nil }
            handler(Context<Model, Cell>(internalGenericContext: context))
        case .shouldHighlight:
            guard let handler = self.onEvent.shouldHighlight else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        case .willDisplay:
            guard let handler = self.onEvent.willDisplay, let cell = context.cell as? Cell, let ip = context.indexPath else { return nil }
            handler(cell, ip)
        case .endDisplay:
            guard let handler = self.onEvent.endDisplay, let cell = context.cell as? Cell, let ip = context.indexPath else { return nil }
            handler(cell, ip)
        case .shouldShowEditMenu:
            guard let handler = self.onEvent.shouldShowEditMenu else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        case .canPerformEditAction:
            guard let handler = self.onEvent.canPerformEditAction else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        case .performEditAction:
            guard let handler = self.onEvent.performEditAction, let action = context.parameter1 as? Selector, let sender = context.parameter2 else { return nil }
            handler(Context<Model, Cell>(internalGenericContext: context), action, sender)
        case .canFocus:
            guard let handler = self.onEvent.canFocus else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        case .itemSize:
            guard let handler = self.onEvent.itemSize else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        case .prefetch:
            guard let handler = self.onEvent.prefetch, let items = context.models as? [Model], let ips = context.indexPaths, let cv = context.container as? UICollectionView else { return nil }
            handler(items, ips, cv)
        case .cancelPrefetch:
            guard let handler = self.onEvent.cancelPrefetch, let items = context.models as? [Model], let ips = context.indexPaths, let cv = context.container as? UICollectionView else { return nil }
            handler(items, ips, cv)
        case .shouldSpringLoad:
            guard let handler = self.onEvent.shouldSpringLoad else { return nil }
            return handler(Context<Model, Cell>(internalGenericContext: context))
        }
        return nil
    }
    
    func getCell(from collection: UICollectionView, at indexPath: IndexPath?) -> UICollectionViewCell {
        guard let ip = indexPath else {
            let typeCastedCell = self.cellClass as! UICollectionViewCell.Type
            let cellInstance = typeCastedCell.init()
            return cellInstance
        }
        return collection.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: ip)
    }
    
    /// Equal if they Link together the same exact cell type and model type
    public static func == (lhs: CollectionViewModelLinker, rhs: CollectionViewModelLinker) -> Bool {
       return (String(describing: lhs.modelType) == String(describing: rhs.modelType)) &&
            (String(describing: lhs.cellType) == String(describing: rhs.cellType))
    }
}
