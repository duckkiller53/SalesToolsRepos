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
import QuickLook

class CustomerLookUp: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate, CustParams {

    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var lblCustNo: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblRows: UILabel!
    @IBOutlet weak var btnExportOutlet: UIButton!    
    @IBOutlet weak var viewBar: UIView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var imgVolm: UIImageView!
    
    var customers = [customer]()
    var notConnectedBanner: Banner?
    var embededViewController: CustLookupTable? = nil
    var path: NSURL?
    
    var custidParam: String?
    var nameParam: String?
    var cityParam: String?
    var stateParam: String?
    
    
    @IBAction func btnCriteria(sender: AnyObject) {
        GetSearchCriteria()
    }
    
    @IBAction func btnClear(sender: AnyObject) {
        clearForm()
    }
    
    @IBAction func btnSearch(sender: AnyObject) {
        
        clearResults()
        GetCustSearch(custidParam!, name: nameParam!, custcity: cityParam!, custstate: stateParam!)
    }
    
    
    @IBAction func btnExport(sender: AnyObject) {
        ExportCustSearch(custidParam!, name: nameParam!, custcity: cityParam!, custstate: stateParam!)
    }
        
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        
        // Add background to customer selection area of main view.
        self.view.backgroundColor = colorWithHexString("4092f2")
        
        // Set Colors of top buttons.
        setControlColors(UIColor.whiteColor())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove the inset to tableview due to nav controller
        self.automaticallyAdjustsScrollViewInsets = false
        
        clearForm()
        
        if  self.revealViewController() != nil
        {   
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
      
    }
    
    // MARK: GET API DATA
    
    func GetCustSearch(id: String, name: String, custcity: String, custstate: String)
    {
        
        let completionHandler: (Result<[customer], NSError>) -> Void =
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
            if let fetchedResults = result.value {
                if fetchedResults.count > 0
                {
                    self.customers = fetchedResults
                    self.lblRows.text = "Records found: " + "\(fetchedResults.count)"
                    self.embededViewController!.items = self.customers
                    self.btnExportOutlet.hidden = false
                    self.viewBar.hidden = false
                    self.imgHeader.hidden = true
                    self.imgVolm.hidden = true
                } else
                {
                    self.showAlert("No results were found!")
                }
            }

            
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getCustomerSearch(id, custname: name, city: custcity, state: custstate, completionHandler: completionHandler)
        
    }
    
    // Export To CSV
    
    
    func ExportCustSearch(id: String, name: String, custcity: String, custstate: String)
    {
        
        let completionHandler: (Result<NSURL, NSError>) -> Void =
        { (result) in
            
            
            self.ActivityIndicator.hidden = true
            self.ActivityIndicator.stopAnimating()
            
            // Test if error is unauthorized or no connection
            guard result.error == nil else
            {
                print("Bad file path")
                
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
            if let URL = result.value {
                self.path = URL
            } else {
                self.path = nil
                self.showAlert("Error Createing file!")
                return
            }
            
            // Note: pushViewController loads it on stack.
            
            let preview = QLPreviewController()
            preview.dataSource = self
            self.navigationController?.pushViewController(preview, animated: true)
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.ExportCustomerSearch(id, custname: name, city: custcity, state: custstate, completionHandler: completionHandler)
        
    }

    
    // MARK:  Quick View Controller
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        
        return self.path!
    }

    
    func haveAddedSearchParams(custid: String, custname: String, city: String, state: String)
    {
        clearForm()
        
        custidParam = custid
        nameParam = custname
        cityParam = city
        stateParam = state
        
        lblCustNo.text = custid == "null" ? "None" : custid
        lblCustName.text = custname == "null" ? "None" : custname
        lblCity.text = city == "null" ? "None" : city
        lblState.text = state == "null" ? "None" : state
        imgHeader.hidden = true
    }

    
    func GetSearchCriteria()
    {
        
        let createVC = CustValuesController(nibName: nil, bundle: nil)
        createVC.delegate = self
        
        // Note: pushViewController loads it on stack.
        self.navigationController?.pushViewController(createVC, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "custtable"
        {
            embededViewController = (segue.destinationViewController as! CustLookupTable)
        }
        
    }
    
    func clearResults()
    {
        lblRows.text = ""
        customers.removeAll()
        embededViewController!.items = [customer]()
        btnExportOutlet.hidden = true
        self.viewBar.hidden = true
    }
    
    func clearForm()
    {
        custidParam = "null"
        nameParam = "null"
        cityParam = "null"
        stateParam = "null"
        lblCustNo.text = ""
        lblCustName.text = ""
        lblCity.text = ""
        lblState.text = ""
        lblRows.text = ""
        customers.removeAll()
        embededViewController!.items = [customer]()
        btnExportOutlet.hidden = true
        self.viewBar.hidden = true
        imgHeader.hidden = false
        imgVolm.hidden = false
    
    }
    
    func setControlColors(color: UIColor)
    {
        lblCustNo.textColor = color
        lblCustName.textColor = color
        lblCity.textColor = color
        lblState.textColor = color
        lblRows.textColor = rowsFoundTint
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
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
