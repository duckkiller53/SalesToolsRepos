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
    @IBOutlet weak var lblProd: UILabel!
    @IBOutlet weak var txtProduct: UITextField!
    var Products = [salesProd]()
    var embededViewController: ProdTable? = nil
    @IBOutlet weak var lblProdSales: UILabel!
    @IBOutlet weak var lblRows: UILabel!
    
    var notConnectedBanner: Banner?
    var prodNum: Int = 0
    
    @IBAction func btnSearch(sender: AnyObject) {
        
        clearResults()
        
        guard let text = txtProduct.text where !text.isEmpty else {
            ShowAlert("Please enter a product number!")
            txtProduct.becomeFirstResponder()
            return
        }
        
        if let prod = txtProduct.text
        {
            embededViewController!.prodNum = txtProduct.text
            GetProductSales(prod.trim())
        }
    }
    
    @IBAction func btnClear(sender: AnyObject) {
        clearForm()
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
                self.ShowAlert("No results were found")
                return
            }
            
            // No Errors Load Data
            if let fetchedResults = result.value {
                if fetchedResults.count > 0
                {
                    self.Products = fetchedResults
                    self.lblRows.text = "Records found: " + "\(fetchedResults.count)"
                self.embededViewController!.items = self.Products
                } else
                {
                    self.ShowAlert("No results were found!")
                    self.txtProduct.becomeFirstResponder()
                }
            }
            
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getProdSales(prod, completionHandler: completionHandler)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "prodtable"
        {
            embededViewController = (segue.destinationViewController as! ProdTable)
        }
        
    }
    
    func setControlColors(color: UIColor)
    {
        txtProduct.tintColor = UIColor.blackColor()
        lblProd.textColor = UIColor.whiteColor()
        lblRows.textColor = rowsFoundTint
        
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint

    }
    
    func clearResults()
    {
        lblRows.text = ""
        embededViewController!.items = [salesProd]()
        txtProduct.resignFirstResponder()    
    }
    
    func clearForm()
    {
        txtProduct.text = ""
        lblRows.text = ""
        embededViewController!.items = [salesProd]()
        txtProduct.resignFirstResponder()
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


    
}
