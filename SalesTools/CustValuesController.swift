//
//  ProductValuesController.swift
//  SalesTools
//
//  Created by David LaPorte 01/29/2016.
//  Copyright © 2016 Davco Inc. All rights reserved.
//

import Foundation
import XLForm

protocol CustParams {
    func haveAddedSearchParams(custid: String, custname: String, city: String, state: String)
}


class CustValuesController: XLFormViewController
{
    var delegate: CustParams!
    
    private struct Tags {
        static let custid = "custid"
        static let custname = "custname"
        static let city = "city"
        static let state = "state"
    }
    
    // Required for XLFormViewController
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        // Add the cancel and save buttons.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.Cancel, target: self, action: #selector(CustValuesController.cancelPressed(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.Save, target: self, action: #selector(CustValuesController.savePressed(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()        
        
    }
    
    
    // Create the form with the XLFrom
    private func initializeForm()
    {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Search Values")
        
        // Section
        section = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
        section.title = "Enter Search Values"
        
        form.addFormSection(section)
        
        
        // CustID
        row = XLFormRowDescriptor(tag: Tags.custid, rowType:XLFormRowDescriptorTypeText,
            title:"Customer ID:")
        row.cellConfigAtConfigure["textField.placeholder"] = "ie: 600"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
        row.required = false
        section.addFormRow(row)
        
        // CustName
        row = XLFormRowDescriptor(tag: Tags.custname, rowType: XLFormRowDescriptorTypeText,
            title: "Customer Name:")
        row.cellConfigAtConfigure["textField.placeholder"] = "ie: SUN"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
        row.required = false
        section.addFormRow(row)
        
        // City
        row = XLFormRowDescriptor(tag: Tags.city, rowType: XLFormRowDescriptorTypeText,
            title: "City:")
        row.cellConfigAtConfigure["textField.placeholder"] = "ie: Antigo"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
        row.required = false
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.state, rowType: XLFormRowDescriptorTypeText,
            title: "State:")
        row.cellConfigAtConfigure["textField.placeholder"] = "ie: WI"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
        row.required = false
        section.addFormRow(row)


        
        
        
        
        self.form = form
    }
    
    func cancelPressed(button: UIBarButtonItem)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func savePressed(button: UIBarButtonItem)
    {
        self.tableView.endEditing(true)       
        
        let idParam = form.formRowWithTag(Tags.custid)?.value as? String ?? "null"
        let nameParam = form.formRowWithTag(Tags.custname)?.value as? String ?? "null"
        let cityParam = form.formRowWithTag(Tags.city)?.value as? String ?? "null"
        let stateParam = form.formRowWithTag(Tags.state)?.value as? String ?? "null"

        
        // call delegate and close form
        self.delegate.haveAddedSearchParams(idParam, custname: nameParam, city: cityParam, state: stateParam)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}