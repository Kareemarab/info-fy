//
//  ShopifyAPIGrab.swift
//  info-fy
//
//  Created by Kareem Arab on 2018-07-20.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

typealias GETResponseCompletion = ([Order], [Order]) -> Void
typealias GETProvKeysValsCompletion = ([String], [Int]) -> Void
typealias GETProvOrdersKeysValsCompletion = ([[Order]], [String], [Int]) -> Void

/// Grabs stuff from the Shopify API and checks for faults and runs some logic based on the challenge requirments.

class ShopifyService {
    
    /// Retrieves all data
    static func getAPIResponse(_ url: String, yearToDisplay: String?, fromMainViewController: Bool, completion: @escaping GETResponseCompletion) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            
            var provinceOrders = [Order]()
            var yearOrders = [Order]()
            
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
                    for i in 0...(json["orders"].count - 1) {
                        // stuff disapepars cuz of the gaurd
                        var order_province: String?
                        var order_email: String?
                        var order_price: String?
                        var order_name: String?
                        
                        guard let order_id: Int    = json["orders"][i]["id"].int else { continue }
                        let order_json: JSON       = json["orders"][i]
                        let order_year: String     = String(describing: json["orders"][i]["created_at"].string!.prefix(4))
                        
                        order_email = json["orders"][i]["email"].string!
                        order_province = json["orders"][i]["shipping_address"]["province"].string
                        order_price = json["orders"][i]["shipping_address"]["total_price"].string
                        order_name = json["orders"][i]["shipping_address"]["province"].string
                        

                        if order_email == "" {
                            order_email = "No email"
                        }
                        
                        if fromMainViewController == false {
                            if order_province != nil {
                                let order = Order(json: order_json, id: order_id, year: order_year, province: order_province, email: order_email)
                                provinceOrders.append(order)
                            }
                        } else {
                            if order_province != nil {
                                let order = Order(json: order_json, id: order_id, year: order_year, province: order_province, email: order_email)
                                provinceOrders.append(order)
                                if order.year == yearToDisplay && yearOrders.count < 10 {
                                    yearOrders.append(order)
                                }
                            } else {
                                order_province = "none"
                                let order = Order(json: order_json, id: order_id, year: order_year, province: order_province, email: order_email)
                                // Checks if the same year as specified and displays only first 10
                                if order.year == yearToDisplay && yearOrders.count < 10 {
                                    yearOrders.append(order)
                                }
                            }
                        }
 
                    }
                    completion(provinceOrders, yearOrders)
                }
            case .failure(let error):
                print(error)
            }
        
        }
       
    }
    
    // For the ViewController Province and Years values
    static func getProvKeysVals(_ provinceOrders: [Order], yearOrders: [Order], completion: @escaping GETProvKeysValsCompletion) {
        
        var provinceOrdersStrings = [String]()
        var provOccDict: [String: Int] = [:]
        var provKeys = [String]()
        var provVals = [Int]()
        var yearOrdersStrings = [String]()
        var yearOccDict: [String: Int] = [:]
        
        for j in 0...provinceOrders.count - 1 {
            provinceOrdersStrings.append(provinceOrders[j].province)
        }
        for k in 0...yearOrders.count - 1 {
            yearOrdersStrings.append(yearOrders[k].year)
        }
        provinceOrdersStrings.forEach {
            provOccDict[$0, default: 0] += 1
        }
        yearOrdersStrings.forEach {
            yearOccDict[$0, default: 0] += 1
        }
        for (key, value) in provOccDict{
            provKeys.append(key)
            provVals.append(value)
        }
        
        completion(provKeys, provVals)
    }
    
    // For the ProvinceViewController Province values
    static func getProvOrdersKeysVals(_ provinceOrders: [Order], yearOrders: [Order], completion: @escaping GETProvOrdersKeysValsCompletion) {
    
        var provinceOrdersStrings = [String]()
        var provOccDict: [String: Int] = [:]
        var provKeys = [String]()
        var provVals = [Int]()
        var theOrders = [[Order]]()
        
        for j in 0...provinceOrders.count - 1 {
            provinceOrdersStrings.append(provinceOrders[j].province)
        }
        provinceOrdersStrings = provinceOrdersStrings.sorted(by: <)
        provinceOrdersStrings.forEach {
            provOccDict[$0, default: 0] += 1
        }
    
        for (key, value) in provOccDict{
            provKeys.append(key)
            provVals.append(value)
        }
        provKeys = provKeys.sorted(by: <)
    
        var tempArr = [Order]()
        for w in 0...provKeys.count - 1 {
            tempArr.removeAll()
            for r in 0...provinceOrders.count - 1 {
                if provinceOrders[r].province == provKeys[w] {
                    tempArr.append(provinceOrders[r])
                }
            }
            theOrders.append(tempArr)
        }
        
        completion(theOrders, provKeys, provVals)
    
    }
    
}
