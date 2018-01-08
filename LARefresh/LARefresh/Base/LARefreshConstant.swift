//
//  LARefreshConstant.swift
//  LARefresh
//
//  Created by Trimaximus on 14/08/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit

let LARefreshHeaderHeight: CGFloat = 54
let LARefreshFooterHeight: CGFloat = 44
let LARefreshAnimationDuration: TimeInterval = 0.3

/// KVO
let LARefreshKeyPathContentOffset = "contentOffset"
let LARefreshKeyPathContentSize = "contentSize"
let LARefreshKeyPathGestureRecognizerState = "state"

let LARefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)
let LARefreshLabelTextColor = UIColor(red: 90.0 / 255.0, green: 90.0 / 255.0, blue: 90.0 / 255.0, alpha: 1)
let LARefreshLabelLeftInset: CGFloat = 25

let LARefreshHeaderIdleText = "下拉可以刷新"
let LARefreshHeaderPullingText = "松开立即刷新"
let LARefreshHeaderRefreshingText = "正在刷新数据中..."

