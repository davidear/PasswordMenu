//
//  PMCategoryEditController.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 16/2/3.
//  Copyright © 2016年 DaiFengyi. All rights reserved.
//

import UIKit
import MagicalRecord
class PMCategoryEditController: UITableViewController {
    var catList: NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setupData() {
        catList = NSMutableArray(array: Category.MR_findAll())
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (catList?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        if let cat = catList![indexPath.row] as? Category {
            cell.textLabel?.text = cat.name
            
            cell.detailTextLabel?.text = "\(cat.itemList!.count)"
            
        }
        return cell
    }
    
    // MARK: Edition
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let alertController = UIAlertController(title: "请输入“Delete”确认删除", message: "该分类及其所属的密码将被删除", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField) -> Void in
                
            })
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (alertAction: UIAlertAction) -> Void in
                if alertController.textFields?.first?.text != "Delete" {
                    return
                }
                guard let cat = self.catList![indexPath.row] as? Category else{
                    return
                }
                MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                    cat.MR_deleteEntityInContext(localContext)
                    }, completion: { (success: Bool, error: NSError!) -> Void in
                        if success {
                            NSNotificationCenter.defaultCenter().postNotificationName("kRefreshData", object: nil)
                            self.setupData()
                            self.tableView.reloadData()
                        }
                        // todo better animation,if use code below, the section footer will misplace
                        //                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            }))
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction:UIAlertAction) -> Void in
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
