//
//  PMTableController.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/17.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class PMTableController: UITableViewController {
    var dataArray = NSMutableOrderedSet() {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableControllerCell", forIndexPath: indexPath)
        
        // Configure the cell...
        if let it = dataArray[indexPath.row] as? Item {
            if let ele = it.elementList?.objectAtIndex(0) as? Element {
                cell.textLabel?.text = ele.leftText
            }
        }
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dvc = segue.destinationViewController as? PMDetailController {
            if ((sender?.isKindOfClass(UIBarButtonItem.self)) != false) {
                let path = NSBundle.mainBundle().pathForResource("template", ofType: "json")
                do {
                    let data = NSData(contentsOfFile: path!)
                    if let arr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray {
                        for aDic in arr {
                            if aDic["category"] as? String == "website" {
                                let eleList = Element.MR_importFromArray(aDic["elementList"] as? [AnyObject])
                                dvc.it = Item.MR_createEntity()
                                dvc.it!.elementList = NSMutableOrderedSet(array: eleList)
                            }
                        }
                        
                    }
                } catch {
                    print("read Template fail")
                }
            }
        }
    }
    
    
}
