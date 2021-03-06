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
    @IBOutlet weak var lblQtySold: UILabel!
    @IBOutlet weak var lblQtyOnHand: UILabel!
    @IBOutlet weak var lblQtyOnOrder: UILabel!
    @IBOutlet weak var lblQtyCommit: UILabel!
    @IBOutlet weak var lblQtyAvail: UILabel!
    @IBOutlet weak var lblWhse: UILabel!
    @IBOutlet weak var lblLastInvDate: UILabel!
    @IBOutlet weak var lblLastRecvDate: UILabel!
    
    var Product: custProd?
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        setControlColors(UIColor.whiteColor())
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
    }
    
    func setControlColors(color: UIColor)
    {
        lblProduct.textColor = color
        lblDescription.textColor = color
        lblQtySold.textColor = color
        lblQtyOnHand.textColor = color
        lblQtyOnOrder.textColor = color
        lblQtyCommit.textColor = color
        lblQtyAvail.textColor = color
        lblWhse.textColor = color
        lblLastInvDate.textColor = color
        lblLastRecvDate.textColor = color
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Product != nil)
        {
            clearForm()

            lblProduct.text = Product?.prod
            lblDescription.text = (Product?.descrip1)! + " " + (Product?.descrip2)!
            lblQtySold.text = Product!.qtySold.FormatInt(false)
            lblQtyOnHand.text = Product!.qtyOnHand.FormatInt(false)
            lblQtyOnOrder.text = Product!.qtyOnOrder.FormatInt(false)
            lblQtyCommit.text = Product!.qtyCommit.FormatInt(false)
            lblQtyAvail.text = Product!.qtyAvail.FormatInt(false)
            lblWhse.text = Product!.whse
            
            lblLastInvDate.text = Product!.lastINVDate
            lblLastRecvDate.text = Product!.lastRecvDate
        }
        
   }
    
    func clearForm()
    {
    
    lblProduct.text = ""
    lblDescription.text = ""
    lblQtySold.text = ""
    lblQtyOnHand.text = ""
    lblQtyOnOrder.text = ""
    lblQtyCommit.text = ""
    lblQtyAvail.text = ""
    lblWhse.text = ""
    
    lblLastInvDate.text = ""
    lblLastRecvDate.text = ""
    }
    
    
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }
    

}
