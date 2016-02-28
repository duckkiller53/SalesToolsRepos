//  Utilities.swift

import UIKit

let DefaultTint = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
let rowsFoundTint = UIColor.redColor()  //colorWithHexString("#FF713C")

#if DEBUG
let _debug = true
#else
let _debug = false
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

func FormatPhone(phone: String) -> String
{
    let stringts: NSMutableString = NSMutableString(string: phone)
    stringts.insertString("(", atIndex: 0)
    stringts.insertString(")", atIndex: 4)
    stringts.insertString("-", atIndex: 5)
    stringts.insertString("-", atIndex: 9)
    
    return String(stringts)
    
}

func colorWithHexString (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}



