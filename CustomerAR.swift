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
    
    // Display Labels
    @IBOutlet weak var dspCustNum: UILabel!
    @IBOutlet weak var dspArea: UILabel!
    @IBOutlet weak var dspOwed: UILabel!
    @IBOutlet weak var dspUnapplied: UILabel!
    @IBOutlet weak var dspCurrent: UILabel!
    @IBOutlet weak var dspPast30: UILabel!
    @IBOutlet weak var dspPast60: UILabel!
    @IBOutlet weak var dspPast90: UILabel!
    @IBOutlet weak var dspPast120: UILabel!
    @IBOutlet weak var dspServcChg: UILabel!
    @IBOutlet weak var dspCOD: UILabel!
    @IBOutlet weak var dspMiscCredit: UILabel!
    @IBOutlet weak var dspFutureInv: UILabel!    
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
                GetCustomerAR(custnum.trim())
            }
        }

    }
    
    @IBAction func btnClearForm(sender: AnyObject) {
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
    
    func GetCustomerAR(custnum: String)
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
                
                self.ShowAlert("No results were found!")
                self.txtCustNum.becomeFirstResponder()
                return
            }
            
            // No Errors Load Data
            if let fetchedResult = result.value {
                self.custar = fetchedResult
                self.LoadControls(self.custar!)
                self.imgHeader.hidden = true
                self.imgVolm.hidden = true
            }
            
        }
        
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getCustomerAR(custnum, completionHandler: completionHandler)
        
    }
    
    func clearForm()
    {
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
        
        // Display labels.
        dspCustNum.hidden = true
        dspArea.hidden = true
        dspOwed.hidden = true
        dspUnapplied.hidden = true
        dspCurrent.hidden = true
        dspPast30.hidden = true
        dspPast60.hidden = true
        dspPast90.hidden = true
        dspPast120.hidden = true
        dspServcChg.hidden = true
        dspCOD.hidden = true
        dspMiscCredit.hidden = true
        dspFutureInv.hidden = true
        btnClear.hidden = true
        
        imgHeader.hidden = false
        imgVolm.hidden = false

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
    
    func LoadControls(cust: customerAR)
    {
        // Load Data
        lblCustNum.text = "\(Int(cust.custnum))"
        lblCustName.text = cust.custName
        lblCycleCD.text = GetARArea(cust.arArea!)
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
        
        // Display labels.
        dspCustNum.hidden = false
        dspArea.hidden = false
        dspOwed.hidden = false
        dspUnapplied.hidden = false
        dspCurrent.hidden = false
        dspPast30.hidden = false
        dspPast60.hidden = false
        dspPast90.hidden = false
        dspPast120.hidden = false
        dspServcChg.hidden = false
        dspCOD.hidden = false
        dspMiscCredit.hidden = false
        dspFutureInv.hidden = false
        btnClear.hidden = false
    }
    
    func GetARArea(area: String) -> String
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



