//
//  LARefreshExtension.swift
//  LARefresh
//
//  Created by Trimaximus on 14/08/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

extension UIView {
    var la_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var la_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var la_width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var la_height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
}

fileprivate var LARefreshHeaderKey: Character = "\0"
fileprivate var LARefreshFooterKey: Character = "\0"
fileprivate var LARefreshReloadDataClosureKey: Character = "\0"
@objc extension UIScrollView {
    
    /// 刷新Header
    var la_header: LARefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &LARefreshHeaderKey) as? LARefreshHeader
        }
        set {
            if self.la_header != newValue {
                self.la_header?.removeFromSuperview()
                if let newHeader = newValue {
                    self.insertSubview(newHeader, at: 0)
                }
                self.willChangeValue(forKey: "la_header")
                objc_setAssociatedObject(self, &LARefreshHeaderKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValue(forKey: "la_header")
            }
        }
    }
    
    /// 加载Footer
    var la_footer: LARefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &LARefreshFooterKey) as? LARefreshFooter
        }
        set {
            if self.la_footer != newValue {
                self.la_footer?.removeFromSuperview()
                if let newFooter = newValue {
                    self.insertSubview(newFooter, at: 0)
                }
                self.willChangeValue(forKey: "la_footer")
                objc_setAssociatedObject(self, &LARefreshFooterKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValue(forKey: "la_footer")
            }
        }
    }
    
    var la_reloadDataClosure: ((_ totalDataCount: Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &LARefreshReloadDataClosureKey) as? ((Int) -> Void)
        }
        set {
            self.willChangeValue(forKey: "la_reloadDataClosure")
            objc_setAssociatedObject(self, &LARefreshReloadDataClosureKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.didChangeValue(forKey: "la_reloadDataClosure")
        }
    }
    
    var la_totalDataCount: Int {
        get {
            var totalDataCount = 0;
            if self.isKind(of: UITableView.classForCoder()) {
                let tableView = self as! UITableView
                for section in 0..<tableView.numberOfSections {
                    totalDataCount += tableView.numberOfRows(inSection: section)
                }
            } else if self.isKind(of: UICollectionView.classForCoder()) {
                let collectionView = self as! UICollectionView
                for section in 0..<collectionView.numberOfSections {
                    totalDataCount += collectionView.numberOfItems(inSection: section)
                }
            }
            
            return totalDataCount;
        }
    }
    
    var la_inset: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            }
            return self.contentInset
        }
    }
    
    var la_inset_top: CGFloat {
        get {
            return self.la_inset.top
        }
        set {
            var inset = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
    }
    
    var la_inset_right: CGFloat {
        get {
            return self.la_inset.right
        }
        set {
            var inset = self.contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            self.contentInset = inset
        }
    }
    
    var la_inset_bottom: CGFloat {
        get {
            return self.la_inset.bottom
        }
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
    }
    
    var la_inset_left: CGFloat {
        get {
            return self.la_inset.left
        }
        set {
            var inset = self.contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            self.contentInset = inset
        }
    }
    
    var la_offset_x: CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            self.contentOffset.x = newValue
        }
    }
    
    var la_offset_y: CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            self.contentOffset.y = newValue
        }
    }
    
    var la_content_size: CGSize {
        get {
            return self.contentSize
        }
        set {
            self.contentSize = newValue
        }
    }
    
    var la_content_width: CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            self.contentSize.width = newValue
        }
    }
    
    var la_content_height: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            self.contentSize.height = newValue
        }
    }
}

extension UILabel {
    /// 创建文字显示Label
    class func initializeLARefreshLabel() -> UILabel {
        let refreshLabel = UILabel()
        refreshLabel.font = LARefreshLabelFont
        refreshLabel.textColor = LARefreshLabelTextColor
        refreshLabel.textAlignment = .center
        refreshLabel.autoresizingMask = .flexibleWidth
        refreshLabel.backgroundColor = UIColor.clear
        return refreshLabel
    }
    
    var la_text_width: CGFloat {
        var textWidth: CGFloat = 0
        if let currentText = self.text as NSString? {
            textWidth = currentText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesFontLeading, attributes: [.font : self.font], context:nil).width
        }
        return textWidth
    }
    
}

extension Bundle {
    
    /// 获取LARefresh资源文件所在bundle
    ///
    /// - Returns: LARefresh资源文件所在bundle
    class func LARefreshResourceBundle() -> Bundle? {
        let refreshBundle = Bundle(for: LARefreshComponent.classForCoder())
        guard let resourceBundlePath = refreshBundle.path(forResource: "LARefresh", ofType: "bundle") else { return nil }
        return Bundle(path: resourceBundlePath)
    }
}
