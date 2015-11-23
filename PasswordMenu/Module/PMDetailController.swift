//
//  PMDetailController.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/20.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class PMDetailController: UITableViewController {
    var it : Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //    func setupSubviews() {
    //        let rightButton = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain , target: self, action: Selector("save"))
    //        self.navigationItem.rightBarButtonItem = rightButton
    //    }
    //
    //    // MARK: - Button action
    //    func save() {
    //        print("save")
    //    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (it?.elementList?.count)!
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("DetailControllerCell", forIndexPath: indexPath) as!PMDetailControllerCell
            if let c = cell as? PMDetailControllerCell {
                if let ele = it?.elementList![indexPath.row] as? Element {
                    if let lt = ele.leftText {
                        c.leftLabel.text = "\(lt)"
                    }
                    if let rt = ele.rightText {
                        c.rightField.text = "\(rt)"
                    }
                }
            }
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("AddButtonCell", forIndexPath: indexPath)
        default:
            cell = UITableViewCell()
            break
        }
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath {
        case NSIndexPath(forRow: 0, inSection: 1):
            print("add button")
            let ac = UIAlertController(title: "选择类型", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let aa1 = UIAlertAction(title: "abc", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
            })
            let aa2 = UIAlertAction(title: "def", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
            })
            let aa3 = UIAlertAction(title: "ghi", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
            })
            let aa4 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            })
            ac.addAction(aa1)
            ac.addAction(aa2)
            ac.addAction(aa3)
            ac.addAction(aa4)
            self.presentViewController(ac, animated: true, completion: { () -> Void in
                
            })
        default:
            break
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        }
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.section == 1 {
            let count = tableView.numberOfRowsInSection(0)
            return NSIndexPath(forRow: count - 1, inSection: 0)
        }
        return proposedDestinationIndexPath
    }
    
    //    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    //        return UITableViewCellEditingStyle.Delete
    //    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
