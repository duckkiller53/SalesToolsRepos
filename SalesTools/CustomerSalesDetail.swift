//
//  CustomerSalesDetail.swift
//  SalesTools
//
//  Created by William Volm on 2/3/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class CustomerSalesDetail: UIViewController {
    
    @IBOutlet weak var lblProduct: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblQtyOnHand: UILabel!
    
    @IBOutlet weak var lblQtyOnOrder: UILabel!
    
    @IBOutlet weak var lblQtyCommit: UILabel!
    
    @IBOutlet weak var lblQtyAvail: UILabel!
    
    @IBOutlet weak var lblWhse: UILabel!
    
    @IBOutlet weak var lblLastInvDate: UILabel!
    
    @IBOutlet weak var lblLastRecvDate: UILabel!
    
    var Product: custProd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        //var onHand:Int = 0;
        if (Product != nil)
        {
            lblProduct.text = Product?.prod
            lblDescription.text = (Product?.descrip1)! + " " + (Product?.descrip2)!
            lblQtyOnHand.text = "\(Product!.qtyOnHand)"
            lblQtyOnOrder.text = "\(Product!.qtyOnOrder)"
            lblQtyCommit.text = "\(Product!.qtyCommit)"
            lblQtyAvail.text = "\(Product!.qtyAvail)"
            lblWhse.text = Product!.whse
            
            lblLastInvDate.text = Product!.lastINVDate.toStringDate()
            lblLastRecvDate.text = Product!.lastRecvDate.toStringDate()
            
            print(convertDateFormater(Product!.lastINVDate))
        }
        
   }
    
    func convertDateFormater(date: String) -> String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date)
        
        
        dateFormatter.dateFormat = "MM-dd-yyyy"///this is you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        
        return timeStamp
    }
    
    

}
