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

let adminKey = "com.SalesTools.AdminKey"

class LogIn: UIViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var keyboardDismissTapGesture: UIGestureRecognizer?
    var notConnectedBanner: Banner?
    var loginResult: String?
    var hierachyToggle = false


    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtAdminPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        var name: String?
        var pass: String?
        
        if btnLogin.tag == 1
        {
            // Logout User
            name = ""
            pass = ""
            hierachyToggle = false
            
            SaveUser(name!, pass: pass!, adminpass: "")
            self.ShowAlert("Logout Successful!")
        }
        else
        {
            // Login User
            
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
            
            hierachyToggle = txtAdminPassword.text! == "volmadmin" ? true : false
            SaveUser(name!, pass: pass!, adminpass: txtAdminPassword.text!)
            TestCredentials()
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        TestCurrentCredentials()
        
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        lblTitle.textColor = UIColor.whiteColor()
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
        
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        // add observer to dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(LogIn.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogIn.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: Gradient function
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }
    
    // MARK:  Hide KeyBoard code
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(LogIn.dismissKeyboard(_:)))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardDismissTapGesture != nil
        {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    func dismissKeyboard(sender: AnyObject) {
        if txtUserName.isFirstResponder()
        {
            txtUserName.resignFirstResponder()
        } else if txtPassword.isFirstResponder()
        {
            txtPassword.resignFirstResponder()
        }
    }
    
    func SaveUser(name: String, pass: String, adminpass: String)
    {
        let Person = appUser(username: name, password: pass, adminpass: adminpass)
        PersistenceManager.saveObject(Person, path: .Credentials)
        TestCurrentCredentials()
        
        // Notify observer in MenuTableViewController to toggle menu item
        let adminpass:[String: Bool] = ["admin": hierachyToggle]
        NSNotificationCenter.defaultCenter().postNotificationName(adminKey, object: self, userInfo: adminpass)
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
                                self.SaveUser("", pass: "", adminpass: "")
                                
                            } else if error.code == NSURLErrorNotConnectedToInternet {
                                
                                self.notConnectedBanner = Banner(title: "No Internet Connection",
                                                                 subtitle: "Could not load data." +
                                    " Try again when you're connected to the internet",
                                                                 image: nil,
                                                                 backgroundColor: UIColor.redColor())
                                self.SaveUser("", pass: "", adminpass: "")
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
                    
                    if let existingBanner = self.notConnectedBanner
                    {
                        existingBanner.dismiss()
                    }
                    
                    if self.hierachyToggle == true {
                        self.ShowAlert("Login Successful as admin!")
                    } else {
                        self.ShowAlert("Login Successful!")
                    }
                }
                
        }
        
        self.ActivityIndicator.hidden = false
        self.ActivityIndicator.startAnimating()
        
        APIManager.sharedInstance.validateLogin(completionHandler)
        
    }
    
    func ShowAlert(msg: String)
    {
        let myAlert = UIAlertController(title:"SalesTools", message: msg, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion:nil);
        }
        
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated:true, completion:nil);
        
    }
    
    func TestCurrentCredentials() {
        if let credentials:appUser = PersistenceManager.loadObject(.Credentials) {
            if credentials.username != "" {
                txtUserName.text = credentials.username!
                txtPassword.text = credentials.password!
                txtAdminPassword.text = credentials.adminpass!
                btnLogin.setTitle("Logout", forState: .Normal)
                btnLogin.tag = 1
            } else {
                btnLogin.setTitle("Login", forState: .Normal)
                txtUserName.text = ""
                txtPassword.text = ""
                txtAdminPassword.text = ""
                btnLogin.tag = 0
            }
        }
    }
    

}
