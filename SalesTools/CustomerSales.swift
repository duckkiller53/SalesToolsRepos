//
//  OurTableViewController.swift
//  SideBarMenuExample
//
//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//


import UIKit
import BRYXBanner

class CustomerSales: UIViewController, SalesParams  {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var Products = [custProd]()
    var embededViewController: ConTable? = nil
    
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
        
        let type = lblType.text == "true" ? true : false
        let cust = lblCustomer.text != "" ? lblCustomer.text : ""
        let whse = lblWhse.text != "" ? lblWhse.text : ""
        
        
        
        GetCustProducts(cust!, type: type, whse: whse!);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.title = "Product Sales By Cust";
        
        lblCustomer.text = ""
        lblType.text = ""
        lblWhse.text = ""
        
        if  self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    
    func GetCustProducts(cust: String, type: Bool, whse: String)
    {
        // call api and load products array.
        
        // TESTING
        for i in 0...250 {
            let prod: custProd = custProd()
            prod._prod = "BP20003" + String(i)
            prod._descrip1 = "This is"
            prod._descrip2 = " item \(i)"
            
            Products.append(prod)
        }
        
        embededViewController!.items = Products

    }
    
    func haveAddedSearchParams(customer: Int, type: Bool, whse: String)
    {
        lblCustomer.text = customer > 0 ? "Cust: " + String(customer) : "None"
        lblType.text = type == true ? "6/Mo" : "All"
        lblWhse.text = whse > "" ? "Whse: " + whse : "None"
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
    
    
    
}
