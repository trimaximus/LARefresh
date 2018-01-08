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

        self.myTableView.la_header = LARefreshNormalHeader(refreshTarget: self, refreshingAction: #selector(testRefresh))
        self.myTableView.la_footer = LARefreshBackFooter(refreshTarget: self, refreshingAction: #selector(testLoadMore))
    }

    @objc func testRefresh() {
        print("正在刷新")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            print("刷新停止")
            self.myTableView.la_header?.endRefreshing()
        }
    }
    
    @objc func testLoadMore() {
        print("加载更多")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            print("停止加载")
            self.myTableView.la_footer?.endRefreshing()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        }
        cell?.textLabel?.text = "\(indexPath.row + 1)"
        return cell!
    }
}

