//
//  LARefreshBackFooter.swift
//  LARefresh
//
//  Created by Trimaximus on 17/12/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit

class LARefreshBackFooter: LARefreshFooter {
    private var latestRefreshDataCount = 0
    private var latestBottomDelta: CGFloat = 0
    private var contentBreakViewHeight: CGFloat {
        guard let currentSuperView = self.superScrollView else { return 0 }
        let height = currentSuperView.la_height - self.originalInset.bottom - self.originalInset.top
        return currentSuperView.la_content_height - height
    }
    private var appearanceOffsetY: CGFloat {
        return self.contentBreakViewHeight > 0 ? self.contentBreakViewHeight - self.originalInset.top : -self.originalInset.top
    }
    
    override var state: LARefreshState {
        get {
            return super.state
        }
        set {
            let currentState = self.state
            if currentState == newValue {
                return
            }
            super.state = newValue
            guard let currentSuperView = self.superScrollView else { return }
            if newValue == .noMoreData || newValue == .idle {
                if currentState == .refreshing {
                    // 刷新完毕
                    UIView.animate(withDuration: LARefreshAnimationDuration, animations: {
                        currentSuperView.la_inset_bottom -= self.latestBottomDelta
                        if self.changeAlphaAutomatically {
                            self.alpha = 0
                        }
                    }, completion: { (finished) in
                        self.pullingPercent = 0
                    })
                }
                let deltaHeight = self.contentBreakViewHeight
                if deltaHeight > 0 && currentState == .refreshing && currentSuperView.la_totalDataCount != self.latestRefreshDataCount {
                    
                }
            } else if newValue == .refreshing {
                // 开始刷新
                self.latestRefreshDataCount = currentSuperView.la_totalDataCount
                UIView.animate(withDuration: LARefreshAnimationDuration, animations: {
                    var bottom = self.la_height + self.originalInset.bottom
                    let deltaHeight = self.contentBreakViewHeight
                    if deltaHeight < 0 {
                        bottom -= deltaHeight
                    }
                    self.latestBottomDelta  = bottom - currentSuperView.la_inset_bottom
                    currentSuperView.la_inset_bottom = bottom
                    currentSuperView.la_offset_y = self.la_height + self.appearanceOffsetY
                }, completion: { (finished) in
                    self.executeRefreshHandler()
                })
            }
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scrollViewContentSizeDidChange(change: nil)
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if self.state == .refreshing {
            return
        }
        guard let currentSuperView = self.superScrollView else { return }
        self.originalInset = currentSuperView.la_inset
        let currentOffsetY = currentSuperView.la_offset_y
        let appearanceOffsetY = self.appearanceOffsetY
        if currentOffsetY <= appearanceOffsetY {
            return
        }
        let pullingPercent = (currentOffsetY - appearanceOffsetY) / self.la_height
        if self.state == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        if currentSuperView.isDragging {
            self.pullingPercent = pullingPercent
            let idleToPullingOffsetY = appearanceOffsetY + self.la_height
            if self.state == .idle && currentOffsetY > idleToPullingOffsetY {
                self.state = .pulling;
            } else if self.state == .pulling && currentOffsetY <= idleToPullingOffsetY {
                self.state = .idle;
            }
        } else if self.state == .pulling {
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
        guard let currentSuperView = self.superScrollView else { return }
        let superViewHeight = currentSuperView.la_height - self.originalInset.top - self.originalInset.bottom
        self.la_y = max(currentSuperView.la_content_height, superViewHeight)
    }
}
