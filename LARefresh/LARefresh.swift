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
    
    var header: LARefreshHeader? {
        get {
            return objc_getAssociatedObject(self.base, &REFRESH_HEADER_KEY) as? LARefreshHeader
        }
        set {
            if let newHeader = newValue, !(self.header?.isEqual(newHeader) ?? false) {
                self.header?.removeFromSuperview()
                self.base.insertSubview(newHeader, at: 0)
            }
            objc_setAssociatedObject(self.base, &REFRESH_HEADER_KEY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var footer: LARefreshFooter? {
        get {
            return objc_getAssociatedObject(self.base, &REFRESH_FOOTER_KEY) as? LARefreshFooter
        }
        set {
            if let newFooter = newValue, !(self.footer?.isEqual(newFooter) ?? false) {
                self.footer?.removeFromSuperview()
                self.base.insertSubview(newFooter, at: 0)
            }
            objc_setAssociatedObject(self.base, &REFRESH_FOOTER_KEY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension UIScrollView {
    
    var numberOfDatas: Int {
        var count = 0
        if let tableView = self as? UITableView {
            for section in 0 ..< tableView.numberOfSections {
                count += tableView.numberOfRows(inSection: section)
            }
        } else if let collectionView = self as? UICollectionView {
            for section in 0 ..< collectionView.numberOfSections {
                count += collectionView.numberOfItems(inSection: section)
            }
        }
        return count
    }
    
}
