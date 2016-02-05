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
    var notConnectedBanner: Banner?

    @IBOutlet weak var menuButton: UIBarButtonItem!    
    @IBOutlet weak var txtCustNum: UITextField!
    
    @IBOutlet weak var lblCustNum: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblCustAddress: UILabel!
    @IBOutlet weak var lblCustCity: UILabel!
    @IBOutlet weak var lblCustZip: UILabel!
    @IBOutlet weak var lblCounty: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblSlsRep: UILabel!    
    @IBOutlet weak var lblContact: UILabel!
    
    var cust: customer?
    
    @IBAction func btnGetCustInfo(sender: AnyObject) {
        
        if let custnum = txtCustNum.text
        {
            if custnum != ""
            {
                ActivityIndicator.startAnimating()
                ActivityIndicator.hidden = false
                GetCustomer(custnum)
            }
        }
    }
   
    @IBAction func btnClear(sender: AnyObject) {
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
    
    func GetCustomer(custnum: String)
    {
        
        let completionHandler: (Result<customer, NSError>) -> Void =
        { (result) in
            
            self.ActivityIndicator.hidden = true
            self.ActivityIndicator.stopAnimating()
            
            // Test if error is from no Internet conn
            guard result.error == nil else
            {
                print(result.error)
                
                if let error = result.error
                {
                    if error.domain == NSURLErrorDomain
                    {
                        if error.code == NSURLErrorNotConnectedToInternet {
                            
                            // show not connected error & tell em to try again when they do have a connection
                            // check for existing banner
                            
                            // If we already are showing a banner, dismiss it and create new
                            if let existingBanner = self.notConnectedBanner
                            {
                                existingBanner.dismiss()
                            }
                            
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
                self.cust = fetchedResult
                self.LoadControls(self.cust!)
            }
            
        }
        
        APIManager.sharedInstance.getCustomer(custnum, completionHandler: completionHandler)
        
    }
    
    func LoadControls(cust: customer)
    {
        lblCustNum.text = "\(Int(cust.custnum))"
        lblCustName.text = cust.custName
        lblCustAddress.text = cust.address
        lblCustCity.text = cust.city
        lblCustZip.text = cust.zip
        lblCounty.text = cust.county
        lblPhone.text = FormatPhone(cust.phone!)
        lblSlsRep.text = cust.outSlsRep
        lblContact.text = cust.contact
    }
  
    
    
    func ClearForm()
    {
        txtCustNum.becomeFirstResponder()
        txtCustNum.text = ""
        lblCustNum.text = ""
        lblCustName.text = ""
        lblCustAddress.text = ""
        lblCustCity.text = ""
        lblCustZip.text = ""
        lblCounty.text = ""
        lblPhone.text = ""
        lblSlsRep.text = ""
        lblContact.text = ""
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
    }
    
    func FormatPhone(phone: String) -> String
    {
        let stringts: NSMutableString = NSMutableString(string: phone)
        stringts.insertString("(", atIndex: 0)
        stringts.insertString(")", atIndex: 4)
        stringts.insertString("-", atIndex: 5)
        stringts.insertString("-", atIndex: 9)
        
        return String(stringts)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
