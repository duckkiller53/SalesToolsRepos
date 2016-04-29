//
//  Invoice.swift
//  SalesTools
//
//  Created by Dave LaPorte on 4/20/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class Invoice: NSObject, ResponseJSONObjectSerializable
{
    var invoiceNum: Double = 0.0
    var dueDate: String = ""
    var arOver: Double = 0.0
    var arAmount: Double = 0.0
    var amtDue: Double = 0.0
    var lineItems: [LineItem] = [LineItem]()
    
    required init(json: JSON)
    {
        self.invoiceNum = json["InvoiceNum"].double!
        
        if let dateString = json["DueDate"].string
        {
            self.dueDate = dateString.toStringDate()
        }
        
        self.arOver = json["AROver"].double!
        self.arAmount = json["ARAmount"].double!
        self.amtDue = json["AmtDue"].double!
        self.lineItems = json["LineItems"].arrayValue.map { LineItem(json: $0) }
    }
    
    required override init() { }    
    
}
