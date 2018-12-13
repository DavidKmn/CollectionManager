 //
//  CollectionViewManager.swift
//  CollectionManager
//
//  Created by David on 07/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class CollectionViewManager: NSObject, UICollectionViewDelegate {
    
    public enum ItemSize {
        case `default`
        case autoLayout(estimated: CGSize)
        case fixed(size: CGSize)
    }
    
    /// Collection View that is being managed
    public private(set) weak var collectionView: UICollectionView?
    
    /// Registered linkers for this CollectionViewManager
    public private(set) var linkers = [String: ViewModelLinkerProtocol]()
    
    /// Tracker for reuse identifiers of registered cells, headers & footers
    public private(set) var reusableViewsRegisterer: CollectionReusableViewsRegisterer
    
    /// Set it to `true` to enable cell prefetching. By default is set to `false`
    public var prefetchEnabled: Bool {
        set {
            if #available(iOS 10.0, *) {
                switch newValue {
                case true: self.collectionView!.prefetchDataSource = self
                case false: self.collectionView!.prefetchDataSource = nil
                }
            } else {
                debugPrint("Prefetch is available only from iOS 10")
            }
        }
        get {
            if #available(iOS 10.0, *) {
                return (self.collectionView!.prefetchDataSource != nil)
            } else {
                debugPrint("Prefetch is available only from iOS 10")
                return false
            }
        }
    }
    
    public private(set) var sections: [CollectionSection] = []

    private var _itemSize: ItemSize = .default
    
    public var itemSize: ItemSize {
        set {
            
            guard let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
                return
            }
            
            self._itemSize = newValue
            
            switch _itemSize {
            case .default:
                layout.estimatedItemSize = .zero
                layout.itemSize = CGSize(width: 50, height: 50)
            case .autoLayout(let estimated):
                layout.estimatedItemSize = estimated
                layout.itemSize = CGSize(width: 50, height: 50)
            case .fixed(let size):
                layout.estimatedItemSize = .zero
                layout.itemSize = size
            }
        }
        get {
            return _itemSize
        }
    }
    
    public struct Events {
        typealias HeaderFooterEvent = (view: UICollectionReusableView, indexPath: IndexPath, collectionView: UICollectionView)
        
        var layoutDidChange: ((_ old: UICollectionViewLayout, _ new: UICollectionViewLayout) -> UICollectionViewTransitionLayout?)? = nil
        
        var willDisplayHeader : ((HeaderFooterEvent) -> Void)? = nil
        var willDisplayFooter : ((HeaderFooterEvent) -> Void)? = nil
        
        var endDisplayHeader : ((HeaderFooterEvent) -> Void)? = nil
        var endDisplayFooter : ((HeaderFooterEvent) -> Void)? = nil
    }
    
    /// Events for the UICollectionView
    public var onEvents = CollectionViewManager.Events()
    
    /// Events for the UIScrollViewDelegate
    public var onScroll: ScrollViewEvents? = ScrollViewEvents()
    
    public init(_ collectionView: UICollectionView) {
        self.reusableViewsRegisterer = CollectionReusableViewsRegisterer(collectionView)
        super.init()
        self.collectionView = collectionView
        self.collectionView?.delegate = self

        self.collectionView?.dataSource = self
    }
    
    /// Reload collection.
    /// - Parameter after:     if defined a block animation is performed considering changes applied to the model;
    ///                        if `nil` reload is performed without animation.
    public func reloadData(after task: (() -> (Void))? = nil, onEnd: (() -> (Void))? = nil) {
        guard let task = task else {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            onEnd?()
            return
        }
        
        // Keep a reference to removed items in order to perform diff and animation
        let oldSections: [CollectionSection] = Array.init(self.sections)
        var oldItemsInSections: [String: [DiffableModel]] = [:]
        self.sections.forEach { oldItemsInSections[$0.UUID] = Array($0.models) }
        
        // Execute block for changes
        task()
        
        // Evaluate changes in sections
        let sectionChanges = SectionChanges.getChanges(from: oldSections, to: self.sections)
        
        DispatchQueue.main.async {
            self.collectionView?.performBatchUpdates({
                sectionChanges.applyChanges(toCollection: self.collectionView)
                
                // For any remaining active section evaluate changes inside
                self.sections.enumerated().forEach { (idx,newSection) in
                    if let oldSectionItems = oldItemsInSections[newSection.UUID] {
                        let itemChanges = SectionItemsChanges.getChanges(from: oldSectionItems, to: newSection.models, inSection: idx)
                        itemChanges.applyChangesToItems(inCollection: self.collectionView)
                    }
                }
                
            }, completion: { end in
                if end { onEnd?() }
            })
        }
    }
    
    /// Return item at a given path.
    public func item(at indexPath: IndexPath) -> DiffableModel? {
        guard indexPath.section < self.sections.count, indexPath.item < sections[indexPath.item].models.count else { return nil }
        return sections[indexPath.section].models[indexPath.item]
    }
    
    /// Get section at index
    public func section(at index: Int) -> CollectionSection? {
        guard index < self.sections.count else { return nil }
        return self.sections[index]
    }
    
    /// Registers a linker
    /// Be sure to register all required linkers before using the collection itself.
    public func register(linker: ViewModelLinkerProtocol) {
        let modelUUID = String(describing: linker.modelType)
        self.linkers[modelUUID] = linker
        self.reusableViewsRegisterer.registerCell(forLinker: linker)
    }
    
    /// Register multiple linkers
    public func register(linkers: [ViewModelLinkerProtocol]) {
        linkers.forEach(self.register)
    }
    
    /// Change the content of CollectionView completely
    public func setup(sections: [CollectionSection]) {
        self.sections = sections
    }
    
    /// Create a new section, append to the end of the managed sections, insert in it the passed models
    ///
    /// - Parameter models: models of the section
    @discardableResult
    public func append(models: [DiffableModel]) -> CollectionSection {
        let section = CollectionSection(models: models)
        self.sections.append(section)
        return section
    }
    
    /// Add a new sections at a given index
    public func append(section: CollectionSection, at index: Int? = nil) {
        guard let i = index, i < self.sections.count else {
            self.sections.append(section)
            return
        }
        self.sections.insert(section, at: i)
    }
    
    /// Add a list of the section starting at given index.
    public func append(sections: [CollectionSection], at index: Int? = nil) {
        guard let i = index, i < self.sections.count else {
            self.sections.append(contentsOf: sections)
            return
        }
        self.sections.insert(contentsOf: sections, at: i)
    }
    
    @discardableResult
    public func removeAll(keepingCapacity: Bool = false) -> Int {
        let count = self.sections.count
        self.sections.removeAll()
        return count
    }
    
    public func remove(sectionAt index: Int) -> CollectionSection? {
        guard index < self.sections.count else { return nil }
        return self.sections.remove(at: index)
    }
    
    @discardableResult
    public func remove(sectionsAt indexes: IndexSet) -> [CollectionSection] {
        var removed: [CollectionSection] = []
        indexes.forEach { (index) in
            if index < self.sections.count {
                removed.append(self.sections.remove(at: index))
            }
        }
        return removed
    }
    
    // MARK: Helpers
    /// Return the context for an element at given index.
    /// It returns the instance of the model and the registered linker used to represent it.
    ///
    /// - Parameter index: index path of the item.
    /// - Returns: context
    internal func context(forItemAt ip: IndexPath) -> (DiffableModel, CollectionViewModelLinkerProtocolFunctions) {
        let item: DiffableModel = self.sections[ip.section].models[ip.item]
        let modelUUID = String(describing: type(of: item.self))
        guard let linker = self.linkers[modelUUID] else {
            fatalError(findingLinkerError(forModelUUID: modelUUID))
        }
        return (item, linker as! CollectionViewModelLinkerProtocolFunctions)
    }
    
    internal func findingLinkerError(forModelUUID modelUUID: String) -> String {
        return "Error finding linker for model type: \(modelUUID)"
    }
    
    /// Returns prefetched models & linkers for the given index paths
    internal func prefetchModelsGroups(forIndexPaths ips: [IndexPath]) -> [PrefetchModelsGroup] {
        var list: [String: PrefetchModelsGroup] = [:]
        ips.forEach { (ip) in
            let model = self.sections[ip.section].models[ip.item]
            let modelUUID = String(describing: model.self)
            
            var context: PrefetchModelsGroup? = list[modelUUID]

            if let context = context {
                context.models.append(model)
                context.indexPaths.append(ip)
            } else {
                context = PrefetchModelsGroup(linker: self.linkers[modelUUID] as! CollectionViewModelLinkerProtocolFunctions)
                list[modelUUID] = context
            }
        }
        return Array(list.values)
    }
}
