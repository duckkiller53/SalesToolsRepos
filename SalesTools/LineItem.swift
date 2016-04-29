//
//  LineItem.swift
//  SalesTools
//
//  Created by Dave LaPorte on 4/20/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class LineItem: NSObject, ResponseJSONObjectSerializable
{
    var lineNum: Int = 0
    var custNum: Double = 0.0
    var orderNum: Int = 0
    var orderDate: String = ""
    var prod: String = ""
    var qty: Int = 0
    var descrip: String = ""
    var whse: String = ""
    var unit: String = ""
    var cost: Double = 0.0
    var sell: Double = 0.0
    
    required init(json: JSON)
    {
        self.lineNum = json["LineNo"].int!
        self.custNum = json["CustNum"].double!
        self.orderNum = json["OrderNum"].int!
        
        if let dateString = json["OrderDate"].string
        {
            self.orderDate = dateString.toStringDate()
        }
        
        self.prod = json["Product"].string!
        self.qty = json["Quantity"].int!
        self.descrip = json["Description"].string!
        self.whse = json["Warehouse"].string!
        self.unit = json["Unit"].string!
        self.cost = json["Cost"].double!
        self.sell = json["Sell"].double!
    }
    
    required override init() { }    
    
}
