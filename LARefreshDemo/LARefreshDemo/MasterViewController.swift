//
//  MasterViewController.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/14.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.tableView.la.header = LARefreshHeaderView({
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tableView.la.header?.endRefreshing()
            }
        })
    }

}

