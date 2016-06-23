//
//  appUser.swift
//  SalesTools
//

//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation


class appUser: NSObject, NSCoding
{
    var username: String?
    var password: String?
    var adminpass: String?
    var success: String?
    
    required override init() { }
    
    
    required init(username: String, password: String, adminpass: String)
    {
        self.username = username
        self.password = password
        self.adminpass = adminpass
    }
    
    // Required to impliment protocol NSObject
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.password, forKey: "password")
        aCoder.encodeObject(self.adminpass, forKey: "adminpass")
    }
    
    // Required to impliment protocol NSObject
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.username = aDecoder.decodeObjectForKey("username") as? String
        self.password = aDecoder.decodeObjectForKey("password") as? String
        self.adminpass = aDecoder.decodeObjectForKey("adminpass") as? String
    }
    
    
}