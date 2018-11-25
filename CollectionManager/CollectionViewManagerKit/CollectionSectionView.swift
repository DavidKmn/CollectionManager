//
//  CollectionSectionHeaderFooterView.swift
//  CollectionManager
//
//  Created by David on 14/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

final public class CollectionSectionView<T: HeaderFooterProtocol>: CollectionSectionProtocol, CollectionHeaderFooterProtocolFunctions {
    
    public var section: CollectionSection? = nil
    
    public var viewClass: AnyClass = T.self
    public var reuseIdentifier: String = T.reuseIdentifier
    
    /// Section Events
    public var onEvent = Event<T>()
    
    /// Context of the event sent to section's view.
    public struct Context<T> {
        
        /// Kind: (footer or header)
        public private(set) var kind: SectionViewKind
        
        /// Parent collection
        public private(set) weak var collectionView: UICollectionView?
        
        /// Instance of the view dequeued for this section.
        public private(set) var view: T?
        
        /// Index of the section.
        public private(set) var section: Int
        
        /// Parent collection's size.
        public var collectionSize: CGSize? {
            return self.collectionView?.bounds.size
        }
        
        /// Initialize a new context (private).
        public init(kind: SectionViewKind, view: UIView?, at section: Int, of collectionView: UICollectionView) {
            self.kind = kind
            self.collectionView = collectionView
            self.view = view as? T
            self.section = section
        }
    }
    
    public init(_ config: ((CollectionSectionView) -> (Void))? = nil) {
        config?(self)
    }
    
    func disptach(_ event: CollectionSectionViewEventType, kind: SectionViewKind, view: UICollectionReusableView?, section: Int, collectionView: UICollectionView) -> Any? {
        switch event {
        case .dequeue:
            guard let handler = onEvent.dequeue else { return nil }
            handler(Context(kind: kind, view: view, at: section, of: collectionView))
        case .referenceSize:
            guard let handler = onEvent.referenceSize else { return nil }
            return handler(Context(kind: kind, view: view, at: section, of: collectionView))
        case .didDisplay:
            guard let handler = onEvent.didDisplay else { return nil }
            handler(Context(kind: kind, view: view, at: section, of: collectionView))
        case .endDisplay:
            guard let handler = onEvent.endDisplay else { return nil }
            handler(Context(kind: kind, view: view, at: section, of: collectionView))
        case .willDisplay:
            guard let handler = onEvent.willDisplay else { return nil }
            handler(Context(kind: kind, view: view, at: section, of: collectionView))
        }
        return nil
    }
}


/// MARK: - Events
extension CollectionSectionView {
    public struct Event<T> {
        public typealias EventContext = Context<T>
        
        public var dequeue: ((EventContext) -> Void)? = nil
        public var referenceSize: ((EventContext) -> CGSize)? = nil
        public var didDisplay: ((EventContext) -> Void)? = nil
        public var endDisplay: ((EventContext) -> Void)? = nil
        public var willDisplay: ((EventContext) -> Void)? = nil
        
    }
}
