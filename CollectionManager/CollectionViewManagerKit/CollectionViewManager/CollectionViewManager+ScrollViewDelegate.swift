//
//  CollectionViewManager+ScrollViewDelegate.swift
//  CollectionManager
//
//  Created by David on 11/11/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

extension CollectionViewManager {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let handler = self.onScroll?.didZoom {
            handler(scrollView)
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let handler = self.onScroll?.viewForZooming {
            return handler(scrollView)
        }
        return nil
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if let handler = self.onScroll?.willBeginZooming {
            handler(scrollView,view)
        }
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let handler = self.onScroll?.endZooming {
            handler(scrollView,view,scale)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let handler = self.onScroll?.didScroll {
            handler(scrollView)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let handler = self.onScroll?.willBeginDragging {
            handler(scrollView)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let handler = self.onScroll?.willEndDragging {
            handler(scrollView, velocity, targetContentOffset)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let handler = self.onScroll?.endDragging {
            handler(scrollView, decelerate)
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let handler = self.onScroll?.shouldScrollToTop {
            return handler(scrollView)
        }
        return true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if let handler = self.onScroll?.didScrollToTop {
            handler(scrollView)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let handler = self.onScroll?.willBeginDecelerating {
            handler(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let handler = self.onScroll?.endDecelerating {
            handler(scrollView)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.onScroll?.endScrollingAnimation?(scrollView)
    }
    
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.onScroll?.didChangeAdjustedContentInset?(scrollView)
    }
}
