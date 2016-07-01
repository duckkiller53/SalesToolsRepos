//
//  CustomerAR.swift
//  SalesTools
//
//  Created by William Volm on 1/26/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner

class CustomerAR: UIViewController {
    
   
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var keyboardDismissTapGesture: UIGestureRecognizer?
    var notConnectedBanner: Banner?

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var imgVolm: UIImageView!    
    @IBOutlet weak var viewDSP: UIView!    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    // Display Data
    @IBOutlet weak var lblCust: UILabel!
    @IBOutlet weak var txtCustNum: UITextField!
    @IBOutlet weak var lblCustNum: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblCycleCD: UILabel!
    @IBOutlet weak var lblArAmt: UILabel!
    @IBOutlet weak var lblUnCashBal: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblPastDue30: UILabel!
    @IBOutlet weak var lblPastDue60: UILabel!
    @IBOutlet weak var lblPastDue90: UILabel!
    @IBOutlet weak var lblPastDue120: UILabel!
    @IBOutlet weak var lblServChgBal: UILabel!
    @IBOutlet weak var lblCOD: UILabel!
    @IBOutlet weak var lblMiscCrBal: UILabel!
    @IBOutlet weak var lblFutureInvBal: UILabel!
    var custar: customerAR?

    
    @IBAction func btnSearch(sender: AnyObject) {        
        
        txtCustNum.resignFirstResponder()
        
        if let custnum = txtCustNum.text
        {
            if !custnum.isEmpty
            {
                getCustomerAR(custnum.trim())
            } else {
                showAlert("Please enter a customer number!")
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
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // add observer to dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(CustomerAR.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CustomerAR.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    }
    
    
    // MARK: GET API DATA
    
    func getCustomerAR(custnum: String)
    {
        
        let completionHandler: (Result<customerAR, NSError>) -> Void =
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
                
                self.showAlert("No results were found!")
                self.txtCustNum.becomeFirstResponder()
                self.viewDSP.hidden = true
                self.toggleButtons(true)
                return
            }
            
            // No Errors Load Data
            if let fetchedResult = result.value {
                self.custar = fetchedResult
                self.loadControls(self.custar!)
                self.imgHeader.hidden = true
                self.imgVolm.hidden = true
                self.viewDSP.hidden = false
            }
            
            self.toggleButtons(true)
            
        }
        
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        toggleButtons(false)
        
        APIManager.sharedInstance.getCustomerAR(custnum, completionHandler: completionHandler)
        
    }
    
    func clearForm()
    {
        txtCustNum.text = ""
        lblCustNum.text = ""
        lblCustName.text = ""
        lblCycleCD.text = ""
        lblArAmt.text = ""
        lblUnCashBal.text = ""
        lblCurrent.text = ""
        lblPastDue30.text = ""
        lblPastDue60.text = ""
        lblPastDue90.text = ""
        lblPastDue120.text = ""
        lblServChgBal.text = ""
        lblCOD.text = ""
        lblMiscCrBal.text = ""
        lblFutureInvBal.text = ""
        imgHeader.hidden = false
        imgVolm.hidden = false
        viewDSP.hidden = true

    }
    
    func toggleButtons(toggle: Bool) {
        btnSearch.enabled = toggle
        txtCustNum.enabled = toggle
        btnClear.enabled = toggle
        
        if toggle {
            txtCustNum.backgroundColor = UIColor.whiteColor()
        } else {
            txtCustNum.backgroundColor = colorWithHexString("D3D3D3")
        }
    }
    
    func setControlColors(color: UIColor)
    {
        // Set input control colors
        txtCustNum.tintColor = UIColor.blackColor()
        lblCust.textColor = UIColor.whiteColor()
        
        // Set display colors
        lblCustNum.textColor = color
        lblCustName.textColor = color
        lblCycleCD.textColor = color
        lblArAmt.textColor = color
        lblUnCashBal.textColor = color
        lblCurrent.textColor = color
        lblPastDue30.textColor = color
        lblPastDue60.textColor = color
        lblPastDue90.textColor = color
        lblPastDue120.textColor = color
        lblServChgBal.textColor = color
        lblCOD.textColor = color
        lblMiscCrBal.textColor = color
        lblFutureInvBal.textColor = color
        
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
    }
    
    func loadControls(cust: customerAR)
    {
        // Load Data
        lblCustNum.text = "\(Int(cust.custnum))"
        lblCustName.text = cust.custName
        lblCycleCD.text = getARArea(cust.arArea!)
        lblArAmt.text = cust.arAmt.FormatDouble(true)
        lblUnCashBal.text = cust.unCashBal.FormatDouble(true)
        lblCurrent.text = cust.current.FormatDouble(true)
        lblPastDue30.text = cust.pastDue30.FormatDouble(true)
        lblPastDue60.text = cust.pastDue60.FormatDouble(true)
        lblPastDue90.text = cust.pastDue90.FormatDouble(true)
        lblPastDue120.text = cust.pastDue120.FormatDouble(true)
        lblServChgBal.text = cust.servChgBal.FormatDouble(true)
        lblCOD.text = cust.codBal.FormatDouble(true)
        lblMiscCrBal.text = cust.misccrBal.FormatDouble(true)
        lblFutureInvBal.text = cust.futInvBal.FormatDouble(true)
    }
    
    func getARArea(area: String) -> String
    {
        var returnArea: String = ""
        
        switch area
        {
        case "ANT":
            returnArea = "Antigo"
            
        case "ID":
            returnArea = "Idaho"
            
        case "WA":
            returnArea = "Washington"
            
        default:
            returnArea = area
        }
        
        return returnArea
        
    }
    
    func showAlert(msg: String)
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
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomerAR.dismissKeyboard(_:)))
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
    
    //MARK: Gradient function
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }
    
    
}



