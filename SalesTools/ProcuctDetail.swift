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
    
    @IBOutlet weak var lblCustNum: UILabel!
    
    
    @IBOutlet weak var lblCustName: UILabel!
    
    
    @IBOutlet weak var lblOrderNum: UILabel!
    
    
    @IBOutlet weak var lblQtySold: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblCost: UILabel!
    
    @IBOutlet weak var lblDateSold: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Product != nil)
        {
            
            lblCustNum.text = "\(Product!.custNum)"
            lblCustName.text = Product!.custName
            lblOrderNum.text = "\(Product!.ordNum)"
            lblQtySold.text = "\(Product!.qtySold)"
            lblPrice.text = "\(Product!.price)"
            lblCost.text = "\(Product!.cost)"
            lblDateSold.text = Product!.dateSold
        }

    }

}
