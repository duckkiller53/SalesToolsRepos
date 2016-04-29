//
//  ARBalance.swift
//  SalesTools
//
//  Created by Dave LaPorte on 1/27/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class ARBalance: NSObject, ResponseJSONObjectSerializable
{
    var custnum: Double = 0.0
    var custName: String?
    var arTotBal: Double = 0.0
    var current: Double = 0.0
    var arOver: Double = 0.0
    var invoices: [Invoice] = [Invoice]()
    
    required init(json: JSON)
    {
        self.custnum = json["CustNum"].double!
        self.custName = json["CustName"].string
        self.arTotBal = json["ARTotBal"].double!
        self.current = json["Current"].double!
        self.arOver = json["AROver"].double!
        self.invoices = json["Invoices"].arrayValue.map { Invoice(json: $0) }
    }
    
    required override init() { }
}
