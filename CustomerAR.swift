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
    var notConnectedBanner: Banner?

    @IBOutlet weak var menuButton: UIBarButtonItem!
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
        if let custnum = txtCustNum.text
        {
            if !custnum.isEmpty
            {
                ActivityIndicator.startAnimating()
                ActivityIndicator.hidden = false
                GetCustomerAR(custnum)
            }
        }

    }
    
    @IBAction func btnClearForm(sender: AnyObject) {
        ClearForm()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ClearForm()
        
        if  self.revealViewController() != nil
        {            
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
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
                return
            }
            
            // No Errors Load Data
            if let fetchedResult = result.value {
                self.custar = fetchedResult
                self.LoadControls(self.custar!)
            }
            
        }
        
        APIManager.sharedInstance.getCustomerAR(custnum, completionHandler: completionHandler)
        
    }
    
    
    
    func ClearForm()
    {
        txtCustNum.becomeFirstResponder()
        txtCustNum.text = ""
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
        
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
    }

    
    func LoadControls(cust: customerAR)
    {   
        txtCustNum.text = "\(Int(cust.custnum))"
        lblCustName.text = cust.custName
        lblCycleCD.text = GetARArea(cust.arArea!)
        lblArAmt.text = "\(cust.arAmt)"
        lblUnCashBal.text = "\(cust.unCashBal)"
        lblCurrent.text = "\(cust.current)"
        lblPastDue30.text = "\(cust.pastDue30)"
        lblPastDue60.text = "\(cust.pastDue60)"
        lblPastDue90.text = "\(cust.pastDue90)"
        lblPastDue120.text = "\(cust.pastDue120)"
        lblServChgBal.text = "\(cust.servChgBal)"
        lblCOD.text = "\(cust.codBal)"
        lblMiscCrBal.text = "\(cust.misccrBal)"
        lblFutureInvBal.text = "\(cust.futInvBal)"
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
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
