//
//  BackGroundGradients.swift
//  SalesTools
//
//  Created by William Volm on 2/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit


// Create a tableview background gradient.
func setTableViewBackgroundGradient(sender: UITableView, _ topColor:UIColor, _ bottomColor:UIColor) {
    
    let gradientBackgroundColors = [topColor.CGColor, bottomColor.CGColor]
    let gradientLocations = [0.0,1.0]
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientBackgroundColors
    gradientLayer.locations = gradientLocations
    
    gradientLayer.frame = sender.bounds
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
