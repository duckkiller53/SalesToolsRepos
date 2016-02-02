//
//  ConTable.swift
//  SalesTools
//
//  Created by William Volm on 1/30/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class ConTable: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    // Observer Property
    var items: [custProd] = [] {
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
        
                cell.textLabel?.text = r._prod
                cell.detailTextLabel!.text = r._descrip1! + " " + r._descrip2!
            }
            
            return cell
        }


}
