//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner
import QuickLook

class ProductLookUp: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate, ProdParams{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    @IBOutlet weak var lblWhse: UILabel!
    @IBOutlet weak var lblRows: UILabel!
    @IBOutlet weak var btnExportOutlet: UIButton!    
    @IBOutlet weak var viewBar: UIView!
    
    var products = [product]()
    var embededViewController: ProdLookupTable? = nil
    var notConnectedBanner: Banner?
    var path: NSURL?
    
    var prodParam: String?
    var descripParam: String?
    var activeParam: String?
    var whseParam: String?
    
    
    @IBAction func btnCriteria(sender: AnyObject) {
        GetSearchCriteria()
    }
    
    @IBAction func btnClear(sender: AnyObject) {
        clearForm()
    }
    
    @IBAction func btnSearch(sender: AnyObject) {
        
        clearResults()
        
        if prodParam!.isEmpty && descripParam!.isEmpty {
            showAlert("criteria must contain a product or description")
            return
        }

        GetProductSearch(prodParam!, descrip: descripParam!, isactive: activeParam!, whse: whseParam!)
    }
    
    @IBAction func btnExport(sender: AnyObject) {
        
        if prodParam!.isEmpty && descripParam!.isEmpty {
            showAlert("criteria must contain a product or description")
            return
        }
        
        ExportProductSearch(prodParam!, descrip: descripParam!, isactive: activeParam!, whse: whseParam!)
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
    
    func GetProductSearch(prod: String, descrip: String, isactive: String, whse: String)
    {
        
        let completionHandler: (Result<[product], NSError>) -> Void =
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
                    self.products = fetchedResults
                    self.lblRows.text = "Records found: " + "\(fetchedResults.count)"
                    self.embededViewController!.items = self.products
                    self.btnExportOutlet.hidden = false
                    self.viewBar.hidden = false
                } else
                {
                    self.showAlert("No results were found!")
                }
            }
            
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getProductSearch(prod, description: descrip, active: isactive, warehouse: whse, completionHandler: completionHandler)
        
    }
    
    // Export To CSV
    
    func ExportProductSearch(prod: String, descrip: String, isactive: String, whse: String)
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
        
        APIManager.sharedInstance.ExportProductSearch(prod, description: descrip, active: isactive, warehouse: whse, completionHandler: completionHandler)
        
    }
    
    // MARK:  Quick View Controller
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        
        return self.path!
    }


    // MARK: Get search params
    
    func haveAddedSearchParams(prod: String, descrip: String, active: Bool, whse: String)
    {
        clearForm()
        lblProduct.text = prod == "" ? "None" : prod
        lblDescription.text = descrip == "" ? "None" : descrip
        lblActive.text = active == true ? "Active" : "Inactive"
        lblWhse.text = whse == "" ? "None" : whse

        prodParam = prod == "" ? "null" : prod
        descripParam = descrip == "" ? "null" : descrip
        activeParam = active == true ? "A" : "I"
        whseParam = whse == "" ? "null" : whse
    
    }
    
    func GetSearchCriteria()
    {
        
        let createVC = ProductValuesController(nibName: nil, bundle: nil)
        createVC.delegate = self
        
        // Note: pushViewController loads it on stack.
        self.navigationController?.pushViewController(createVC, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "prodtable"
        {
            embededViewController = (segue.destinationViewController as! ProdLookupTable)
        }
        
    }
    
    func clearResults()
    {
        lblRows.text = ""
        products.removeAll()
        embededViewController!.items = products
        btnExportOutlet.hidden = true
        self.viewBar.hidden = true
    }
    
    func clearForm()
    {
        lblProduct.text = ""
        lblDescription.text = ""
        lblActive.text = ""
        lblWhse.text = ""
        prodParam = ""
        descripParam = ""
        activeParam = ""
        whseParam = ""
        lblRows.text = ""
        products.removeAll()
        embededViewController!.items = products
        btnExportOutlet.hidden = true
        self.viewBar.hidden = true
    }
    
    func setControlColors(color: UIColor)
    {
        lblProduct.textColor = color
        lblDescription.textColor = color
        lblActive.textColor = color
        lblWhse.textColor = color
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
