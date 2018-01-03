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
    
    
    
    func setTitle(_ title: String?, for state: LARefreshState) {
        guard let stateTitle = title else { return }
        self.stateTitles.updateValue(stateTitle, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
}
