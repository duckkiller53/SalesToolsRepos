//
//  MenuTableViewController.swift//
//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit



class MenuTableViewController: UITableViewController {

    @IBOutlet weak var lblHierachy: UILabel!   
    @IBOutlet weak var cellHierachy: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set how far the menu slides to the right.
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-215
        
        setTableViewBackgroundGradient(tableView, colorWithHexString("4294f4"), colorWithHexString("1861b7"))
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor = UIColor.whiteColor()
        
        // Notification for Login Controller to toggle Menu item Hierachy
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuTableViewController.getAuthority(_:)), name: adminKey, object: nil)
        
        // Disable Hierachy for non admin users.
        testAdminUser()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // This allows the background color of the cells to show through the cells.
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
    }
    
    func testAdminUser() {
        var Toggle = false
        
        if let credentials:appUser = PersistenceManager.loadObject(.Credentials) {
            
            if credentials.adminpass == "volmadmin" {
                Toggle = true
            }
        }
        
        ToggleCellHierachy(Toggle)
    }
    
    func ToggleCellHierachy(toggle: Bool) {
        
        if !toggle {
            lblHierachy.hidden = true
            cellHierachy.userInteractionEnabled = false
        } else {
            lblHierachy.hidden = false
            cellHierachy.userInteractionEnabled = true
        }
        
    }
    
    func getAuthority(notification: NSNotification) {
        if let admin = notification.userInfo?["admin"] as? Bool {
            ToggleCellHierachy(admin)
        } else {
            ToggleCellHierachy(false)
        }
    }
    
    
}
