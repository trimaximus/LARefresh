//
//  LARefreshExtension.swift
//  LARefresh
//
//  Created by Trimaximus on 14/08/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit

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

extension UIScrollView {
    var la_inset_top: CGFloat {
        get {
            return self.contentInset.top
        }
        set {
            self.contentInset.top = newValue
        }
    }
    
    var la_inset_right: CGFloat {
        get {
            return self.contentInset.right
        }
        set {
            self.contentInset.right = newValue
        }
    }
    
    var la_inset_bottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.bottom = newValue
        }
    }
    
    var la_inset_left: CGFloat {
        get {
            return self.contentInset.left
        }
        set {
            self.contentInset.left = newValue
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
