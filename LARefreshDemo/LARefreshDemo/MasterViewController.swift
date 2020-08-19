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
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.la.header = LARefreshHeader({
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tableView.la.header?.endRefreshing()
            }
        })
        self.tableView.la.header?.height = 100
        self.tableView.la.footer = LARefreshBackFooter({
            
        })
    }

}

