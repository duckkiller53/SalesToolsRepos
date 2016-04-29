//
//  ProdTable.swift
//  SalesTools
//
//  Created by William Volm on 2/4/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class ProdTable: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var keyboardDismissTapGesture: UIGestureRecognizer?

    
    // Observer Property
    var items: [salesProd] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var prodNum: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // add observer to dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ProdTable.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProdTable.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        // Set background of the tableview and hide cell seperator lines
//        setTableViewBackgroundGradient(tableView, colorWithHexString("4294f4"), colorWithHexString("1861b7"))
        
        
        let backgroundImage = UIImage(named: "tv_background.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

       
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor = UIColor.redColor()
    }
    
    
        
    // MARK:  TableView methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    // Set the data for the cell.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if items.count > 0
        {
            let r = items[indexPath.row]
            
            cell.textLabel?.text = "Order Number: " + "\(r.ordNum)"
            cell.detailTextLabel!.text = "\(r.custNum)" + " " + r.custName
        }
        
        // This allows the background color of the cells to show through the cells.
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        
         // code for alternating row colors.
//        if(indexPath.row % 2 == 0){
//            cell.backgroundColor = colorWithHexString("#0f4380")
//        } else{
//            cell.backgroundColor = colorWithHexString("#175c99")
//        }

        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // dismiss the keyboard, if, after the tableview is loaded, the user
        // set's focus to the textbox (where the keyboard is displayed) and
        // the clicks on a cell.
        self.parentViewController!.navigationController!.view.endEditing(true)
       
        
        if segue.identifier == "showDetail"
        {
            if let destinationVC = segue.destinationViewController as? ProductDetail
            {
                let selectedRow = tableView.indexPathForSelectedRow!.row
                destinationVC.Product = items[selectedRow]
                destinationVC.prodNum = prodNum
            }
            
        }
    }    
    
    
    // MARK:  Hide KeyBoard code
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProdTable.dismissKeyboard(_:)))
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
        self.parentViewController!.navigationController!.view.endEditing(true)
    }



}
