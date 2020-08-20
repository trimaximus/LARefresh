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
}

public struct LAAnimation {
    struct KeyPath {
        static let bounds = "bounds"
    }
    
    struct Key {
        static let identifier = "identifier"
    }
    
    struct Value {
        static let headerRefreshingBounds = "headerRefreshingBounds"
        static let footerRefreshingBounds = "footerRefreshingBounds"
    }
}

public class LARefreshComponent: UIView {
    
    var scrollView: UIScrollView?
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
        didSet {
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
    
    convenience init(_ refreshAction: LARefreshAction?) {
        self.init(frame: .zero)
        self.refreshAction = refreshAction
    }
    
    func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .lightGray
        self.frame.size.height = self.height
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
        self.scrollView?.addObserver(self, forKeyPath: LARefreshKeyPath.contentOffset, options: options, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: LARefreshKeyPath.contentSize, options: options, context: nil)
    }
    
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: LARefreshKeyPath.contentOffset)
        self.superview?.removeObserver(self, forKeyPath: LARefreshKeyPath.contentSize)
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
        default:
            break
        }
    }
    
}

// MARK: Actions
public extension LARefreshComponent {
    
    func beginRefreshing() {
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
    }
    
    func endRefreshing() {
        self.state = .idle
    }
    
}
