//
//  LARefreshAutoFooter.swift
//  LARefresh
//
//  Created by Trimaximus on 17/12/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit

class LARefreshAutoFooter: LARefreshFooter {
    var isAutomaticallyRefresh = true
    var triggerAutomaticallyRefreshPercent: CGFloat = 1
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            if self.isHidden == newValue {
                return
            }
            super.isHidden = newValue
            if newValue {
                // 隐藏
                self.state = .idle
                self.superScrollView?.la_inset_bottom -= self.la_height
            } else {
                // 显示
                self.superScrollView?.la_inset_bottom += self.la_height
                if let currentSuperView = self.superScrollView {
                    self.la_y = currentSuperView.la_content_height
                }
            }
        }
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
            if newValue == .refreshing {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.executeRefreshHandler()
                })
            }
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            if !self.isHidden {
                self.superScrollView?.la_inset_bottom += self.la_height
            }
            if let currentSuperView = self.superScrollView {
                self.la_y = currentSuperView.la_content_height
            }
        } else {
            if !self.isHidden {
                self.superScrollView?.la_inset_bottom -= self.la_height
            }
        }
    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
        if let currentSuperView = self.superScrollView {
            self.la_y = currentSuperView.la_content_height
        }
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if self.state != .idle || !self.isAutomaticallyRefresh || self.la_y == 0 {
            return
        }
        
        if let currentSuperView = self.superScrollView {
            if currentSuperView.la_inset_top + currentSuperView.la_content_height > currentSuperView.la_height {
                // 内容视图超出scrollView大小
                if currentSuperView.la_offset_y >= currentSuperView.la_content_height - currentSuperView.la_height + self.la_height * self.triggerAutomaticallyRefreshPercent + currentSuperView.la_inset_bottom - self.la_height {
                    guard let oldOffset = change?[.oldKey] as? CGPoint, let newOffset = change?[.newKey] as? CGPoint else { return }
                    if newOffset.y <= oldOffset.y { return }
                    self.beginRefreshing()
                }
            }
        }
    }
    
    override func scrollViewPanGestureRecognizerStateChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanGestureRecognizerStateChange(change: change)
        if self.state != .idle {
            return
        }
        if let currentSuperView = self.superScrollView {
            if currentSuperView.panGestureRecognizer.state == .ended {
                // 停止拖动
                if currentSuperView.la_inset_top + currentSuperView.la_content_height <= currentSuperView.la_height {
                    // 内容视图高度小于scrollView高度
                    if currentSuperView.la_offset_y >= -currentSuperView.la_inset_top {
                        // 向上拖拽
                        self.beginRefreshing()
                    }
                } else {
                    // 内容视图高度超出scrollView高度
                    if currentSuperView.la_offset_y >= currentSuperView.la_inset_bottom + currentSuperView.la_content_height - currentSuperView.la_height {
                        self.beginRefreshing()
                    }
                }
            }
        }
    }
}
