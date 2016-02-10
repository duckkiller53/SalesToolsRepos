//
//  PersistenceManager.swift
//  grokSwiftREST
//
//  Created by Christina Moulton on 2015-12-03.
//  Copyright © 2015 Teak Mobile Inc. All rights reserved.
//

import Foundation

enum Path: String {
  case Credentials = "Credentials"
  case LoggedIn = "LoggedIn"
}

class PersistenceManager {
    
  class private func documentsDirectory() -> NSString
  {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                .UserDomainMask, true)
    let documentDirectory = paths[0] as String
    return documentDirectory
  }
    
  // saves an object of T ath path using our Enum 'Path'
  class func saveObject<T: NSCoding>(objectToSave: T, path: Path)
  {
    let file = documentsDirectory().stringByAppendingPathComponent(path.rawValue)
    NSKeyedArchiver.archiveRootObject(objectToSave, toFile: file)
  }
    
    
  // returns an Object of T
  class func loadObject<T: NSCoding>(path: Path) -> T?
  {
    let file = documentsDirectory().stringByAppendingPathComponent(path.rawValue)
    let result = NSKeyedUnarchiver.unarchiveObjectWithFile(file)
    return result as? T
  }
  
  // saves an array of T at path using our Enum 'Path'.
  class func saveArray<T: NSCoding>(arrayToSave: [T], path: Path)
  {
    let file = documentsDirectory().stringByAppendingPathComponent(path.rawValue)
    NSKeyedArchiver.archiveRootObject(arrayToSave, toFile: file)
  }
  
  // returns an array of T
  class func loadArray<T: NSCoding>(path: Path) -> [T]?
  {
    let file = documentsDirectory().stringByAppendingPathComponent(path.rawValue)
    let result = NSKeyedUnarchiver.unarchiveObjectWithFile(file)
    return result as? [T]
  }
}