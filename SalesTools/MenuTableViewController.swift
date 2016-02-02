//
//  MenuTableViewController.swift
//  SideBarMenuExample
//
//  Created by William Volm on 1/13/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set how far the menu slides to the right.
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-215

    }
    
}
