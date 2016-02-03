//  Utilities.swift
//  Copyright (c) 2010-2015 Bill Weinman. All rights reserved.

import UIKit

let RSSDefaultTint = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 0.8)

#if DEBUG
let _RSSdebug = true
#else
let _RSSdebug = false
#endif

extension String {
    
    public func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    // remove XML/HTML tags from a string
    public func flattenHTML() -> String {
        let scanner = NSScanner(string: self)
        var text: NSString?     // NSScanner won't scan into a Swift String with Swift 1.2
        var outstr: String = self
        while !scanner.atEnd {
            scanner.scanUpToString("<", intoString: nil)
            scanner.scanUpToString(">", intoString: &text)
            if text != nil {
                outstr = self.stringByReplacingOccurrencesOfString(String(format: "%@>", text!), withString: " ")
            }
        }
        return outstr
    }
}

extension String
{
    func toStringDate() -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.dateFromString(self)!
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateStringFormatted = dateFormatter.stringFromDate(date)

        // Return formatted string
        return dateStringFormatted
    }
}

extension String {
    func StringToDate() -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        
        //Return Parsed Date
        return dateFromString
    }
}

// MARK: utilities

func activityIndicator(state : Bool) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = state
}

// UIDdevice orientation introduced in iOS 8.0
// UIDeviceOrientationIsLandscape introduced in iOS 8.3

// ****Status bar is the top bar with the battery indicator ****

// Note: To make this work you must set a flag in the
// Info.plist file.  The flag is called
//(View controller-based status bar appearance")  The normal
// state of this = yes which means our code can't controll this
// and the view controller handles it.  Thus we must set it to
// NO for this func to work.
func setStatusBarHidden(hidden: Bool) {
    var state = hidden
    let orientation = UIDevice.currentDevice().orientation
    let idiom = UIDevice.currentDevice().userInterfaceIdiom
    
    // keep status bar hidden for non-ipad in landscape
    if idiom != UIUserInterfaceIdiom.Pad && UIDeviceOrientationIsLandscape(orientation) {
        state = true
    }
    
    UIApplication.sharedApplication().setStatusBarHidden(state, withAnimation: UIStatusBarAnimation.Slide)
}

// MARK: date functions

func dateToLocalizedString(date: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "EEEE, MMMM d, hh:mm a"
    return dateFormatter.stringFromDate(date)
}



func SQLDateToDate(_sqldate: String) -> NSDate {
    let sqldate = _sqldate ?? ""
    if sqldate.characters.count < 1 {
        return NSDate()
    }
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"    // SQL format
    return dateFormatter.dateFromString(sqldate) ?? NSDate()
}

func stringToSQLDate(sdate: String) -> String {
    // NSLog("%@ \(sdate)", __FUNCTION__)
    let dateFormatter = NSDateFormatter()
    dateFormatter.lenient = false
    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    let dateFormats = [
        "EEE, dd MMM yyyy HHmmss zzz",  // no colons, see below
        "EEE, MMM dd, yyyy hhmm a",
        "EEE, MMM dd, yyyy hhmmss a",
        "dd MMM yyyy HHmmss zzz",
        "yyyy-MM-dd'T'HHmmss'Z'",
        "yyyy-MM-dd'T'HHmmssZ",
        "EEE MMM dd HHmm zzz yyyy",
        "EEE MMM dd HHmmss zzz yyyy"
    ]
    
    // NSDateFormatter's limited implementation of unicode date formating is missing support
    // for colons in timezone offsets so we just take all the colons out of the string
    // it's more flexible like this anyway
    let sdate = sdate.stringByReplacingOccurrencesOfString(":", withString: "")
    
    var date = NSDate()
    for format in dateFormats {
        dateFormatter.dateFormat = format
        if let _date = dateFormatter.dateFromString(sdate) {
            date = _date
            break
        }
    }
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.stringFromDate(date)
}

