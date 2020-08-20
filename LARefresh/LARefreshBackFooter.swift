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
        if self.state == .refreshing { return }
        guard let currentScrollView = self.scrollView, let offsetY = (change?[.newKey] as? NSValue)?.cgPointValue.y else { return }
        debugPrint(currentScrollView.bounds)
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
        let fromBounds = currentScrollView.bounds
        var toBounds = currentScrollView.bounds
        toBounds.origin.y = space
        let boundsAnimation = CABasicAnimation(keyPath: LAAnimation.KeyPath.bounds)
        boundsAnimation.isRemovedOnCompletion = false
        boundsAnimation.fillMode = .both
        boundsAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        boundsAnimation.duration = 0.25
        boundsAnimation.fromValue = NSValue(cgRect: fromBounds)
        boundsAnimation.toValue = NSValue(cgRect: toBounds)
        boundsAnimation.setValue(LAAnimation.Value.footerRefreshingBounds, forKey: LAAnimation.Key.identifier)
        boundsAnimation.delegate = self
        currentScrollView.layer.add(boundsAnimation, forKey: LAAnimation.Value.footerRefreshingBounds)
    }

}

extension LARefreshBackFooter: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let identifier = anim.value(forKey: LAAnimation.Key.identifier) as? String else { return }
        if identifier == LAAnimation.Value.footerRefreshingBounds {
            
        }
    }
}
