//
//  CustomerSales.swift
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//


import UIKit
import Alamofire
import BRYXBanner

class CustomerSales: UIViewController, SalesParams  {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var Products = [custProd]()
    var embededViewController: ConTable? = nil
    var notConnectedBanner: Banner?
    var custNum: Int = 0
    var whseID: String = ""
    var reportType: Bool = true
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!    
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
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        setProgressBar(true)
        GetCustProducts(custNum, type: reportType, whse: whseID)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.title = "Product Sales By Cust";
        
        lblCustomer.text = ""
        lblType.text = ""
        lblWhse.text = ""
        Products.removeAll()
        embededViewController!.items = Products
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
        setupProgressBar()
        
        if  self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }        
    }
    
    // MARK: GET API DATA
    
    func GetCustProducts(cust: Int, type: Bool, whse: String)
    {        
        
        let completionHandler: (Result<[custProd], NSError>) -> Void =
        { (result) in
            
            
            // set progress bar all the way to right when page is loaded.
            self.setProgressBar(false)
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
            if let fetchedResults = result.value {
                self.Products = fetchedResults
                self.embededViewController!.items = self.Products

            }
            
            
        }
        
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
    
    
    // MARK: Support functions
    
    func setProgressBar(status: Bool)
    {
        // make sure progress is set to 0
        if let pb = progress {
            if status == true
            {
                pb.setProgress(0.0, animated: false)
                pb.hidden = false
            } else
            {
                pb.setProgress(1.0, animated: true)
                pb.hidden = true
            }
        }
    }
    
    
    func setupProgressBar()
    {
        // Create a new progressbar object
        progress = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
        
        if let pv = progress
        {
            // turn off auto constraints of the progress bar.
            pv.translatesAutoresizingMaskIntoConstraints = false
            
            // add the progress bar as a subview
            self.view.addSubview(pv)
            
            // set left side of progress bar equal to left side of view
            self.view.addConstraint(NSLayoutConstraint(item: pv, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
            
            // set right side of progress bar equal to right side of view.
            self.view.addConstraint(NSLayoutConstraint(item: pv, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
            
            // set top of progress to top of view.
            self.view.addConstraint(NSLayoutConstraint(item: pv, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
            
            pv.translatesAutoresizingMaskIntoConstraints = false
            pv.hidden = true
            
            // set's the current progress of the bar to 0
            pv.setProgress(0, animated: false)
            pv.tintColor = DefaultTint
            
            // Moves the specified subview so that it appears on top
            // of its siblings.
            self.view.bringSubviewToFront(pv)
        }
    }

    
    
    
}
