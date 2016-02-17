//
//  CustomerInfoViewController.swift
//  SalesTools
//
//  Created by William Volm on 1/26/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner

class CustomerInfo: UIViewController {

    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var keyboardDismissTapGesture: UIGestureRecognizer?
    var notConnectedBanner: Banner?

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBOutlet weak var lblCust: UILabel!
    @IBOutlet weak var txtCustNum: UITextField!
    
    @IBOutlet weak var lblCustNum: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblCustAddress: UILabel!
    @IBOutlet weak var lblCustCity: UILabel!    
    @IBOutlet weak var lblCustState: UILabel!
    @IBOutlet weak var lblCustZip: UILabel!
    @IBOutlet weak var lblCounty: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblSlsRep: UILabel!    
    @IBOutlet weak var lblContact: UILabel!
    
    var cust: customer?
    
    @IBAction func btnGetCustInfo(sender: AnyObject) {
        txtCustNum.resignFirstResponder()
        
        if let custnum = txtCustNum.text
        {
            if custnum != ""
            {
                GetCustomer(custnum.trim())
            }
        }
    }
   
    @IBAction func btnClear(sender: AnyObject) {
        clearForm()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
        
        setControlColors(UIColor.whiteColor())

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearForm()
        
        if  self.revealViewController() != nil
        {   
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // add observer to dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    
    // MARK: GET API DATA
    
    func GetCustomer(custnum: String)
    {
        
        let completionHandler: (Result<customer, NSError>) -> Void =
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
                
                self.ShowAlert("No results were found!")
                self.txtCustNum.becomeFirstResponder()
                return
            }
            
            // No Errors Load Data
            if let fetchedResult = result.value {
                self.cust = fetchedResult
                self.loadControls(self.cust!)
            }
            
        }        
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getCustomer(custnum, completionHandler: completionHandler)
        
    }
    
    func loadControls(cust: customer)
    {
        lblCustNum.text = "\(Int(cust.custnum))"
        lblCustName.text = cust.custName
        lblCustAddress.text = cust.address
        lblCustCity.text = cust.city
        lblCustState.text = cust.state
        lblCustZip.text = cust.zip
        lblCounty.text = cust.county
        lblPhone.text = FormatPhone(cust.phone!)
        lblSlsRep.text = cust.outSlsRep
        lblContact.text = cust.contact
    }
    
    func clearForm()
    {        
        txtCustNum.text = ""
        lblCustNum.text = ""
        lblCustName.text = ""
        lblCustAddress.text = ""
        lblCustCity.text = ""
        lblCustState.text = ""
        lblCustZip.text = ""
        lblCounty.text = ""
        lblPhone.text = ""
        lblSlsRep.text = ""
        lblContact.text = ""
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
    }
    
    func setControlColors(color: UIColor)
    {
        // Set Input colors
        txtCustNum.tintColor = UIColor.blackColor()
        lblCust.textColor = UIColor.whiteColor()
        
        // Set display colors
        lblCustNum.textColor = color
        lblCustName.textColor = color
        lblCustAddress.textColor = color
        lblCustCity.textColor = color
        lblCustState.textColor = color
        lblCustZip.textColor = color
        lblCounty.textColor = color
        lblPhone.textColor = color
        lblSlsRep.textColor = color
        lblContact.textColor = color
        
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
    
    // MARK:  Hide KeyBoard code
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
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
        txtCustNum?.resignFirstResponder()
    }
    
    // MARK: gradient function
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }

}
