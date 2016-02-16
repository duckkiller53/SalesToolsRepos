//
//  CustomerSales.swift
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//


import UIKit
import Alamofire
import BRYXBanner

class CustomerSales: UIViewController, SalesParams  {
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var Products = [custProd]()
    var embededViewController: ConTable? = nil
    var notConnectedBanner: Banner?
    var custNum: Int = 0
    var whseID: String = ""
    var reportType: Bool = true
    
    
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblWhse: UILabel!
    
    @IBAction func btnCriteria(sender: AnyObject) {
        GetSearchCriteria()
    }
    
    @IBAction func btnClear(sender: AnyObject) {
        lblCustomer.text = ""
        lblType.text = ""
        lblWhse.text = ""
        Products.removeAll()
        embededViewController!.items = Products
    }
    
    @IBAction func GetCustProds(sender: AnyObject)    {
        
        embededViewController!.items = [custProd]()
        
        if custNum == 0 || whseID.isEmpty {
            ShowAlert("Please enter search criteria!")
            return
        }
        
        GetCustProducts(custNum, type: reportType, whse: whseID)
        
    }    
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)        
        
        // Add background to customer selection area of main view.
        self.view.backgroundColor = colorWithHexString("4092f2")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove the inset to tableview due to nav controller
        self.automaticallyAdjustsScrollViewInsets = false
        
        ClearForm()
        
        if  self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Set nav bar color
        let navBarColor = navigationController!.navigationBar
        navBarColor.barTintColor = colorWithHexString("#175c99")
    }
    
    // MARK: GET API DATA
    
    func GetCustProducts(cust: Int, type: Bool, whse: String)
    {        
        
        let completionHandler: (Result<[custProd], NSError>) -> Void =
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
                if fetchedResults.count > 0
                {
                    self.Products = fetchedResults
                    self.embededViewController!.items = self.Products
                } else
                {
                    self.ShowAlert("No Results were found!")
                }
            }

            
            
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getCustSales(cust, type: type, whse: whse, completionHandler: completionHandler)
        
    }
    
    func haveAddedSearchParams(customer: Int, type: Bool, whse: String)
    {
        lblCustomer.text = customer > 0 ? "Cust: " + String(customer) : "None"
        lblType.text = type == true ? "6/Mo" : "All"
        lblWhse.text = whse > "" ? "Whse: " + whse : "None"
        
        custNum = customer
        reportType = type
        whseID = whse
    }
    
    func GetSearchCriteria()
    {
        let createVC = SalesValuesController(nibName: nil, bundle: nil)
        createVC.delegate = self
        
        // Note: pushViewController loads it on stack.
        self.navigationController?.pushViewController(createVC, animated: true)
        
        
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "contable"
        {
            embededViewController = (segue.destinationViewController as! ConTable)
        }
        
    }
    
    func ClearForm()
    {
        lblCustomer.text = ""
        lblType.text = ""
        lblWhse.text = ""
        Products.removeAll()
        embededViewController!.items = Products
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
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
    
    // MARK: Gradient background
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }
    
}
