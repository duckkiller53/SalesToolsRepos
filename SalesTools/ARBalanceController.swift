//
//  ARBalanceController.swift
//  SalesTools
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner

class ARBalanceController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var lblCustNum: UILabel!
    @IBOutlet weak var txtCustNum: UITextField!
    @IBOutlet weak var lblCustNumDisp: UILabel!    
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblARTotBal: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblAROver: UILabel!
    @IBOutlet weak var viewBar: UIView!
    
    
    
    var arbalance: ARBalance?
    var notConnectedBanner: Banner?
    var keyboardDismissTapGesture: UIGestureRecognizer?
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var embededViewController: ARBalanceInvoice? = nil
    
    
    @IBAction func btnSearch(sender: AnyObject) {
        
        txtCustNum.resignFirstResponder()
        
        if let custnum = txtCustNum.text
        {
            if !custnum.isEmpty
            {
                GetARBalance(custnum.trim())
            }
        }
    }    
    
    override func viewWillAppear(animated: Bool) {
       
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        
        // Add background to customer selection area of main view.
        self.view.backgroundColor = colorWithHexString("4092f2")
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
            
            
            // add observer to dismiss keyboard
            NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(ARBalanceController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ARBalanceController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        }
        
    }
    
    // MARK: GET API DATA
    
    func GetARBalance(custid: String)
    {
        
        let completionHandler: (Result<ARBalance, NSError>) -> Void =
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
                    return
                }
                
                // No Errors Load Data
                if let fetchedResult = result.value {
                    self.arbalance = fetchedResult
                    self.LoadControls(self.arbalance!)
                }
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getARBalance(custid, completionHandler: completionHandler)
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "invoices"
        {
            embededViewController = (segue.destinationViewController as! ARBalanceInvoice)
        }
        
    }
    
    // MARK:  Hide KeyBoard code
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(ARBalanceController.dismissKeyboard(_:)))
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

    
    func clearForm() {
        lblCustNumDisp.text = ""
        lblCustName.text = ""
        lblARTotBal.text = ""
        lblCurrent.text = ""
        lblAROver.text = ""
        self.viewBar.hidden = true
    }
    
    func LoadControls(cust: ARBalance)
    {
        lblCustNumDisp.text = "\(Int(cust.custnum))"
        lblCustName.text = cust.custName
        lblARTotBal.text = "\(cust.arTotBal)"
        lblCurrent.text = "\(cust.current)"
        lblAROver.text = "\(cust.arOver)"
        self.embededViewController!.items = self.arbalance!.invoices
        self.viewBar.hidden = false
    }
    
    func setControlColors(color: UIColor)
    {
        // Set display colors
        txtCustNum.tintColor = UIColor.blackColor()
        lblCustNum.textColor = color
        lblCustNumDisp.textColor = color
        lblCustName.textColor = color
        lblARTotBal.textColor = color
        lblCurrent.textColor = color
        lblAROver.textColor = color
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()
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

    func showAlert(msg: String)
    {
        let myAlert = UIAlertController(title:"SalesTools", message: msg, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion:nil);
        }
        
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated:true, completion:nil);
        
    }



}
