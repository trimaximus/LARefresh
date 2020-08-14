//
//  LARefreshComponent.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/14.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit
import WebKit

public typealias LARefreshAction = (() -> Void)

public enum LARefreshStatus {
    case idle
    case pulling
    case willRefresh
    case refreshing
    case noMoreData
}

public struct LARefreshKeyPath {
    static let contentInset = "contentInset"
    static let contentOffset = "contentOffset"
    static let contentSize = "contentSize"
    static let panGestureRecognizerState = "state"
}

public class LARefreshComponent: UIView {
    
    weak var scrollView: UIScrollView?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originInset = UIEdgeInsets.zero
    
    var automaticallyAdjustsAlpha = false
    var isRefreshing: Bool {
        return self.state == .refreshing || self.state == .willRefresh
    }
    
    var state = LARefreshStatus.idle {
        didSet {
            if self.state == oldValue { return }
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    var pullingPercent: CGFloat = 0 {
        didSet {
            if self.state == .refreshing { return }
            if self.automaticallyAdjustsAlpha {
                self.alpha = self.pullingPercent
            }
        }
    }
    
    var height: CGFloat = 54 {
        willSet {
            self.frame.size.height = self.height
        }
    }
    
    
    var refreshAction: LARefreshAction?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    
    func subviewsLayout() {}
    
    public override func layoutSubviews() {
        self.subviewsLayout()
        super.layoutSubviews()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let superScrollView = newSuperview as? UIScrollView else { return }
        self.removeObservers()
        superScrollView.alwaysBounceVertical = true
        self.scrollView = superScrollView
        self.frame.size.width = superScrollView.frame.width
        var inset = UIEdgeInsets.zero
        if #available(iOS 11, *) {
            inset = superScrollView.adjustedContentInset
        } else {
            inset = superScrollView.contentInset
        }
        self.frame.origin.x = inset.left
        self.originInset = inset
        self.addObservers()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            self.state = .refreshing
        }
    }
    
    
       func contentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
       func contentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
       func panGestureRecognizerStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {}
    
}

// MARK: KVO
public extension LARefreshComponent {

    func addObservers() {
        let options: NSKeyValueObservingOptions = [.old, .new]
        self.superview?.addObserver(self, forKeyPath: LARefreshKeyPath.contentOffset, options: options, context: nil)
        self.superview?.addObserver(self, forKeyPath: LARefreshKeyPath.contentSize, options: options, context: nil)
        self.panGestureRecognizer = self.scrollView?.panGestureRecognizer
        self.panGestureRecognizer?.addObserver(self, forKeyPath: LARefreshKeyPath.panGestureRecognizerState, options: options, context: nil)
    }
    
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: LARefreshKeyPath.contentOffset)
        self.superview?.removeObserver(self, forKeyPath: LARefreshKeyPath.contentSize)
        self.panGestureRecognizer?.removeObserver(self, forKeyPath: LARefreshKeyPath.panGestureRecognizerState)
        self.panGestureRecognizer = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard self.isUserInteractionEnabled else { return }
        if keyPath == LARefreshKeyPath.contentSize {
            self.contentSizeDidChange(change)
        }
        
        if self.isHidden { return }
        switch keyPath {
        case LARefreshKeyPath.contentOffset:
            self.contentOffsetDidChange(change)
        case LARefreshKeyPath.panGestureRecognizerState:
            self.panGestureRecognizerStateDidChange(change)
        default:
            break
        }
    }
    
}

// MARK: Actions
public extension LARefreshComponent {
    
    func beginRefreshing(completionAction: LARefreshAction) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        self.pullingPercent = 1
        if let _ = self.window {
            self.state = .refreshing
        } else {
            if self.state != .refreshing {
                self.state = .willRefresh
                self.setNeedsDisplay()
            }
        }
        self.refreshAction?()
    }
    
}
