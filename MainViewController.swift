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
        let Person = appUser(username: "", password: "")
        PersistenceManager.saveObject(Person, path: .Credentials)

        ShowAlert("Logout Successful!")
    }
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
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
   
    
    func ShowAlert(msg: String)
    {
        let myAlert = UIAlertController(title:"Alert", message: msg, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion:nil);
        }
        
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated:true, completion:nil);
        
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
