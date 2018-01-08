//
//  LARefreshNormalHeader.swift
//  LARefresh
//
//  Created by Trimaximus on 02/01/18.
//  Copyright © 2018年 LiteAtom. All rights reserved.
//

import UIKit

class LARefreshNormalHeader: LARefreshStateHeader {
    lazy var arrowImageView: UIImageView = {
        [unowned self] in
        let imageView = UIImageView()
        if let currentBundle = Bundle.LARefreshResourceBundle() {
            if let imagePath = currentBundle.path(forResource: "la_arrow@2x", ofType: "png") {
                imageView.image = UIImage(contentsOfFile: imagePath)
            }
        }
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        [unowned self] in
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        self.addSubview(indicatorView)
        return indicatorView
    }()
    
    override var state: LARefreshState {
        get {
            return super.state
        }
        set {
            let oldValue = super.state
            if newValue == oldValue { return }
            super.state = newValue
            if state == .idle {
                if oldValue == .refreshing {
                    self.arrowImageView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: LARefreshAnimationDuration, animations: {
                        self.activityIndicatorView.alpha = 0
                    }, completion: { (finished) in
                        if self.state != .idle {
                            return
                        }
                        self.activityIndicatorView.alpha = 1
                        self.activityIndicatorView.stopAnimating()
                        self.activityIndicatorView.isHidden = false
                    })
                } else {
                    self.activityIndicatorView.stopAnimating()
                    self.arrowImageView.isHidden = false
                    UIView.animate(withDuration: LARefreshAnimationDuration, animations: {
                        self.arrowImageView.transform = CGAffineTransform.identity
                    })
                }
            } else if state == .pulling {
                self.activityIndicatorView.stopAnimating()
                self.arrowImageView.isHidden = false
                UIView.animate(withDuration: LARefreshAnimationDuration, animations: {
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
                })
            } else if state == .refreshing {
                self.activityIndicatorView.startAnimating()
                self.activityIndicatorView.alpha = 1
                self.arrowImageView.isHidden = true
            }
        }
    }
    
    
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle {
        get {
            return self.activityIndicatorView.activityIndicatorViewStyle
        }
        set {
            self.activityIndicatorView.activityIndicatorViewStyle = newValue
            self.setNeedsLayout()
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        var arrowCenterX = self.la_width * 0.5
        if !self.stateLabel.isHidden {
            let stateTextWidth = self.stateLabel.la_text_width
            var timeTextWidth: CGFloat = 0
            if !self.latestUpdateTimeLabel.isHidden {
                timeTextWidth = self.latestUpdateTimeLabel.la_text_width
            }
            let textWidth = max(stateTextWidth, timeTextWidth)
            arrowCenterX -= textWidth / 2 + self.labelLeftInset
        }
        let arrowCenter = CGPoint(x: arrowCenterX, y: self.la_height * 0.5)
        if self.arrowImageView.constraints.count == 0 {
            self.arrowImageView.frame.size = self.arrowImageView.image?.size ?? CGSize.zero
            self.arrowImageView.center = arrowCenter
        }
        if self.activityIndicatorView.constraints.count == 0 {
            self.activityIndicatorView.center = arrowCenter
        }
        self.activityIndicatorView.tintColor = self.stateLabel.textColor
    }
}
