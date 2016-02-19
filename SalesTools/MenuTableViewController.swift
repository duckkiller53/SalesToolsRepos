//
//  MenuTableViewController.swift//
//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set how far the menu slides to the right.
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-215
        
        setTableViewBackgroundGradient(tableView, colorWithHexString("4294f4"), colorWithHexString("1861b7"))
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor = UIColor.whiteColor() 

    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // This allows the background color of the cells to show through the cells.
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
    }
    
    
}
