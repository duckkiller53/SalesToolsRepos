//
//  LogOut.swift
//  SalesTools
//
//  Created by William Volm on 1/26/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner


class LogIn: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var notConnectedBanner: Banner?
    var loginResult: String?

    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        var name: String?
        var pass: String?

        
        if let username = txtUserName.text
        {
            if username.isEmpty
            {
                ShowAlert("Please enter a username!")
                return
            } else {
                name = username
            }
            
        }

        
        if let password = txtPassword.text
        {
            if password.isEmpty
            {
                ShowAlert("Please enter a password!")
                return
            } else {
                pass = password
            }
        }
        
        
        
        
        let Person = appUser(username: name!, password: pass!)        
        PersistenceManager.saveObject(Person, path: .Credentials)
        
        TestCredentials()
        
        // read credentials
//        if let test:appUser = PersistenceManager.loadObject(path) {
//            print(test.username! + " " + test.password!)
//        } else {
//            print("Fail")
//        }
        
    }
    
    func TestCredentials()
    {
        
        let completionHandler: (Result<String, NSError>) -> Void =
        { (result) in
            
            self.ActivityIndicator.hidden = true
            self.ActivityIndicator.stopAnimating()
            
            // Test if error is unauthorized or no connection
            guard result.error == nil else
            {
                print(result.error)
                
                if let error = result.error
                {
                    if error.domain == NSURLErrorDomain
                    {
                        // If we already are showing a banner, dismiss it and create new
                        if let existingBanner = self.notConnectedBanner
                        {
                            existingBanner.dismiss()
                        }
                        
                        if error.code == NSURLErrorUserAuthenticationRequired
                        {
                            self.notConnectedBanner = Banner(title: "Login Failed",
                                subtitle: "Please login and try again",
                                image: nil,
                                backgroundColor: UIColor.orangeColor())
                            
                        } else if error.code == NSURLErrorNotConnectedToInternet {
                            
                            self.notConnectedBanner = Banner(title: "No Internet Connection",
                                subtitle: "Could not load data." +
                                " Try again when you're connected to the internet",
                                image: nil,
                                backgroundColor: UIColor.redColor())
                        }
                        
                        self.notConnectedBanner?.dismissesOnSwipe = true
                        self.notConnectedBanner?.show(duration: nil)
                    }
                    
                }
                return
            }
            
            // No Errors Load Data
            if let fetchedResult = result.value {
                self.loginResult = fetchedResult
                self.ShowAlert("Login Successful!")
            }
            
        }
        
        APIManager.sharedInstance.validateLogin(completionHandler)
        
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
}
