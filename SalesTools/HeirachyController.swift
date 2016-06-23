//
//  HeirachyController.swift
//  SalesTools
//
//  Created by David LaPorte on 6/7/16.
//  Copyright © 2016 David LaPorte. All rights reserved.
//

import UIKit
import Alamofire
import BRYXBanner
import QuickLook

class HeirachyController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate
{
   
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var keyboardDismissTapGesture: UIGestureRecognizer?
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var txtHeirachy1: UITextField!
    @IBOutlet weak var txtHeirachy2: UITextField!
    @IBOutlet weak var txtHeirachy3: UITextField!
    @IBOutlet weak var txtHeirachy4: UITextField!    
    @IBOutlet weak var txtHeirachy5: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lblAllReps: UILabel!
    @IBOutlet weak var toggleReps: UISwitch!
    @IBOutlet weak var txtRep: UITextField!    
    @IBOutlet weak var btnExport: UIButton!
    
    var notConnectedBanner: Banner?
    var hierachResult = [hierachy]()
    var textTag = 0
    var results = [String]()
    var path: NSURL?
    var salesRep: String?
    
    @IBAction func btnHierachy1(sender: AnyObject) {
        
        self.ActivityIndicator.hidden = false
        self.ActivityIndicator.startAnimating()
        toggleReportControls(true)
        
        textTag = 1
        txtHeirachy1.text = ""
        
        getHierachy(["1", "", "", "", ""])
        pickerView.hidden = false
        clearSelections(1)
        
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()
    }
    
    @IBAction func btnHierachy2(sender: AnyObject) {
        
        self.ActivityIndicator.hidden = false
        self.ActivityIndicator.startAnimating()
        toggleReportControls(true)


        textTag = 2
        txtHeirachy2.text = ""
        
        if txtHeirachy1.text != ""
        {
            // load values for heirachy2
            let val = txtHeirachy1.text!
            getHierachy(["2", val, "", "", ""])
            pickerView.hidden = false
        }
        else {
            pickerView.hidden = true
        }
        
        clearSelections(2)
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()

    }
    
    @IBAction func btnHierachy3(sender: AnyObject) {
        
        self.ActivityIndicator.hidden = false
        self.ActivityIndicator.startAnimating()
        toggleReportControls(true)


        
        textTag = 3
        txtHeirachy3.text = ""
        
        if txtHeirachy2.text != ""
        {
            // load values for heirachy3
            let val1 = txtHeirachy1.text!
            let val2 = txtHeirachy2.text!
            getHierachy(["3", val1, val2, "", ""])
            pickerView.hidden = false
            
        } else {
            pickerView.hidden = true
        }
        
        clearSelections(3)
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()
    }
    
    @IBAction func btnHierachy4(sender: AnyObject) {
        
        self.ActivityIndicator.hidden = false
        self.ActivityIndicator.startAnimating()
        toggleReportControls(true)

        
        textTag = 4
        txtHeirachy4.text = ""
        
        if txtHeirachy3.text != ""
        {
            // load values for heirachy4
            let val1 = txtHeirachy1.text!
            let val2 = txtHeirachy2.text!
            let val3 = txtHeirachy3.text!
            getHierachy(["4", val1, val2, val3, ""])
            pickerView.hidden = false
            
        } else {
            pickerView.hidden = true
        }
        
        clearSelections(4)
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()
    }
    
    @IBAction func btnHierachy5(sender: AnyObject) {
        
        self.ActivityIndicator.hidden = false
        self.ActivityIndicator.startAnimating()
        toggleReportControls(true)

        
        textTag = 5
        txtHeirachy5.text = ""

        if txtHeirachy4.text != ""
        {
            // load values for heirachy4
            let val1 = txtHeirachy1.text!
            let val2 = txtHeirachy2.text!
            let val3 = txtHeirachy3.text!
            let val4 = txtHeirachy4.text!
            getHierachy(["5", val1, val2, val3, val4])
            pickerView.hidden = false

        } else {
            pickerView.hidden = true
        }
        
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()

    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // remove the inset to tableview due to nav controller
        self.automaticallyAdjustsScrollViewInsets = false
        txtRep.delegate = self
        
        //clearForm()
        
        if  self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // add observer to dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(LogIn.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogIn.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        initForm()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
        
    }
    
    @IBAction func btnExport(sender: AnyObject)
    {
        pickerView.hidden = true
        
        let salesRep = toggleReps.on  && txtRep.text != "" ? txtRep.text : "ALL"
        let category = txtHeirachy5.text! != "" ? txtHeirachy5.text : ""
        
        ExportToCSV(salesRep!, prodcat: category!)
    }
    
    @IBAction func toggleReps(sender: AnyObject) {
        
        if toggleReps.on {
            txtRep.text = ""
            txtRep.hidden = false
        } else {
            txtRep.hidden = true
        }
    }

    
       
    // MARK: GET API DATA
    
    func getHierachy(params: [String])
    {
        
        let completionHandler: (Result<[hierachy], NSError>) -> Void =
            { (result) in
                
                self.ActivityIndicator.hidden = true
                self.ActivityIndicator.stopAnimating()
                
                // Test if error is unauthorized or no connection
                guard result.error == nil else
                {
                    print(result.error)
                    
                    if let error = result.error
                    {
                        if error.domain == NSURLErrorDomain
                        {
                            // If we already are showing a banner, dismiss it and create new
                            if let existingBanner = self.notConnectedBanner
                            {
                                existingBanner.dismiss()
                            }
                            
                            if error.code == NSURLErrorUserAuthenticationRequired
                            {
                                self.notConnectedBanner = Banner(title: "Login Failed",
                                                                 subtitle: "Please login and try again",
                                                                 image: nil,
                                                                 backgroundColor: UIColor.orangeColor())
                                
                            } else if error.code == NSURLErrorNotConnectedToInternet {
                                
                                self.notConnectedBanner = Banner(title: "No Internet Connection",
                                                                 subtitle: "Could not load data." +
                                    " Try again when you're connected to the internet",
                                                                 image: nil,
                                                                 backgroundColor: UIColor.redColor())
                            }
                            
                            self.notConnectedBanner?.dismissesOnSwipe = true
                            self.notConnectedBanner?.show(duration: nil)
                        }
                        
                    }
                    
                    self.showAlert("No results were found!")
                    self.txtHeirachy1.becomeFirstResponder()
                    return
                }
                
                // No Errors Load Data
                if let fetchedResults = result.value {
                    if fetchedResults.count > 0
                    {
                        self.hierachResult = fetchedResults
                        self.LoadControls(self.hierachResult)
                        
                    } else
                    {
                        self.showAlert("No results were found!")
                    }
                }
                
        }
        
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.getHierachy(params, completionHandler: completionHandler)
        
    }
    
    
    
    // ExportToCSV
    func ExportToCSV(rep: String, prodcat: String)
    {
        
        let completionHandler: (Result<NSURL, NSError>) -> Void =
            { (result) in
                
                
                self.ActivityIndicator.hidden = true
                self.ActivityIndicator.stopAnimating()
                
                // Test if error is unauthorized or no connection
                guard result.error == nil else
                {
                    print("Bad file path")
                    
                    if let error = result.error
                    {
                        if error.domain == NSURLErrorDomain
                        {
                            // If we already are showing a banner, dismiss it and create new
                            if let existingBanner = self.notConnectedBanner
                            {
                                existingBanner.dismiss()
                            }
                            
                            if error.code == NSURLErrorUserAuthenticationRequired
                            {
                                self.notConnectedBanner = Banner(title: "Login Failed",
                                                                 subtitle: "Please login and try again",
                                                                 image: nil,
                                                                 backgroundColor: UIColor.orangeColor())
                                
                            } else if error.code == NSURLErrorNotConnectedToInternet {
                                
                                self.notConnectedBanner = Banner(title: "No Internet Connection",
                                                                 subtitle: "Could not load data." +
                                    " Try again when you're connected to the internet",
                                                                 image: nil,
                                                                 backgroundColor: UIColor.redColor())
                            }
                            
                            self.notConnectedBanner?.dismissesOnSwipe = true
                            self.notConnectedBanner?.show(duration: nil)
                        }
                        
                    }
                    
                    return
                }
                
                // No Errors Load Data
                if let URL = result.value {
                    self.path = URL
                } else {
                    self.path = nil
                    self.showAlert("Error Createing file!")
                    return
                }
                
                // Note: pushViewController loads it on stack.
                
                let preview = QLPreviewController()
                preview.dataSource = self
                self.navigationController?.pushViewController(preview, animated: true)
        }
        
        ActivityIndicator.startAnimating()
        ActivityIndicator.hidden = false
        
        APIManager.sharedInstance.ExportSalesByCategory(rep, category: prodcat, completionHandler: completionHandler)
        
    }

    
    func LoadControls(result: [hierachy])
    {
        // clear results
        self.results = [String]()
        
        for value: hierachy in result {
            self.results.append(value.value1)
        }
        
        self.pickerView.reloadAllComponents()
    }

   
    
    // Set PickerView Font color
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = results[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
    // MARK:  PicerView delegate functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return results.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return results[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch (textTag)
        {
        case 1:
            txtHeirachy1.text = results[row]
        case 2:
            txtHeirachy2.text = results[row]
        case 3:
            txtHeirachy3.text = results[row]
        case 4:
            txtHeirachy4.text = results[row]
        case 5:
            txtHeirachy5.text = results[row]
            txtHeirachy5.resignFirstResponder()
            toggleReportControls(false)
            pickerView.hidden = true

        default:
            pickerView.hidden = true
        }
    }
    
    
    // MARK:  Quick View Controller
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        
        return self.path!
    }
    
    // MARK:  Hide KeyBoard code
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(LogIn.dismissKeyboard(_:)))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardDismissTapGesture != nil
        {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    func dismissKeyboard(sender: AnyObject) {
        
        if txtRep.isFirstResponder()
        {
            txtRep.resignFirstResponder()
        }         
    }
    


    // MARK: Utility functions
    
    func initForm()
    {        
        pickerView.hidden = true
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()
        
        txtHeirachy1.userInteractionEnabled = false
        txtHeirachy2.userInteractionEnabled = false
        txtHeirachy3.userInteractionEnabled = false
        txtHeirachy4.userInteractionEnabled = false
        txtHeirachy5.userInteractionEnabled = false
        
        toggleReportControls(true)
    }
    
    func toggleReportControls(toggle: Bool)
    {
        lblAllReps.hidden = toggle
        toggleReps.hidden = toggle
        toggleReps.on = false
        btnExport.hidden = toggle
        txtRep.text = ""
        txtRep.hidden = true
    }
    
    func clearSelections(level: Int) {
        switch (level)
        {
        case 1:
            txtHeirachy2.text = ""
            txtHeirachy3.text = ""
            txtHeirachy4.text = ""
            txtHeirachy5.text = ""
        case 2:
            txtHeirachy3.text = ""
            txtHeirachy4.text = ""
            txtHeirachy5.text = ""
        case 3:
            txtHeirachy4.text = ""
            txtHeirachy5.text = ""
        case 4:
            txtHeirachy5.text = ""
        default:
            txtHeirachy1.text = ""
            txtHeirachy2.text = ""
            txtHeirachy3.text = ""
            txtHeirachy4.text = ""
            txtHeirachy5.text = ""
        }
        
    }
    
    // Only allow alpha in txtRep
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        // Find out what the text field will be after adding the current edit
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if text.containsOnlyLetters() {
            return true
        } else {
            return false
        }
    }
    
    func showAlert(msg: String)
    {
        let myAlert = UIAlertController(title:"SalesTools", message: msg, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion:nil);
        }
        
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated:true, completion:nil);
    }
    
    func drawBackGroundGradient(sender: AnyObject, topColor: UIColor, bottomColor: UIColor)
    {
        let background = CreateGradient(topColor, bottomColor: bottomColor)
        background.frame = self.view.bounds
        sender.view!!.layer.insertSublayer(background, atIndex: 0)
    }


}
