//
//  custProd.swift
//  SalesTools
//
//  Created by Dave LaPorte on 1/27/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class customer: NSObject, ResponseJSONObjectSerializable
{
    var custnum: Double = 0.0
    var custName: String?
    var address: String?
    var city: String?
    var state: String?
    var zip: String?
    var county: String?
    var phone: String?
    var outSlsRep: String?
    var contact: String?
    
        
    required init(json: JSON)
    {
        self.custnum = json["_custNum"].double!
        self.custName = json["_custName"].string
        self.address = json["_address"].string
        self.city = json["_city"].string
        self.state = json["_state"].string
        self.zip = json["_zip"].string
        self.county = json["_county"].string
        self.phone = json["_phone"].string
        self.outSlsRep = json["_outSideSlsRep"].string
        self.contact = json["_contact"].string
    }
    
    
    required override init() { }
    
    
}
