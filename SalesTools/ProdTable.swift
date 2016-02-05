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
    
    // Observer Property
    var items: [salesProd] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail"
        {
            if let destinationVC = segue.destinationViewController as? ProductDetail
            {
                let selectedRow = tableView.indexPathForSelectedRow!.row
                destinationVC.Product = items[selectedRow]
            }
            
        }
    }


}
