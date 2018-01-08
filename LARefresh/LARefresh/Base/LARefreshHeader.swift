//
//  LARefreshHeader.swift
//  LARefresh
//
//  Created by Trimaximus on 14/08/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit
/// 保存最后刷新时间
fileprivate let LARefreshSuiteName = "LARefresh"
fileprivate let kLatestRefreshTime = "LALatestRefreshTime"

class LARefreshHeader: LARefreshComponent {

    private static let userDefaults = UserDefaults(suiteName: LARefreshSuiteName)
    
    var latestUpdateTimeKey = kLatestRefreshTime
    var latestRefreshTime: Date {
        get {
            guard let value = LARefreshHeader.userDefaults?.object(forKey: self.latestUpdateTimeKey) as? Date else { return Date.distantPast }
            return value
        }
        set {
            LARefreshHeader.userDefaults?.set(newValue, forKey: self.latestUpdateTimeKey)
        }
    }
    
    /// contentInset顶部差值
    var insetTopDelta: CGFloat = 0
    /// 忽略的contentInset顶部差值
    var ignoredScrollViewContentInsetTop: CGFloat = 0
    
    override var state: LARefreshState {
        get {
            return super.state
        }
        set {
            let oldValue = super.state
            if newValue == oldValue { return }
            super.state = newValue
            if newValue == .idle {
                if oldValue != .refreshing { return }
                LARefreshHeader.userDefaults?.set(Date(), forKey: kLatestRefreshTime)
                LARefreshHeader.userDefaults?.synchronize()
                UIView.animate(withDuration: LARefreshAnimationDuration.slow.rawValue, animations: {
                    self.superScrollView?.la_inset_top += self.insetTopDelta
                    if self.changeAlphaAutomatically {
                        self.alpha = 0
                    }
                }, completion: { (_) in
                    self.pullingPercent = 0
                })
            } else if newValue == .refreshing {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: LARefreshAnimationDuration.fast.rawValue, animations: { 
                        let top = self.originalInset.top + self.la_height
                        self.superScrollView?.la_inset_top = top
                        self.superScrollView?.contentOffset.y = -top
                    }, completion: { (_) in
                        self.executeRefreshHandler()
                    })
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(refreshTarget: AnyObject, refreshingAction: Selector) {
        self.init(frame: CGRect.zero)
        self.setRefreshTarget(target: refreshTarget, refreshingAction: refreshingAction)
    }
    
    override func prepare() {
        super.prepare()
        self.la_height = LARefreshHeaderHeight
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.la_y = -self.la_height - self.ignoredScrollViewContentInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        guard let scrollView = self.superScrollView else { return }
        if self.state == .refreshing {
            // 正在刷新
            if self.window == nil { return }
            var insetTop = -scrollView.la_offset_y > self.originalInset.top ? -scrollView.la_offset_y : self.originalInset.top
            insetTop = insetTop > self.la_height + self.originalInset.top ? self.la_height + self.originalInset.top : insetTop
            scrollView.la_inset_top = insetTop
            self.insetTopDelta = self.originalInset.top - insetTop
            return
        }
        // 控制器转场时，contentInset可能发生变化
        self.originalInset = scrollView.contentInset
        let offsetY = scrollView.la_offset_y
        let happenOffsetY = -self.originalInset.top
        // 向上划动，头部刷新控件被隐藏
        if offsetY > happenOffsetY { return }
        // 即将刷新临界值
        let thresholdY = happenOffsetY - self.la_height
        let pullingPercent = (happenOffsetY - offsetY) / self.la_height
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .idle && offsetY < thresholdY {
                self.state = .pulling
            } else if self.state == .pulling && offsetY >= thresholdY {
                self.state = .idle
            }
        } else {
            if self.state == .pulling {
                self.beginRefreshing()
            } else {
                if pullingPercent < 1 {
                    self.pullingPercent = pullingPercent
                }
            }
        }
    }
}
