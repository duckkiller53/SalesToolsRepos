//
//  FourthViewController.swift
//  SideBarMenuExample
//
//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner

class ProductLookUp: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var keyboardDismissTapGesture: UIGestureRecognizer?
    var notConnectedBanner: Banner?
    

    @IBOutlet weak var lblProd: UILabel!
    @IBOutlet weak var txtProduct: UITextField!
    
    @IBOutlet weak var lblProdNumber: UILabel!
    @IBOutlet weak var lblDescrip: UILabel!
    @IBOutlet weak var lblOnHand: UILabel!
    @IBOutlet weak var lblOnOrder: UILabel!
    @IBOutlet weak var lblCommit: UILabel!
    @IBOutlet weak var lblQtyAvail: UILabel!
    @IBOutlet weak var lblWhse: UILabel!
    @IBOutlet weak var lblLastInvDate: UILabel!    
    @IBOutlet weak var lblLastRecvDate: UILabel!
    
    var prod: product?
    
    
    @IBAction func btnClear(sender: AnyObject) {
        clearForm()
    }
    
    @IBAction func GetProduct(sender: AnyObject) {
        
        txtProduct.resignFirstResponder()
        
        if let prod = txtProduct.text
        {
            if prod != ""
            {
                GetSingleProduct(prod.trim())
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        setControlColors(UIColor.whiteColor())
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
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
    
    func GetSingleProduct(prod: String)
    {
        
        let completionHandler: (Result<product, NSError>) -> Void =
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
                
                self.ShowAlert("No Results were found!")
                self.txtProduct.becomeFirstResponder()
                return
            }
            
            // No Errors Load Data
            if let fetchedResult = result.value {
                self.prod = fetchedResult
                self.loadControls(self.prod!)
            }
            
        }        
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getProduct(prod, completionHandler: completionHandler)
        
    }
    
    func loadControls(prod: product)
    {
        lblProdNumber.text = prod.prod
        lblDescrip.text = prod.descrip1! + " " + prod.descrip2!
        lblOnHand.text = "\(prod.qtyOnHand)"
        lblOnOrder.text = "\(prod.qtyOnOrder)"
        lblCommit.text = "\(prod.qtyCommit)"
        lblQtyAvail.text = "\(prod.qtyAvail)"
        lblWhse.text = prod.whse
        lblLastInvDate.text = prod.lastINVDate
        lblLastRecvDate.text = prod.lastINVDate
    }
    
    func clearForm()
    {
        txtProduct.text = "" 
        lblProdNumber.text = ""
        lblDescrip.text = ""
        lblOnHand.text = ""
        lblOnOrder.text = ""
        lblCommit.text = ""
        lblQtyAvail.text = ""
        lblWhse.text = ""
        lblLastInvDate.text = ""
        lblLastRecvDate.text = ""
        ActivityIndicator.hidden = true        
        ActivityIndicator.color = DefaultTint
    }
    
    func setControlColors(color: UIColor)
    {
        // Set input colors
        txtProduct.tintColor = UIColor.blackColor()
        lblProd.textColor = UIColor.whiteColor()
        
        // Set display colors
        lblProdNumber.textColor = color
        lblDescrip.textColor = color
        lblOnHand.textColor = color
        lblOnOrder.textColor = color
        lblCommit.textColor = color
        lblQtyAvail.textColor = color
        lblWhse.textColor = color
        lblLastInvDate.textColor = color
        lblLastRecvDate.textColor = color
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
        txtProduct?.resignFirstResponder()
    }
    
    // MARK: Gradient function
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }


}
