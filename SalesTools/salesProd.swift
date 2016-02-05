//
//  SalesProd.swift
//  SalesTools
//
//  Created by Dave LaPorte on 1/27/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class salesProd: NSObject, ResponseJSONObjectSerializable
{
    var ordNum: Int = 0
    var custNum: Int = 0
    var custName: String = ""
    var qtySold: Int = 0
    var price: Double = 0.0
    var cost: Double = 0.0
    var dateSold: String = ""
    
    //    // have all custProd's share a single instance of a dateformatter to save processor time.
    static let sharedDateFormatter = custProd.dateFormatter()
    
    required init(json: JSON)
    {
        self.ordNum = json["OrderNumber"].int!
        self.custNum = json["CustomerNumber"].int!
        self.custName = json["CustomerName"].string!
        self.qtySold = json["QtySold"].int!
        self.price = json["SellPrice"].double!
        self.cost = json["Cost"].double!
        
        
        //let dateFormatter = custProd.sharedDateFormatter
        if let dateString = json["DateSold"].string
        {
            //self.lastINVDate = dateFormatter.dateFromString(dateString)
            self.dateSold = dateString.toStringDate()
        }
    }
    
    required override init() { }
    
}