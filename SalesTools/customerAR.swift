//
//  custProd.swift
//  SalesTools
//
//  Created by Dave LaPorte on 1/27/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class customerAR: NSObject, ResponseJSONObjectSerializable
{
    var custnum: Double = 0.0
    var custName: String?
    
    // Cycle code.  The location where statements print
    // ANT = Antigo, ID = Idaho, WA = Washington
    var arArea: String?
    
    var unCashBal: Double = 0.0 // UnApplied cash.  Payment by cust, not applied yet.
    var current: Double = 0.0
    var pastDue30: Double = 0.0 // Past Due (30 +)
    var pastDue60: Double = 0.0 // Past Due (60 +)
    var pastDue90: Double = 0.0 // Past Due (90 +)
    var pastDue120: Double = 0.0 // Past Due (120 +)
    var servChgBal: Double = 0.0 // Service Charges (i.e. late chg/restocking chg)
    var futInvBal: Double = 0.0 // Future invoice bal.  Total invoiced (future orders)
    var codBal: Double = 0.0 // COD Balance.  Dollars owed COD
    var misccrBal: Double = 0.0 // Misc Credit. (for whatever reason)
    var arAmt: Double = 0.0  // Total amount owed with all charges.
    
        
    required init(json: JSON)
    {
        self.custnum = json["_custno"].double!
        self.custName = json["_custName"].string
        self.arArea = json["_cycleCD"].string
        self.unCashBal = json["_unCashBal"].double!
        self.current = json["_current"].double!
        self.pastDue30 = json["_pastDue1"].double!
        self.pastDue60 = json["_pastDue2"].double!
        self.pastDue90 = json["_pastDue3"].double!
        self.pastDue120 = json["_pastDue4"].double!
        self.servChgBal = json["_servChgBal"].double!
        self.futInvBal = json["_futInvBal"].double!
        self.codBal = json["_codBal"].double!
        self.misccrBal = json["_misccrBal"].double!
        self.arAmt = json["_arAmt"].double!
    }
    
    
    required override init() { }
    
    
}
