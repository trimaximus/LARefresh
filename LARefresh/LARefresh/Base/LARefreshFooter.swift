//
//  LARefreshFooter.swift
//  LARefresh
//
//  Created by Trimaximus on 14/12/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit

class LARefreshFooter: LARefreshComponent {
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
        self.la_height = LARefreshFooterHeight
    }
    
    func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {
            self.state = .noMoreData
        }
    }
    
    func resetNoMoreData() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
}
