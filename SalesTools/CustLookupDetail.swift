//
//  CustomerLookupDetail.swift
//  SalesTools
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation


class CustLookupDetail: UIViewController
{
    
    @IBOutlet weak var lblCustNum: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblCustAddress: UILabel!
    @IBOutlet weak var lblCustCity: UILabel!
    @IBOutlet weak var lblCustState: UILabel!
    @IBOutlet weak var lblCustZip: UILabel!
    @IBOutlet weak var lblCounty: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblSlsRep: UILabel!    
    @IBOutlet weak var lblContact: UILabel!
    
    var Customer: customer?
    
    override func viewWillAppear(animated: Bool) {
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        setControlColors(UIColor.whiteColor())
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearForm()
        loadControls(Customer)
    }


    func loadControls(cust: customer!)
    {
        if cust != nil {            
        
        lblCustNum.text = "\(Int(cust.custnum))"
        lblCustName.text = cust.custName
        lblCustAddress.text = cust.address
        lblCustCity.text = cust.city
        lblCustState.text = cust.state
        lblCustZip.text = cust.zip
        lblCounty.text = cust.county
        lblPhone.text = FormatPhone(cust.phone!)
        lblSlsRep.text = cust.outSlsRep
        lblContact.text = cust.contact
            
        }
    }

    func clearForm()
    {
        lblCustNum.text = ""
        lblCustName.text = ""
        lblCustAddress.text = ""
        lblCustCity.text = ""
        lblCustState.text = ""
        lblCustZip.text = ""
        lblCounty.text = ""
        lblPhone.text = ""
        lblSlsRep.text = ""
        lblContact.text = ""
    }

    func setControlColors(color: UIColor)
    {
        // Set display colors
        lblCustNum.textColor = color
        lblCustName.textColor = color
        lblCustAddress.textColor = color
        lblCustCity.textColor = color
        lblCustState.textColor = color
        lblCustZip.textColor = color
        lblCounty.textColor = color
        lblPhone.textColor = color
        lblSlsRep.textColor = color
        lblContact.textColor = color
        
    }
        
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }


}

