//
//  ProvinceDataSource.swift
//  info-fy
//
//  Created by Kareem Arab on 2018-07-17.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ProvinceDataSource: NSObject {
    
    // MARK: - Properties
    var tableView: UITableView
    var provinceOrders = [Order]()
    var theProvinces = [String]()
    var theAmounts = [Int]()
    var theOrders = [[Order]]()
    
    // MARK: - Initializer
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    // MARK: - Method(s)
    /// Grabs nicely packaged data from the ShopifyService and feeds it into the table
    func doStuff(_ url: String, ind: NVActivityIndicatorView) {
        ShopifyService.getAPIResponse(url, yearToDisplay: nil, fromMainViewController: false) { (provinceOrders, yearOrders) in
            ShopifyService.getProvOrdersKeysVals(provinceOrders, yearOrders: yearOrders, completion: { (theOrders, provKeys, provVals) in
                self.provinceOrders = provinceOrders
                self.theProvinces = provKeys
                self.theAmounts = provVals
                self.theOrders = theOrders
                
                self.tableView.reloadData()
                ind.stopAnimating()
            })
        }
    }
    
}

extension ProvinceDataSource: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath) as? ProvinceCell ?? ProvinceCell()
        let text = "Order: \(self.theOrders[indexPath.section][indexPath.row].json["name"].string!)"
        cell.provinceLabel!.text = text
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.theProvinces.count > 0 {
            return self.theProvinces.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.theOrders.count > 0 {
            return self.theOrders[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.theProvinces.count > 0 {
            return self.theProvinces[section]
        }
        return ""
    }
    
}
