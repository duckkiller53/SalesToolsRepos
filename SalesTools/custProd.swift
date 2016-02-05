//
//  custProd.swift
//  SalesTools
//
//  Created by Dave LaPorte on 1/27/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class custProd: NSObject, ResponseJSONObjectSerializable
{
    var prod: String?
    var descrip1: String?
    var descrip2: String?
    var qtyOnHand: Int = 0
    var qtyOnOrder: Int = 0
    var qtyCommit: Int = 0
    var qtyAvail: Int = 0
    var whse: String?
//    var lastINVDate: NSDate?
//    var lastRecvDate: NSDate?
    var lastINVDate: String = ""
    var lastRecvDate: String = ""
    
//    // have all custProd's share a single instance of a dateformatter to save processor time.
    static let sharedDateFormatter = custProd.dateFormatter()
    
    required init(json: JSON)
    {
        self.prod = json["Product"].string
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
    
    // This function returns a NSDateFromatter object that has
    // ben setup to work in a certain way.
    class func dateFormatter() -> NSDateFormatter {
        let aDateFormatter = NSDateFormatter()
        aDateFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ssZ"
        aDateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        aDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSTX")
        return aDateFormatter
    }


}