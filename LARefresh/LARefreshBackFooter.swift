//
//  LARefreshBackFooter.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/18.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit

class LARefreshBackFooter: LARefreshFooter {
    
    override var state: LARefreshStatus {
        get {
            return super.state
        }
        set {
            if self.state == newValue { return }
            let oldValue = self.state
            super.state = newValue
            switch newValue {
            case .idle, .noMoreData:
                if oldValue == .refreshing {
                    
                }
            
            case .refreshing:
                self.footerBeginRefreshing()
            default:
                break
            }
        }
    }

    override func contentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.contentOffsetDidChange(change)
        debugPrint(self.scrollView?.contentSize)
        if self.state == .refreshing { return }
        guard let currentScrollView = self.scrollView, let offsetY = (change?[.newKey] as? NSValue)?.cgPointValue.y else { return }
        self.originInset = currentScrollView.contentInset
        let threshold = self.originY - currentScrollView.frame.height
        if offsetY < threshold { return }
        let pullingPercent = (offsetY - threshold) / self.frame.height
        self.pullingPercent = max(0, min(pullingPercent, 1))
        if self.state == .noMoreData { return }
        if currentScrollView.isDragging {
            let critical = threshold + self.frame.height
            if self.state == .idle && offsetY > critical {
                self.state = .pulling
            } else if self.state == .pulling && offsetY <= critical {
                self.state = .idle
            }
        } else {
            if self.state == .pulling {
                self.beginRefreshing()
            }
        }
    }
    
    override func contentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.contentSizeDidChange(change)
        self.adjustOriginY()
        self.backgroundColor = .cyan
    }
    
    internal func footerBeginRefreshing() {
        guard let currentScrollView = self.scrollView else { return }
        self.latestDataCount = currentScrollView.numberOfDatas
        let space = self.frame.height + self.originInset.bottom
        UIView.animate(withDuration: LA_ANIMATION_DURATION, animations: {
            
        }, completion: { finished in
            self.refreshAction?()
        })
    }

}
