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
            if let imagePath = currentBundle.path(forResource: "la_arrow", ofType: "png") {
                imageView.image = UIImage(contentsOfFile: imagePath)
            }
        }
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        [unowned self] in
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(indicatorView)
        return indicatorView
    }()
    
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle {
        get {
            return self.activityIndicatorView.activityIndicatorViewStyle
        }
        set {
            self.activityIndicatorView.activityIndicatorViewStyle = newValue
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
    }
}
