//
//  ARBalanceDetail.swift
//  SalesTools
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class ARBalanceDetail: UIViewController {
    
    var lineItem: LineItem?
    
    
    @IBOutlet weak var lineDsp: UILabel!

    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblDescrip: UILabel!
    @IBOutlet weak var lblCustNum: UILabel!
    @IBOutlet weak var lblOrdDate: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblWhse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorWithHexString("4092f2")
        
        setControlColors(UIColor.whiteColor())
        LoadControls()
        
    }
    
    func setControlColors(color: UIColor)
    {
        // Set display colors
        lineDsp.textColor = color
        lblProduct.textColor = color
        lblDescrip.textColor = color
        lblCustNum.textColor = color
        lblOrdDate.textColor = color
        lblQty.textColor = color
        lblWhse.textColor = color
    }

    
    func LoadControls() -> Void {
        lineDsp.text = "Line Number " + "(\(lineItem!.lineNum))"
        lblProduct.text = "\(lineItem!.prod)"
        lblDescrip.text = lineItem!.descrip.trunc(50)
        lblCustNum.text = "\(Int(lineItem!.custNum))"
        lblOrdDate.text = lineItem!.orderDate
        lblQty.text = "\(lineItem!.qty)"
        lblWhse.text = lineItem!.whse
    }
    
    


}
