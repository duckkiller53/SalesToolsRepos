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
    func haveAddedSearchParams(customer: Int, type: Bool, exclude: Bool, whse: String)
}


class SalesValuesController: XLFormViewController
{    
    var delegate: SalesParams!
    
    private struct Tags {
        static let customer = "customer"
        static let type = "type"
        static let warehouse = "warehouse"
        static let noequip = "noequip"
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
    
    
    self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    
    
    // Add the cancel and save buttons.
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:
      UIBarButtonSystemItem.Cancel, target: self, action: #selector(SalesValuesController.cancelPressed(_:)))
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
      UIBarButtonSystemItem.Save, target: self, action: #selector(SalesValuesController.savePressed(_:)))
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    
    
  }
  
    
   // Create the form with the XLFrom
  private func initializeForm() {
    let form : XLFormDescriptor
    var section1 : XLFormSectionDescriptor
    var section2 : XLFormSectionDescriptor
    var section3 : XLFormSectionDescriptor
    var row : XLFormRowDescriptor
    
    form = XLFormDescriptor(title: "Search Values")
    
    // SECTION 1
    
    section1 = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
    section1.title = "Enter customer and warehouse"
    
    form.addFormSection(section1)
    
    
    // Customer ID
    row = XLFormRowDescriptor(tag: Tags.customer, rowType:XLFormRowDescriptorTypeInteger, title:"Customer ID:")
    row.cellConfigAtConfigure["textField.placeholder"] = "Numeric only!"
    row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Left.rawValue
    row.required = true
    row.addValidator(XLFormRegexValidator(msg: "Numbers Only", andRegexString: "^\\d+$"))
    section1.addFormRow(row)
    
    // Warehosue
    row = XLFormRowDescriptor(tag: Tags.warehouse, rowType: XLFormRowDescriptorTypeText,
        title: "Warehouse:")
    row.required = true
    section1.addFormRow(row)
    
    form.addFormSection(section1)
    
    // SECTION 2
    
    section2 = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
    section2.title = "Select to include/exclude equipment sales"
    
    // Equipment Y/N
    row = XLFormRowDescriptor(tag: Tags.noequip, rowType: XLFormRowDescriptorTypeBooleanSwitch,
        title: "Exclude equipment sales Y/N:")
    row.required = false
    row.value = true
    section2.addFormRow(row)
    
    form.addFormSection(section2)
    
    // SECTION 3
    
    
    
    section3 = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
    section3.title = "Report Defaults to 12 months"
    
    // Report Type
    
    row = XLFormRowDescriptor(tag: Tags.type, rowType: XLFormRowDescriptorTypeBooleanSwitch,
        title: "Six Months Only:")
    row.required = false
    row.value = true
    section3.addFormRow(row)
    form.addFormSection(section3)    
    
    
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
    
    let cust = form.formRowWithTag(Tags.customer)?.value as? Int ?? 0
    let whse = form.formRowWithTag(Tags.warehouse)?.value as? String ?? ""
    
    let type: Bool
    if let sixMonths = form.formRowWithTag(Tags.type)?.value as? Bool
    {
        type = sixMonths
    } else {
        type = false
    }
    
    let exclude: Bool
    if let exclude_equip = form.formRowWithTag(Tags.noequip)?.value as? Bool
    {
        exclude = exclude_equip
    } else {
        exclude = false
    }
    
    
   
    
    self.delegate.haveAddedSearchParams(cust, type: type, exclude: exclude, whse: whse.uppercaseString)
    self.navigationController?.popViewControllerAnimated(true)
   
  }
   
    
   
  // MARK: Validation:
    
//    func filterOutBadCharacters(s:String?, disallowedCharacterSet:NSCharacterSet)->String?{
//        let components = s?.componentsSeparatedByCharactersInSet(disallowedCharacterSet)
//        let result = components?.joinWithSeparator("")
//        return result
//    }
//    
//    func replacementRemovingNonNumeric(textField:UITextField)->String?{
//        let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
//        return filterOutBadCharacters(textField.text, disallowedCharacterSet: disallowedCharacterSet)
//    }
//    
//    func associatedXLForm(textField:UITextField?)-> XLFormRowDescriptor?{
//        var current: UIView? = textField
//        while(current.dynamicType != XLFormRowDescriptor().dynamicType &&
//            current != nil){
//                current = current?.superview
//                
//                if current == nil { return nil }
//        }
//        return current as? XLFormRowDescriptor
//    }
//    
//    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        if associatedXLForm(textField)?.tag  == form.formRowWithTag(Tags.customer)?.tag {
//            textField.text = replacementRemovingNonNumeric(textField)
//        } else if associatedXLForm(textField)?.tag  == form.formRowWithTag(Tags.warehouse)?.tag {
//            textField.text = textField.text?.uppercaseString
//        } else{
//            return true
//        }
//        
//        return false
//    }
    
    
    
    
//    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        var result = true
//        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
//        
//        
//        
//        if textField  == form.formRowWithTag(Tags.customer)?.tag! {
//            if string.characters.count > 0 {
//                let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
//                let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
//                
//                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 9
//                
//                let scanner = NSScanner(string: prospectiveText)
//                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.atEnd
//                
//                result = replacementStringIsLegal &&
//                    resultingStringLengthIsLegal &&
//                resultingTextIsNumeric
//            }
//        } else if textField == form.formRowWithTag(Tags.warehouse)?.tag!
//        {
//            textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
//    
//            result = false
//        }
//        return result
//    }
    
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
                
//                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath =  
//                      form.indexPathOfFormRow(rowDescriptor), let cell = 
//                          tableView.cellForRowAtIndexPath(indexPath) {
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