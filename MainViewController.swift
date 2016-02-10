//
//  OurViewController.swift
//  SideBarMenuExample
//
//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var menubutton: UIBarButtonItem!
    
    
    @IBAction func btnPhone(sender: AnyObject) {
        let phonenum = "17156274826"
        DialNumber(phonenum)
    }
    
    
    @IBAction func btnLogout(sender: AnyObject) {
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if  self.revealViewController() != nil
        {
            
            menubutton.target = self.revealViewController()
            menubutton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    
    }
    
    func DialNumber(phonenumber:String)
    {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phonenumber)")
        {
            let application:UIApplication = UIApplication.sharedApplication()
            
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }

    
}
