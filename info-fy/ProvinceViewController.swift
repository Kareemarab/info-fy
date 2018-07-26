//
//  provinceViewController.swift
//  info-fy
//
//  Created by Kareem Arab on 2018-07-16.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class ProvinceViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Properties
    var provinceOrders : Order?
    var provinceDataSource: ProvinceDataSource?
    var url = "https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    var ind = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2.0) - 50, y: (UIScreen.main.bounds.size.height / 2.0) - 50, width: 100, height: 100), type: .ballPulseSync, color: UIColor.shopifyPurple())
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimations()
        setupFeedDataSource()
        load()
    }
    
    // MARK: - Methods
    func startAnimations() {
        self.view.addSubview(ind)
        ind.startAnimating()
    }
    
    // Sets up the ProvinceDataSource
    func setupFeedDataSource() {
        provinceDataSource = ProvinceDataSource(tableView: tableView)
        tableView.dataSource = provinceDataSource
    }
    
    // Loads data from DataSource
    func load() {
        provinceDataSource?.doStuff(url, ind: ind)
    }
    
    // Removes status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
