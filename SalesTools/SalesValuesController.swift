//
//  SalesValuesController.swift
//  SalesTools
//
//  Created by David LaPorte 01/29/2016.
//  Copyright © 2016 Davco Inc. All rights reserved.
//

import Foundation
import XLForm

protocol SalesParams {
    func haveAddedSearchParams(customer: Int, type: Bool, whse: String)

}


class SalesValuesController: XLFormViewController
{    
    var delegate: SalesParams!
    
    private struct Tags {
        static let customer = "customer"
        static let type = "type"
        static let warehouse = "warehouse"
    }


    
  // Required for XLFormViewController
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    self.initializeForm()
  }
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.initializeForm()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    // Add the cancel and save buttons.
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:
      UIBarButtonSystemItem.Cancel, target: self, action: "cancelPressed:")
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
      UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
    
    
  }
  
    
   // Create the form with the XLFrom
  private func initializeForm() {
    let form : XLFormDescriptor
    var section : XLFormSectionDescriptor
    var row : XLFormRowDescriptor
    
    form = XLFormDescriptor(title: "Search Values")
    
    // Section
    section = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
    section.title = "Enter Search Values"    
    
    form.addFormSection(section)
    
    
    
    // Customer ID
    row = XLFormRowDescriptor(tag: Tags.customer, rowType:XLFormRowDescriptorTypeInteger, title:"Customer ID:")
    row.cellConfigAtConfigure["textField.placeholder"] = "Numeric only!"
    row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
    row.required = true
    row.addValidator(XLFormRegexValidator(msg: "Numbers Only", andRegexString: "^\\d+$"))
    section.addFormRow(row)
    
    // Report Type
    row = XLFormRowDescriptor(tag: Tags.type, rowType: XLFormRowDescriptorTypeBooleanSwitch,
        title: "Six Months Only:")
    row.required = false
    row.value = true
    section.addFormRow(row)
    
    // Warehosue
    row = XLFormRowDescriptor(tag: Tags.warehouse, rowType: XLFormRowDescriptorTypeText,
        title: "Warehouse:")
    row.required = true
    section.addFormRow(row)
    
    
    self.form = form
  }
  
  func cancelPressed(button: UIBarButtonItem) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func savePressed(button: UIBarButtonItem)
  {
    if(validateForm())
    {
        return
    }
  
    self.tableView.endEditing(true)
    
    let type: Bool
    if let sixMonths = form.formRowWithTag(Tags.type)?.value as? Bool
    {
        type = sixMonths
    } else {
        type = false
    }
    
    let cust = form.formRowWithTag(Tags.customer)?.value as? Int ?? 0
    let whse = form.formRowWithTag(Tags.warehouse)?.value as? String ?? ""
   
    
    self.delegate.haveAddedSearchParams(cust, type: type, whse: whse)
    self.navigationController?.popViewControllerAnimated(true)
   
  }
    
   
    
    func validateForm() -> Bool
    {
        
        let array = formValidationErrors()
        for errorItem in array {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            
            
            if validationStatus.rowDescriptor!.tag == Tags.warehouse
            {
                
                
                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath)
                {
                    self.animateCell(cell)
                }
                
//                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath) {
//                    cell.backgroundColor = .orangeColor()
//                    UIView.animateWithDuration(0.3, animations: { () -> Void in
//                        cell.backgroundColor = .whiteColor()
//                    })
//                }
            }
            else if validationStatus.rowDescriptor!.tag == Tags.customer
            {
                    if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath)
                    {
                        self.animateCell(cell)
                    }
            }
        }
        
        if array.count > 0
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    //MARK: - Helperph
    
    func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }

}