//
//  BackGroundGradients.swift
//  SalesTools
//
//  Created by William Volm on 2/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

// Create a tableview background gradient.
func setTableViewBackgroundGradient(sender: UITableView, _ topColor:UIColor, _ bottomColor:UIColor) {
    
    let gradientBackgroundColors = [topColor.CGColor, bottomColor.CGColor]
    let gradientLocations = [0.0,1.0]
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientBackgroundColors
    gradientLayer.locations = gradientLocations
    
    // I add to the with and height of the current window for
    // the 6s Plus
    
    //let modelName = UIDevice.currentDevice().modelName
    
    
    var rect = CGRect()
    rect.size.width = sender.bounds.width + 100
    rect.size.height = sender.bounds.height + 200
    gradientLayer.frame = rect
    //gradientLayer.frame = sender.bounds
    
    
    let backgroundView = UIView(frame: sender.bounds)
    backgroundView.layer.insertSublayer(gradientLayer, atIndex: 0)
    sender.backgroundView = backgroundView
}

// Create gradient view for UiView
func CreateGradient(topColor:UIColor, bottomColor:UIColor) -> CAGradientLayer
    {
        let top = topColor
        let bottom = bottomColor
        
        let gradientColors: [CGColor] = [top.CGColor, bottom.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
}

func colorizeNavBar(bar: UINavigationBar)
{
    // Set the color of all navigation bars in app.
    bar.barTintColor = colorWithHexString("#175c99")
    // Set the color of the buttons in the nav bar.
    bar.tintColor = UIColor.whiteColor()
    // Set the color of any titles in nav bar.
    bar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
}
