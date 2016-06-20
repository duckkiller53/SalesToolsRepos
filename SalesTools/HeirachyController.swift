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

class HeirachyController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
   
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
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
    @IBOutlet weak var btnReport: UIButton!
    var notConnectedBanner: Banner?
    var hierachResult = [hierachy]()
    var textTag = 0
    var results = [String]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // remove the inset to tableview due to nav controller
        self.automaticallyAdjustsScrollViewInsets = false
        
        //clearForm()
        
        if  self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        pickerView.hidden = true
        self.ActivityIndicator.hidden = true
        self.ActivityIndicator.stopAnimating()        
        toggleReportControls(true)        
        txtRep.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Setup Nav bar color scheme
        colorizeNavBar(self.navigationController!.navigationBar)
        
        // Create BackGround Gradient to display data.
        drawBackGroundGradient(self, topColor: colorWithHexString("4294f4"), bottomColor: colorWithHexString("1861b7"))
        
    }
    
    /*
        Note:  To use this funciton you need to reference UITextFieldDelegate
               in the class, and make the controller the delegate for the text
               box's that you want this function to be called for. 
            
               To set the controller as the delegate to a Control like a textField,
               you can either drag each textField to the controller or call
               self.TextField.delegate = self. in ViewDidLoad().
    */
    func textFieldDidBeginEditing(textField: UITextField)
    {
      if textField.tag != 6
      {
            self.ActivityIndicator.hidden = false
            self.ActivityIndicator.startAnimating()
            
            toggleReportControls(true)
            
            switch (textField.tag)
            {
            case 1:
                textTag = 1
                
                getHierachy(["1", "", "", "", ""])
                pickerView.hidden = false
                
                txtHeirachy2.text = ""
                txtHeirachy3.text = ""
                txtHeirachy4.text = ""
            case 2:
                textTag = 2
                
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
                
                txtHeirachy3.text = ""
                txtHeirachy4.text = ""
            case 3:
                textTag = 3
                
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
                
                txtHeirachy4.text = ""
            case 4:
                textTag = 4
                
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
                
            case 5:
                textTag = 5
                
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
                
            default:
                print("Bad textField Tag")
                pickerView.hidden = true
            }
            
            
            self.ActivityIndicator.hidden = true
            self.ActivityIndicator.stopAnimating()
        }
    }
    
    @IBAction func btnExport(sender: AnyObject)
    {
        pickerView.hidden = true
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
    

    // MARK: Utility functions
    
    func toggleReportControls(toggle: Bool)
    {
        lblAllReps.hidden = toggle
        toggleReps.hidden = toggle
        txtRep.hidden = toggle
        btnReport.hidden = toggle
        txtRep.text = ""
    }
    
    // Fires when user clicks on ViewController.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        pickerView.hidden = true
        
        switch (textTag)
        {
        case 1:
            txtHeirachy1.resignFirstResponder()
        case 2:
            txtHeirachy2.resignFirstResponder()
        case 3:
            txtHeirachy3.resignFirstResponder()
        case 4:
            txtHeirachy4.resignFirstResponder()
        default:
            print("Bad textField Tag")
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
