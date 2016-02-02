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
    var _prod: String?
    var _descrip1: String?
    var _descrip2: String?
    var _qtyOnHand: Double?
    var _qtyOnOrder: Double?
    var _qtyCommit: Double?
    var _qtyAvail: Double?
    var _whse: String?
    var _lastINVDate: NSDate?
    var _lastRecvDate: NSDate?
    
//    // have all custProd's share a single instance of a dateformatter to save processor time.
    static let sharedDateFormatter = custProd.dateFormatter()
    
    required init(json: JSON)
    {
        self._prod = json["Product"].string
        self._descrip1 = json["Descrip1"].string
        self._descrip2 = json["Descrip2"].string
        self._qtyOnHand = json["QtyOnHand"].double
        self._qtyOnOrder = json["QtyOnOrder"].double
        self._qtyCommit = json["QtyCommit"].double
        self._qtyAvail = json["QtyAvail"].double
        self._whse = json["Whse"].string       
    

        let dateFormatter = custProd.sharedDateFormatter
        if let dateString = json["LastInvDate"].string
        {
            self._lastINVDate = dateFormatter.dateFromString(dateString)
        }
        if let dateString = json["LastRecvDate"].string
        {
            self._lastRecvDate = dateFormatter.dateFromString(dateString)
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