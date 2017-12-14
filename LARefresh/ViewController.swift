//
//  ViewController.swift
//  LARefresh
//
//  Created by Trimaximus on 12/08/17.
//  Copyright © 2017年 LiteAtom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.myTableView.la_header = LARefreshHeader(refreshTarget: self, refreshingAction: #selector(testRefresh))
    }

    @objc func testRefresh() {
        print("正在刷新")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.myTableView.la_header?.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

