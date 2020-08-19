//
//  LARefreshHeader.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/14.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit

public class LARefreshHeader: LARefreshComponent {
    
    override var state: LARefreshStatus {
        get {
            return super.state
        }
        set {
            if newValue == self.state { return }
            let oldValue = self.state
            super.state = newValue
            switch newValue {
            case .idle:
                if oldValue != .refreshing { return }
                self.headerEndRefreshing()
            case .refreshing:
                self.headerBeginRefreshing()
            default:
                break
            }
        }
    }

    var refreshTopDelta: CGFloat = 0
    
    override var height: CGFloat {
        get {
            return super.height
        }
        set {
            super.height = newValue
            self.frame.origin.y = -newValue
        }
    }
    
    override func prepare() {
        super.prepare()
        self.frame.origin.y = -self.frame.height
    }
    
    override func contentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.contentOffsetDidChange(change)
        if self.state == .refreshing {
            self.adjustInset()
            return
        }
        self.originInset = self.scrollView?.contentInset ?? .zero
        guard let currentScrollView = self.scrollView, let offsetY = (change?[.newKey] as? NSValue)?.cgPointValue.y else { return }
        let threshold = -self.originInset.top
        if offsetY > threshold {
            return
        }
        let critical = threshold - self.frame.height
        let pullingPercent = (threshold - offsetY) / self.frame.height
        self.pullingPercent = max(0, min(pullingPercent, 1))
        if currentScrollView.isDragging {
            if self.state == .idle && offsetY < critical {
                self.state = .pulling
            } else if self.state == .pulling && offsetY >=  critical {
                self.state = .idle
            }
        } else {
            if self.state == .pulling {
                self.beginRefreshing()
            }
        }
    }
    
    func adjustInset() {
        guard let currentScrollView = self.scrollView else { return }
        var insetTop = -currentScrollView.contentOffset.y > self.originInset.top ? -currentScrollView.contentOffset.y : self.originInset.top
        insetTop = min(insetTop, self.frame.height + self.originInset.top)
        self.refreshTopDelta = self.originInset.top - insetTop
        if currentScrollView.contentInset.top != insetTop {
            currentScrollView.contentInset.top = insetTop
        }
    }
    
    internal func headerBeginRefreshing() {
        guard let currentScrollView = self.scrollView, currentScrollView.panGestureRecognizer.state != .cancelled else { return }
        let space = self.frame.height + self.originInset.top
        var inset = currentScrollView.contentInset
        inset.top = space
        UIView.animate(withDuration: LA_ANIMATION_DURATION, animations: {
            currentScrollView.contentInset = inset
            currentScrollView.contentOffset.y = -space
            debugPrint(currentScrollView.contentInset)
        }, completion: { _ in
            self.refreshAction?()
        })
    }
    
    internal func headerEndRefreshing() {
        UIView.animate(withDuration: LA_ANIMATION_DURATION, animations: {
            self.scrollView?.contentInset.top += self.refreshTopDelta
            if self.automaticallyAdjustsAlpha {
                self.alpha = 0
            }
        }, completion: { _ in
            self.pullingPercent = 0
        })
    }
    
    
    
}
