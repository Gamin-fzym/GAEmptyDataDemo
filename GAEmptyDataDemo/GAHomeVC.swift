//
//  GAHomeVC.swift
//  GAEmptyDataDemo
//
//  Created by MaciOS on 2021/10/22.
//

import Foundation
import UIKit
import MJRefresh

class GAHomeVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    var listArr: [[String: String]] = []
    var page: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        anewReloadData()
    }
    
    func setupUI() {
        tableView.separatorStyle = .none
        adjustsScrollViewInsetNever(scrollView: tableView)
        setupScrollReload()
    }

    override func anewReloadData() {
        super.anewReloadData()
        page = 1
        requestListData()
    }
    
    func setupScrollReload() {
        let mjheader = MJRefreshNormalHeader { [weak self] in
            self?.anewReloadData()
        }
        mjheader.stateLabel?.textColor = .black
        mjheader.lastUpdatedTimeLabel?.isHidden = true
        tableView.mj_header = mjheader
        anewReloadData()
        let footer = MJRefreshAutoNormalFooter { [weak self] in
            self?.page += 1
            self?.requestListData()
        }
        footer.isHidden = true
        footer.setTitle("暂无更多数据", for: .noMoreData)
        footer.stateLabel?.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        tableView.mj_footer = footer
    }
    
    @IBAction func tapEmptyAction(_ sender: Any) {
        tableView.mj_footer?.isHidden = true
        listArr.removeAll()
        page = -1
        requestListData()
    }
    
}

extension GAHomeVC {
    
    func requestListData() {
        if page == 1 {
            listArr.removeAll()
        }
        let data = moniData()
        listArr += data
        
        endRefreshing()
        if data.count < 20 {
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            tableView.mj_footer?.resetNoMoreData()
        }
        if listArr.count < 20 {
            tableView.mj_footer?.isHidden = true
        } else {
            tableView.mj_footer?.isHidden = false
        }
        tableView.reloadData()
        setupEmptyData(scrollView: tableView, reload: true, image: UIImage(named: "icon_qs_data.png"), space: -70)
    }
    
    func endRefreshing() {
        if let header = tableView.mj_header , header.isRefreshing {
            header.endRefreshing()
        }
        if let footer = tableView.mj_footer , footer.isRefreshing {
            footer.endRefreshing()
        }
    }
    
    func moniData() -> [[String: String]] {
        if !NetstatManager.shared.isNetworkConnect() {
            return []
        }
        var listCount = 0
        if page == 1 {
            listCount = 20
        } else if page == 2 {
            listCount = 10
        } else {
            return []
        }
        var tempArr: [[String: String]] = []
        for index in ((page-1)*20)..<((page-1)*20+listCount) {
            let obj = ["title": "title\(index)", "id": "\(index)"]
            tempArr.append(obj)
        }
        return tempArr
    }
    
}

extension GAHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        cell.selectionStyle = .none
        if listArr.count > indexPath.row {
            let obj = listArr[indexPath.row]
            cell.textLabel?.text = obj["title"]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
}
