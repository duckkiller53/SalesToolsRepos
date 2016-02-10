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
    var notConnectedBanner: Banner?

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
        ClearForm()
    }
    
    @IBAction func GetProduct(sender: AnyObject) {
        
        
        if let prod = txtProduct.text
        {
            if prod != ""
            {
                ActivityIndicator.startAnimating()
                ActivityIndicator.hidden = false
                GetSingleProduct(prod)
            }
        }
        
        
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
                return
            }
            
            // No Errors Load Data
            if let fetchedResult = result.value {
                self.prod = fetchedResult
                self.LoadControls(self.prod!)
            }
            
        }
        
        APIManager.sharedInstance.getProduct(prod, completionHandler: completionHandler)
        
    }
    
    func LoadControls(prod: product)
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
    
    func ClearForm()
    {
        txtProduct.text = ""
        txtProduct.becomeFirstResponder()   
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
}
