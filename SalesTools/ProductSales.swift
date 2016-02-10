//
//  ProductSales.swift
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner

class ProductSales: UIViewController {

    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var txtProduct: UITextField!
    var Products = [salesProd]()
    var embededViewController: ProdTable? = nil
    var notConnectedBanner: Banner?
    var prodNum: Int = 0
    
    @IBAction func btnSearch(sender: AnyObject) {
        if let prod = txtProduct.text
        {
            ActivityIndicator.startAnimating()
            ActivityIndicator.hidden = false
            GetProductSales(prod)
        }
    }     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ClearForm()
        
        // remove the inset to tableview due to nav controller
        self.automaticallyAdjustsScrollViewInsets = false
        
        if  self.revealViewController() != nil
        {            
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    // MARK: GET API DATA
    
    func GetProductSales(prod: String)
    {        
        
        let completionHandler: (Result<[salesProd], NSError>) -> Void =
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
            if let fetchedResults = result.value {
                self.Products = fetchedResults
                self.embededViewController!.items = self.Products
                
            }
            
        }
        
        APIManager.sharedInstance.getProdSales(prod, completionHandler: completionHandler)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "prodtable"
        {
            embededViewController = (segue.destinationViewController as! ProdTable)
        }
        
    }
    
    func ClearForm()
    {
        txtProduct.text = ""
        txtProduct.becomeFirstResponder()
        Products.removeAll()
        embededViewController!.items = Products
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
    }

    
}
