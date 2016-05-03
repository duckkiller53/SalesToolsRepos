//
//  ProdLookupDetail.swift
//  SalesTools
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit


class ProdLookupDetail: UIViewController {
    
    @IBOutlet weak var lblProdNum: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblOnHand: UILabel!
    @IBOutlet weak var lblOnOrder: UILabel!
    @IBOutlet weak var lblQtyCommit: UILabel!
    @IBOutlet weak var lblQtyAvail: UILabel!
    @IBOutlet weak var lblWhse: UILabel!
    @IBOutlet weak var lblLastInvDate: UILabel!    
    @IBOutlet weak var lblLastRcvDate: UILabel!
    
    var Product: product?
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        setControlColors(UIColor.whiteColor())
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadControls(Product)
    }
    
    func loadControls(prod: product!)
    {
        if prod != nil
        {        
            clearForm()
                
            lblProdNum.text = prod.prod
            lblDescription.text = prod.descrip1! + " " + prod.descrip2!
            lblOnHand.text = prod.qtyOnHand.FormatInt(false)
            lblOnOrder.text = prod.qtyOnOrder.FormatInt(false)
            lblQtyCommit.text = prod.qtyCommit.FormatInt(false)
            lblQtyAvail.text = prod.qtyAvail.FormatInt(false)
            lblWhse.text = prod.whse
            lblLastInvDate.text = prod.lastINVDate
            lblLastRcvDate.text = prod.lastINVDate
            
        }
    }
    
    func clearForm()
    {
        lblProdNum.text = ""
        lblDescription.text = ""
        lblOnHand.text = ""
        lblOnOrder.text = ""
        lblQtyCommit.text = ""
        lblQtyAvail.text = ""
        lblWhse.text = ""
        lblLastInvDate.text = ""
        lblLastRcvDate.text = ""
    }
    
    func setControlColors(color: UIColor)
    {
        // Set display colors
        lblProdNum.textColor = color
        lblDescription.textColor = color
        lblOnHand.textColor = color
        lblOnOrder.textColor = color
        lblQtyCommit.textColor = color
        lblQtyAvail.textColor = color
        lblWhse.textColor = color
        lblLastInvDate.textColor = color
        lblLastRcvDate.textColor = color
    }
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }

    

}