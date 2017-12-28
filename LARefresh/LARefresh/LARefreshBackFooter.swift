//
//  LARefreshBackFooter.swift
//  LARefresh
//
//  Created by Trimaximus on 17/12/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit

class LARefreshBackFooter: LARefreshFooter {
    private var latestRefreshDataCount = 0
    private var latestBottomDelta: CGFloat = 0
    private var contentBreakViewHeight: CGFloat {
        guard let currentSuperView = self.superScrollView else { return 0 }
        let height = currentSuperView.la_height - self.originalInset.bottom - self.originalInset.top
        return currentSuperView.la_content_height - height
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scrollViewContentSizeDidChange(change: nil)
    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
    }
    
}
