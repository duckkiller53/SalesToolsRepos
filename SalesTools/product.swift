//
//  custProd.swift
//  SalesTools
//
//  Created by Dave LaPorte on 1/27/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class product: NSObject, ResponseJSONObjectSerializable
{
    var prod: String?
    var descrip1: String?
    var descrip2: String?
    var qtyOnHand: Int = 0
    var qtyOnOrder: Int = 0
    var qtyCommit: Int = 0
    var qtyAvail: Int = 0
    var whse: String?
    var lastINVDate: String = ""
    var lastRecvDate: String = ""
      
    required init(json: JSON)
    {
        self.prod = json["ProdNum"].string
        self.descrip1 = json["Descrip1"].string
        self.descrip2 = json["Descrip2"].string
        self.qtyOnHand = json["QtyOnHand"].int!
        self.qtyOnOrder = json["QtyOnOrder"].int!
        self.qtyCommit = json["QtyCommit"].int!
        self.qtyAvail = json["QtyAvail"].int!
        self.whse = json["Whse"].string
        
        
        //let dateFormatter = custProd.sharedDateFormatter
        if let dateString = json["LastInvDate"].string
        {
            //self.lastINVDate = dateFormatter.dateFromString(dateString)
            self.lastINVDate = dateString.toStringDate()
        }
        if let dateString = json["LastRecvDate"].string
        {
            //self.lastRecvDate = dateFormatter.dateFromString(dateString)
            self.lastRecvDate = dateString.toStringDate()
        }
    }
    
    
    required override init() { }    
    
    
}
