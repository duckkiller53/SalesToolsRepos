//
//  ProcuctDetail.swift
//  SalesTools
//
//  Created by William Volm on 2/4/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class ProductDetail: UIViewController {
    
    var Product: salesProd?
    var prodNum: String?
    
    @IBOutlet weak var lblCustNum: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblOrderNum: UILabel!
    @IBOutlet weak var lblQtySold: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblDateSold: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        setControlColors(UIColor.whiteColor())
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
    }
    
    func setControlColors(color: UIColor)
    {
        lblCustNum.textColor = color
        lblProduct.textColor = color
        lblCustName.textColor = color
        lblOrderNum.textColor = color
        lblQtySold.textColor = color
        lblPrice.textColor = color
        lblCost.textColor = color
        lblDateSold.textColor = color
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Product != nil)
        {            
            clearForm()
           
            lblCustNum.text = "\(Product!.custNum)"
            lblProduct.text = prodNum
            lblCustName.text = Product!.custName
            lblOrderNum.text = "\(Product!.ordNum)"
            lblQtySold.text = Product!.qtySold.FormatInt(false)
            lblPrice.text = Product!.price.FormatDouble(true)
            lblCost.text = Product!.cost.FormatDouble(true)
            lblDateSold.text = Product!.dateSold
        }
        
    }
    
    func clearForm()
    {
        lblCustNum.text = ""
        lblProduct.text = ""
        lblCustName.text = ""
        lblOrderNum.text = ""
        lblQtySold.text = ""
        lblPrice.text = ""
        lblCost.text = ""
        lblDateSold.text = ""
    }
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }

}
