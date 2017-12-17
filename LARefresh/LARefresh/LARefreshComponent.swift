//
//  LARefreshComponent.swift
//  LARefresh
//
//  Created by Trimaximus on 12/08/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

enum LARefreshState {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

class LARefreshComponent: UIView {
    /// 父视图
    var superScrollView: UIScrollView?
    /// 父视图初始contentInset
    var originalInset = UIEdgeInsets.zero
    /// 划动手势
    weak var panGestureRecognizer: UIPanGestureRecognizer?
    /// 正在刷新回调
    var refresingHandler: (() -> Void)?
    /// 开始刷新后回调
    var beginRefreshHandler: (() -> Void)?
    /// 回调对象
    weak var refreshTarget: AnyObject?
    /// 回调方法
    var refreshingAction: Selector?
    /// 是否正在刷新
    var isRefreshing: Bool {
        return self.state == .willRefresh || self.state == .refreshing
    }
    /// 当前状态（子类实现）
    var state = LARefreshState.idle {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    /// 拖拽百分比
    var pullingPercent: CGFloat = 0 {
        didSet {
            if self.isRefreshing { return }
            self.alpha = self.changeAlphaAutomatically ? self.pullingPercent : 1
        }
    }
    /// 是否根据拖拽自动切换百分比
    var changeAlphaAutomatically = false {
        didSet {
            if self.isRefreshing { return }
            self.alpha = self.changeAlphaAutomatically ? self.pullingPercent : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            self.state = .refreshing
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.placeSubviews()
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let scrollView = newSuperview as? UIScrollView else { return }
        self.removeObservers()
        self.la_x = 0
        self.la_width = scrollView.la_width
        self.superScrollView = scrollView
        self.superScrollView?.alwaysBounceVertical = true
        self.originalInset = scrollView.contentInset
        self.addObservers()
    }
    
    
    /// 子类调用回调方法
    func executeRefreshHandler() {
        DispatchQueue.main.async {
            self.refresingHandler?()
            if self.refreshTarget != nil && self.refreshingAction != nil && self.refreshTarget!.responds(to: self.refreshingAction!) {
                self.refreshTarget?.perform(self.refreshingAction!, with: nil, afterDelay: 0)
            }
            self.beginRefreshHandler?()
        }
    }
    
    
    /// 进入刷新状态
    ///
    /// - Parameter completionHandler: 刷新开始后回调
    func beginRefreshing(completionHandler: (() -> Swift.Void)? = nil) {
        completionHandler?()
        UIView.animate(withDuration: LARefreshAnimationDuration, animations: {
            self.alpha = 1
        })
        self.pullingPercent = 1
        if self.window != nil {
            self.state = .refreshing
        } else {
            if self.state != .refreshing {
                self.state = .willRefresh
                self.setNeedsDisplay()
            }
        }
    }
    
    /// 结束刷新状态
    ///
    /// - Parameter completionHandler: 刷新结束后回调
    func endRefreshing(completionHandler: (() -> Swift.Void)? = nil) {
        completionHandler?()
        self.state = .idle
    }
    
    /// 设置回调对象与回调方法
    ///
    /// - Parameters:
    ///   - target: 回调对象
    ///   - action: 回调方法
    func setRefreshTarget(target: AnyObject, refreshingAction action: Selector) {
        self.refreshTarget = target
        self.refreshingAction = action
    }
    
    // MARK: - KVO监听
    
    /// 添加观察者
    private func addObservers() {
        let options: NSKeyValueObservingOptions = [.old, .new]
        self.superScrollView?.addObserver(self, forKeyPath: LARefreshKeyPathContentOffset, options: options, context: nil)
        self.superScrollView?.addObserver(self, forKeyPath: LARefreshKeyPathContentSize, options: options, context: nil)
        self.panGestureRecognizer = self.superScrollView?.panGestureRecognizer
        self.panGestureRecognizer?.addObserver(self, forKeyPath: LARefreshKeyPathGestureRecognizerState, options: options, context: nil)
    }
    
    /// 移除观察者
    private func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: LARefreshKeyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: LARefreshKeyPathContentSize)
        self.panGestureRecognizer?.removeObserver(self, forKeyPath: LARefreshKeyPathGestureRecognizerState)
        self.panGestureRecognizer = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !self.isUserInteractionEnabled { return }
        if keyPath == LARefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change: change)
            return
        }
        
        if self.isHidden { return }
        if keyPath == LARefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change)
        } else if keyPath == LARefreshKeyPathGestureRecognizerState {
            self.scrollViewPanGestureRecognizerStateChange(change: change)
        }
    }
    
    /// 初始化
    func prepare() {
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = .flexibleWidth
    }
    
    // MARK: - 子类继承方法
    
    /// 设置子控件frame
    func placeSubviews() {}
    
    /// 父视图contentOffset发生改变时调用
    ///
    /// - Parameter change: contentOffset
    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey: Any]?) {}
    
    /// 父视图contentSize发生改变时调用
    ///
    /// - Parameter change: contentSize
    func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey: Any]?) {}
    
    /// 父视图划动手势状态发生改变时调用
    ///
    /// - Parameter change: panGestureRecognizer.state
    func scrollViewPanGestureRecognizerStateChange(change: [NSKeyValueChangeKey: Any]?) {}
    
}
