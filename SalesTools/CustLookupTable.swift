//
//  CustLookupTable.swift
//  SalesTools
//
//  Created by William Volm on 2/25/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class CustLookupTable: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Observer Property
    var items: [customer] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background of the tableview and hide cell seperator lines
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
            
            cell.textLabel?.text = "\(Int(r.custnum))"
            cell.detailTextLabel!.text = r.custName!
        }
        
        // This allows the background color of the cells to show through the cells.
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "custDetail"
        {
            if let destinationVC = segue.destinationViewController as? CustLookupDetail
            {
                let selectedRow = tableView.indexPathForSelectedRow!.row
                destinationVC.Customer = items[selectedRow]
            }
            
            
            
        }
    }


}
