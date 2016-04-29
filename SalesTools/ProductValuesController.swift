//
//  ProductValuesController.swift
//  SalesTools
//
//  Created by David LaPorte 01/29/2016.
//  Copyright © 2016 Davco Inc. All rights reserved.
//

import Foundation
import XLForm

protocol ProdParams {
    func haveAddedSearchParams(prod: String, descrip: String, active: Bool, whse: String)
}


class ProductValuesController: XLFormViewController
{
    var delegate: ProdParams!
    
    private struct Tags {
        static let product = "product"
        static let description = "description"
        static let isactive = "active"
        static let warehouse = "whse"
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
            UIBarButtonSystemItem.Cancel, target: self, action: #selector(ProductValuesController.cancelPressed(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.Save, target: self, action: #selector(ProductValuesController.savePressed(_:)))
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

        
        // Product ID
        row = XLFormRowDescriptor(tag: Tags.product, rowType:XLFormRowDescriptorTypeText,
              title:"Product ID:")
        row.cellConfigAtConfigure["textField.placeholder"] = "ie: BP171"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
        row.required = false
        section.addFormRow(row)
        
        // descrip
        row = XLFormRowDescriptor(tag: Tags.description, rowType: XLFormRowDescriptorTypeText,
            title: "Description:")
        row.cellConfigAtConfigure["textField.placeholder"] = "ie: wick"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
        row.required = false
        section.addFormRow(row)

        // Active
        row = XLFormRowDescriptor(tag: Tags.isactive, rowType: XLFormRowDescriptorTypeBooleanSwitch,
            title: "Active products:")
        row.required = false
        row.value = true
        section.addFormRow(row)

        // whse
        row = XLFormRowDescriptor(tag: Tags.warehouse, rowType: XLFormRowDescriptorTypeText,
            title: "Warehouse:")
        row.cellConfigAtConfigure["textField.placeholder"] = "ie: A/G"
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
        
        // prod
        let prodparam = form.formRowWithTag(Tags.product)?.value as? String ?? ""
        let descparam = form.formRowWithTag(Tags.description)?.value as? String ?? ""
        
        let activeparam: Bool
        if let isActive = form.formRowWithTag(Tags.isactive)?.value as? Bool
        {
            activeparam = isActive
        } else {
            activeparam = false
        }
        
        let whseparam = form.formRowWithTag(Tags.warehouse)?.value as? String ?? ""
        
        // call delegate and close form
        self.delegate.haveAddedSearchParams(prodparam, descrip: descparam, active: activeparam, whse: whseparam.uppercaseString)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}