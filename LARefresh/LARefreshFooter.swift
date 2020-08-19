//
//  LARefreshFooter.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/14.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit

public class LARefreshFooter: LARefreshComponent {
    
    internal var latestDataCount = 0
    
    internal var originY: CGFloat {
        guard let currentScrollView = self.scrollView else { return CGFloat.signalingNaN }
        let frameHeight = currentScrollView.frame.height
        let contentHeight = currentScrollView.contentSize.height
        return max(frameHeight, contentHeight)
    }
    
    func adjustOriginY() {
        self.frame.origin.y = self.originY
    }
    
    func reset() {
        self.state = .idle
    }
    
    func endRefreshing(noMoreData: Bool = false) {
        if noMoreData {
            self.state = .noMoreData
        } else {
            super.endRefreshing()
        }
    }
}
