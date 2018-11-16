//
//  ConfigurableItem.swift
//  CollectionManager
//
//  Created by David on 07/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

internal struct InternalCollectionViewModelLinkContext {
    var model: DiffableModel?
    var models: [DiffableModel]?
    
    var indexPath: IndexPath?
    var indexPaths: [IndexPath]?
    
    var cell: CellProtocol?
    
    var container: Any
    
    var parameter1: Any?
    var parameter2: Any?
    var parameter3: Any?
    var parameter4: Any?
    var parameter5: Any?
    
    init(model: DiffableModel? = nil, indexPath: IndexPath, cell: CellProtocol? = nil, scrollview: UIScrollView,
         parameter1: Any? = nil, parameter2: Any? = nil, parameter3: Any? = nil, parameter4: Any? = nil, parameter5: Any? = nil) {
        self.model = model
        self.indexPath = indexPath
        self.cell = cell
        self.container = scrollview
        self.parameter1 = parameter1
        self.parameter2 = parameter2
    }
    
    init(models: [DiffableModel],  indexPaths: [IndexPath], scrollview: UIScrollView) {
        self.models = models
        self.indexPaths = indexPaths
        self.container = scrollview
    }
}


//MARK:- Cell & Linker Related

public protocol ViewModelLinkerProtocol {
    var modelType: Any.Type { get }
    var cellType: Any.Type { get }
    var cellReuseIdentifier: String { get }
    var cellClass: AnyClass { get }
}

public protocol CollectionViewModelLinkerProtocol: ViewModelLinkerProtocol, Equatable {}

internal protocol CollectionViewModelLinkerProtocolFunctions {
    @discardableResult
    func dispatch(event: CollectionViewModelLinkerEventType, context: InternalCollectionViewModelLinkContext) -> Any?
    func getCell(from collection: UICollectionView, at indexPath: IndexPath?) -> UICollectionViewCell
}

internal enum CollectionViewModelLinkerEventType: Int {
    case dequeue
    case shouldSelect
    case shouldDeselect
    case didSelect
    case didDeselect
    case didHighlight
    case didUnhighlight
    case shouldHighlight
    case willDisplay
    case endDisplay
    case shouldShowEditMenu
    case canPerformEditAction
    case performEditAction
    case canFocus
    case itemSize

    // Prefetching
    case prefetch
    case cancelPrefetch
    case shouldSpringLoad
}

public protocol CellProtocol: class {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell: CellProtocol { }

public extension CellProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

/// MARK: - Section Related

public protocol GeneralCollectionReusableViewProtocol {
    var viewClass: AnyClass { get }
    var reuseIdentifier: String { get }
}

public protocol CollectionSectionProtocol : GeneralCollectionReusableViewProtocol {
    var section: CollectionSection? { get set }
}

public enum SectionViewKind {
    case header
    case footer
}

internal protocol CollectionHeaderFooterProtocolFunctions {
    @discardableResult
    func disptach(_ event: CollectionSectionViewEventType, kind: SectionViewKind, view: UICollectionReusableView?, section: Int, collectionView: UICollectionView) -> Any? 
}


public protocol HeaderFooterProtocol: class {
    static var reuseIdentifier: String { get }
}

extension UICollectionReusableView: HeaderFooterProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

internal enum CollectionSectionViewEventType: Int {
    case dequeue
    case referenceSize
    case didDisplay
    case endDisplay
    case willDisplay
}

/// MARK: UIScrollViewDelegate Events
public struct ScrollViewEvents {
    public var didScroll: ((UIScrollView) -> Void)? = nil
    public var willBeginDragging: ((UIScrollView) -> Void)? = nil
    public var willEndDragging: ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetOffset: UnsafeMutablePointer<CGPoint>) -> Void)? = nil
    public var endDragging: ((_ scrollView: UIScrollView, _ willDecelerate: Bool) -> Void)? = nil
    public var shouldScrollToTop: ((UIScrollView) -> Bool)? = nil
    public var didScrollToTop: ((UIScrollView) -> Void)? = nil
    public var willBeginDecelerating: ((UIScrollView) -> Void)? = nil
    public var endDecelerating: ((UIScrollView) -> Void)? = nil
    public var viewForZooming: ((UIScrollView) -> UIView?)? = nil
    public var willBeginZooming: ((_ scrollView: UIScrollView, _ view: UIView?) -> Void)? = nil
    public var endZooming: ((_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> Void)? = nil
    public var didZoom: ((UIScrollView) -> Void)? = nil
    public var endScrollingAnimation: ((UIScrollView) -> Void)? = nil
    public var didChangeAdjustedContentInset: ((UIScrollView) -> Void)? = nil
}
