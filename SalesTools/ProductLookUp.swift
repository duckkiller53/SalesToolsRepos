//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner

class ProductLookUp: UIViewController, ProdParams {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    @IBOutlet weak var lblWhse: UILabel!
    
    var Products = [product]()
    var embededViewController: ProdLookupTable? = nil
    var notConnectedBanner: Banner?
    
    var prodParam: String?
    var descripParam: String?
    var activeParam: String?
    var whseParam: String?
    
    
    @IBAction func btnCriteria(sender: AnyObject) {
        GetSearchCriteria()
    }
    
    @IBAction func btnClear(sender: AnyObject) {
       lblProduct.text = ""
       lblDescription.text = ""
       lblActive.text = ""
       lblWhse.text = ""
       Products.removeAll()
       embededViewController!.items = Products
    }
    
    @IBAction func btnSearch(sender: AnyObject) {
        
        embededViewController!.items = [product]()
        
        if prodParam!.isEmpty && descripParam!.isEmpty {
            showAlert("criteria must contain a product or description")
            return
        }

        GetProductSearch(prodParam!, descrip: descripParam!, isactive: activeParam!, whse: whseParam!)
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
        
        clearForm()
        
        if  self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
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
                    self.Products = fetchedResults
                    self.embededViewController!.items = self.Products
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

    
    func haveAddedSearchParams(prod: String, descrip: String, active: Bool, whse: String)
    {
        lblProduct.text = !prod.isEmpty ? prod : "None"
        lblDescription.text = !descrip.isEmpty ? descrip : "None"
        lblActive.text = active == true ? "Active" : "Inactive"
        lblWhse.text = whse

        prodParam = prod
        descripParam = descrip
        activeParam = active == true ? "A" : "I"
        whseParam = whse
    
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
    
    func clearForm()
    {
        lblProduct.text = ""
        lblDescription.text = ""
        lblActive.text = ""
        lblWhse.text = ""
        Products.removeAll()
        embededViewController!.items = Products
        ActivityIndicator.hidden = true
        ActivityIndicator.color = DefaultTint
    }
    
    func setControlColors(color: UIColor)
    {
        lblProduct.textColor = color
        lblDescription.textColor = color
        lblActive.textColor = color
        lblWhse.textColor = color
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
    
    // MARK: Gradient function
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }


}
