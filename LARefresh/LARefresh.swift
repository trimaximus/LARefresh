//
//  LARefresh.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/14.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit

fileprivate var REFRESH_HEADER_KEY = "LA_REFRESH_HEADER"
fileprivate var REFRESH_FOOTER_KEY = "LA_REFRESH_FOOTER"

public extension LA where Base: UIView {
    
    var header: LARefreshHeaderView? {
        get {
            return objc_getAssociatedObject(self.base, &REFRESH_FOOTER_KEY) as? LARefreshHeaderView
        }
        set {
            objc_setAssociatedObject(self.base, &REFRESH_HEADER_KEY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var footer: LARefreshFooterView? {
        get {
            return objc_getAssociatedObject(self.base, &REFRESH_FOOTER_KEY) as? LARefreshFooterView
        }
        set {
            objc_setAssociatedObject(self.base, &REFRESH_FOOTER_KEY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
