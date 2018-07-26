//
//  FeedDataSource.swift
//  info-fy
//
//  Created by Kareem Arab on 2018-07-14.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class FeedDataSource: NSObject {
    
    // MARK: - Properties
    var provinceTableView: UITableView
    var yearTableView: UITableView
    var provinceOrders = [Order]()
    var yearOrders = [Order]()
    var theProvinces = [String]()
    var theAmounts = [Int]()
    
    // MARK: - Initializer
    init(provinceTableView: UITableView, yearTableView: UITableView) {
        self.provinceTableView = provinceTableView
        self.yearTableView = yearTableView
        super.init()
    }
    
    // MARK: - Method(s)
    /// Grabs shit from the Shopify API using the ShopifyService and feeds it into the table
    func doStuff(_ url: String, yearToDisplay: String?, ind: NVActivityIndicatorView, completion: @escaping ([Order]) -> Void) {
        ShopifyService.getAPIResponse(url, yearToDisplay: yearToDisplay, fromMainViewController: true, completion: { (provinceOrders, yearOrders) in
            ShopifyService.getProvKeysVals(provinceOrders, yearOrders: yearOrders, completion: { (provKeys, provVals) in
                self.provinceOrders = provinceOrders
                self.yearOrders = yearOrders
                self.theProvinces = provKeys
                self.theAmounts = provVals
                
                self.yearTableView.reloadData()
                self.provinceTableView.reloadData()
                ind.stopAnimating()
                
                completion(yearOrders)
            })
        })
    }
    
}

extension FeedDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == provinceTableView {
            if provinceOrders.count > 0 {
                // PROVINCE STUFF
                let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath) as? ProvinceCell ?? ProvinceCell()
                cell.provinceLabel.text = "\(theProvinces[indexPath.row]) "
                cell.amountLabel.text = "\(theAmounts[indexPath.row]) orders"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath) as? ProvinceCell ?? ProvinceCell()
                cell.provinceLabel.text = ""
                return cell
            }
        } else {
            // YEAR STUFF
            if yearOrders.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell", for: indexPath) as? YearCell ?? YearCell()
                cell.yearLabel.text = "Order \(yearOrders[indexPath.row].json["name"].string!)"
                cell.priceLabel.text = "\(yearOrders[indexPath.row].json["total_price"].string!) CAD"
                cell.emailLabel.text = "\(yearOrders[indexPath.row].email)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell", for: indexPath) as? YearCell ?? YearCell()
                cell.yearLabel.text = ""
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == provinceTableView {
            
            if provinceOrders.count > 0 {
                return theProvinces.count
            } else {
                return 0
            }
        } else {
            if yearOrders.count > 0 {
                return yearOrders.count
            } else {
                return 0
            }
        }
    }

}

