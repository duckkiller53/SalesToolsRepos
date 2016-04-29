//
//  ARBalanceDetail.swift
//  SalesTools
//
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import UIKit

class ARBalanceLineItem: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblLineItems: UILabel!
    
    var lineitems = [LineItem]()
    var ordernum: String?
    var numlines: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove the inset to tableview due to nav controller
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Set background of the tableview and hide cell seperator lines
        let backgroundImage = UIImage(named: "tv_background.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.view.backgroundColor = colorWithHexString("4092f2")
        
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        self.tableView.separatorColor = UIColor.redColor()
        
        setControlColors(UIColor.whiteColor())
        lblLineItems.text = "Number of lines: " + numlines!
    }
    
    
    
    // MARK:  TableView methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineitems.count
    }
    
    
    // Set the data for the cell.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if lineitems.count > 0
        {
            let r = lineitems[indexPath.row]
            
            cell.textLabel?.text = "Qty: " + "(\(Int(r.qty)))      " + "Prod: " + r.prod
            cell.detailTextLabel!.text = r.descrip.trunc(50)
        }
        
        // This allows the background color of the cells to show through the cells.
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        
        
       return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ardetail"
        {
            if let destinationVC = segue.destinationViewController as? ARBalanceDetail
            {
                let selectedRow = tableView.indexPathForSelectedRow!.row
                destinationVC.lineItem = lineitems[selectedRow]
            }
        }
    }
    
    func setControlColors(color: UIColor)
    {
        // Set display colors
        lblLineItems.textColor = color
    }


}

//class Drawing: UIView {
//    
//    override func drawRect(rect: CGRect) {
//        
//        // Set of the context for drawing
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSetLineWidth(context, 3.0)
//        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
//        
//        // Create a path
//        CGContextMoveToPoint(context, 0, 30)
//        CGContextAddLineToPoint(context, UIScreen.mainScreen().bounds.width, 30)
//        
//        // Draw the path
//        CGContextStrokePath(context)
//    }
//    
//}
