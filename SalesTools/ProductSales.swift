//
//  ProductSales.swift
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner
import QuickLook

class ProductSales: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {

    
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var lblProd: UILabel!
    @IBOutlet weak var txtProduct: UITextField!
    @IBOutlet weak var lblProdSales: UILabel!
    @IBOutlet weak var lblRows: UILabel!
    @IBOutlet weak var btnExportOutlet: UIButton!
   
    @IBOutlet weak var viewBar: UIView!
    @IBOutlet weak var imgHeader: UIImageView!    
    @IBOutlet weak var imgVolm: UIImageView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    
    
    var Products = [salesProd]()
    var embededViewController: ProdTable? = nil
    var notConnectedBanner: Banner?
    var prodNum: Int = 0
    var path: NSURL?

    
    @IBAction func btnSearch(sender: AnyObject) {
        
        clearResults()
        
        guard let text = txtProduct.text where !text.isEmpty else {
            showAlert("Please enter a product number!")
            txtProduct.becomeFirstResponder()
            return
        }
        
        if let prod = txtProduct.text
        {
            embededViewController!.prodNum = txtProduct.text
            getProductSales(prod.trim())
        }
    }
    
    @IBAction func btnExport(sender: AnyObject) {
        
        guard let text = txtProduct.text where !text.isEmpty else {
            showAlert("Please enter a product number!")
            txtProduct.becomeFirstResponder()
            return
        }
        
        if let prod = txtProduct.text
        {
            exportProductSales(prod)
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
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    // MARK: GET API DATA
    
    func getProductSales(prod: String)
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
                self.showAlert("No results were found")
                self.toggleButtons(true)
                return
            }
            
            // No Errors Load Data
            if let fetchedResults = result.value {
                if fetchedResults.count > 0
                {
                    self.Products = fetchedResults
                    self.lblRows.text = "Records found: " + "\(fetchedResults.count)"
                    self.embededViewController!.items = self.Products
                    self.btnExportOutlet.hidden = false
                    self.viewBar.hidden = false
                    self.imgHeader.hidden = true
                    self.imgVolm.hidden = true
                } else
                {
                    self.showAlert("No results were found!")
                    self.txtProduct.becomeFirstResponder()
                    self.imgHeader.hidden = false
                    self.imgVolm.hidden = false
                }
            }
            
            self.toggleButtons(true)
            
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        toggleButtons(false)
        
        APIManager.sharedInstance.getProdSales(prod, completionHandler: completionHandler)
        
    }
    
    // Export To CSV
    
    
    func exportProductSales(prod: String)
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
                
                self.btnExportOutlet.enabled = true
                return
            }
            
            // No Errors Load Data
            if let URL = result.value {
                self.path = URL
            } else {
                self.path = nil
                self.showAlert("Error Createing file!")
                self.btnExportOutlet.enabled = true
                return
            }
            
            // Note: pushViewController loads it on stack.
            
            let preview = QLPreviewController()
            preview.dataSource = self
            self.btnExportOutlet.enabled = true
            self.navigationController?.pushViewController(preview, animated: true)
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        btnExportOutlet.enabled = false
        
        APIManager.sharedInstance.ExportProdSales(prod, completionHandler: completionHandler)
        
    }
    
    // MARK:  Quick View Controller
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        
        return self.path!
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
        self.btnExportOutlet.hidden = true
        self.viewBar.hidden = true
    }
    
    func clearForm()
    {
        txtProduct.text = ""
        lblRows.text = ""
        embededViewController!.items = [salesProd]()
        txtProduct.resignFirstResponder()
        self.btnExportOutlet.hidden = true
        self.viewBar.hidden = true
        imgHeader.hidden = false
        imgVolm.hidden = false
    }
    
    func toggleButtons(toggle: Bool) {        
        btnClear.enabled = toggle
        btnSearch.enabled = toggle
        txtProduct.enabled = toggle
        
        if toggle {
            txtProduct.backgroundColor = UIColor.whiteColor()
        } else {
            txtProduct.backgroundColor = colorWithHexString("D3D3D3")
        }
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
