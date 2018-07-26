//
//  Order.swift
//  info-fy
//
//  Created by Kareem Arab on 2018-07-15.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import SwiftyJSON

// Order object

class Order: NSObject {
    
    var json:     JSON
    var id:       Int
    var year:     String
    var province: String
    var email:    String
    //var price:    String
    
    init(json: JSON, id: Int = 0, year: String? = nil, province: String? = nil, email: String? = nil) {
        self.json = json
        self.id = id
        self.year = year!
        self.province = province!
        self.email = email!
        //self.price = price!
    }
    
    func getOrder() -> Void {
        
        print("-----------------------\n")
        print("ORDER ID: \(id)\n")
        print("ORDER YEAR: \(year)\n")
        print("ORDER PROVINCE: \(province)\n")
        print("-----------------------\n")
        
    }
    
}
