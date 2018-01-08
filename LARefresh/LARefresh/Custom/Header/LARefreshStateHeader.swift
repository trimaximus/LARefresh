//
//  LARefreshStateHeader.swift
//  LARefresh
//
//  Created by Trimaximus on 02/01/18.
//  Copyright © 2018年 LiteAtom. All rights reserved.
//

import UIKit

class LARefreshStateHeader: LARefreshHeader {
    
    lazy var stateLabel: UILabel = {
        [unowned self] in
        let label = UILabel.initializeLARefreshLabel()
        self.addSubview(label)
        return label
    }()
    lazy var latestUpdateTimeLabel: UILabel = {
        [unowned self] in
        let label = UILabel.initializeLARefreshLabel()
        self.addSubview(label)
        return label
    }()
    
    lazy var stateTitles = Dictionary<LARefreshState, String>()
    var labelLeftInset = LARefreshLabelLeftInset
    
    override var state: LARefreshState {
        get {
            return super.state
        }
        set {
            let oldValue = super.state
            if newValue == oldValue { return }
            super.state = newValue
            self.stateLabel.text = self.stateTitles[newValue]
        }
    }
    override var latestUpdateTimeKey: String {
        get {
            return super.latestUpdateTimeKey
        }
        set {
            super.latestUpdateTimeKey = newValue
            if self.latestUpdateTimeLabel.isHidden {
                return
            }
        }
    }
    
    
    override func prepare() {
        super.prepare()
        self.setTitle(LARefreshHeaderIdleText, for: .idle)
        self.setTitle(LARefreshHeaderPullingText, for: .pulling)
        self.setTitle(LARefreshHeaderRefreshingText, for: .refreshing)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if self.stateLabel.isHidden {
            return
        }
        let stateLabelHasNoConstraints = self.stateLabel.constraints.count == 0
        if self.latestUpdateTimeLabel.isHidden {
            if stateLabelHasNoConstraints {
                self.stateLabel.frame = self.bounds
            }
        } else {
            let stateLabelHeight = self.la_height * 0.5
            if stateLabelHasNoConstraints {
                self.stateLabel.frame = CGRect(x: 0, y: 0, width: self.la_width, height: stateLabelHeight)
            }
            if self.latestUpdateTimeLabel.constraints.count == 0 {
                self.latestUpdateTimeLabel.frame = CGRect(x: 0, y: stateLabelHeight, width: self.la_width, height: self.la_height - stateLabelHeight)
            }
        }
    }
    
    func setTitle(_ title: String?, for state: LARefreshState) {
        guard let stateTitle = title else { return }
        self.stateTitles.updateValue(stateTitle, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
}
