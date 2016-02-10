//
//  LogOut.swift
//  SalesTools
//
//  Created by William Volm on 1/26/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class LogIn: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        var name: String?
        var pass: String?
        let path:Path
        

        
        if let username = txtUserName.text
        {
            if username.isEmpty
            {
                // show alert
                return
            } else {
                name = username
            }
            
        }

        
        if let password = txtPassword.text
        {
            if password.isEmpty
            {
                // show alert
                return
            } else {
                pass = password
            }
        }
        
        path = Path.Credentials
        let Person = appUser(username: name!, password: pass!)        
        PersistenceManager.saveObject(Person, path: path)
        
        
        if let test:appUser = PersistenceManager.loadObject(path) {
            print(test.username! + " " + test.password!)
        } else {
            print("Fail")
        }

        
        
        
        let myAlert = UIAlertController(title:"Alert", message:"Login is successful. Thank you!", preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion:nil);
        }
    
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated:true, completion:nil);
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  self.revealViewController() != nil
        {            
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
