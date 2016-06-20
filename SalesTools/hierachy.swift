//
//  Invoice.swift
//  SalesTools
//
//  Created by Dave LaPorte on 6/9/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation
import SwiftyJSON

class hierachy: NSObject, ResponseJSONObjectSerializable
{
    var value1: String = ""
    var value2: String = ""
    
    required init(json: JSON)
    {
        self.value1 = json["Value1"].string!
        self.value2 = json["Value2"].string!
    }
    
    required override init() { }
    
}
