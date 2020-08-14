//
//  LARefreshHeaderView.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/14.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit

public class LARefreshHeaderView: LARefreshComponent {
    
    convenience init(_ refreshAction: LARefreshAction?) {
        self.init(frame: .zero)
        self.refreshAction = refreshAction
    }
    
    override func contentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    override func contentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
}
