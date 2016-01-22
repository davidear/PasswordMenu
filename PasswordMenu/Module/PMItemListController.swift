//
//  PMItemListController.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/17.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//
/// PMDetailController通过NSNotification来通知更新数据源
/// PMLeftController通过setter更新数据源
import UIKit

class PMItemListController: UITableViewController {
    var cat: Category? {
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
        addNotificationCenterObservers()
    }
    
    deinit {
        removeNotificationCenterObservers()
    }
    @IBAction func AddNewItem(sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "新增类型", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        if let arr = PMConfigHelper.defaultTypeList() {
            for dic in arr {
                ac.addAction(UIAlertAction(title: dic["category"] as? String, style: UIAlertActionStyle.Default, handler: {[unowned self] (alertAction: UIAlertAction) -> Void in
                    let dvc = self.storyboard?.instantiateViewControllerWithIdentifier("PMDetailController") as!PMDetailController
                    dvc.newType = alertAction.title
                    self.showViewController(dvc, sender: sender)
                }))
            }
        }
        ac.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            }))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    func addNotificationCenterObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: NSSelectorFromString("refreshData"), name: "kRefreshData", object: nil)
    }
    func removeNotificationCenterObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func refreshData() {
        if let c = cat {
            cat = Category.MR_findFirstByAttribute("name", withValue: c.name)
            self.tableView.reloadData()
        }else {
//            cat = Category.MR_findAll()
        }
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let c = cat {
            return c.itemList!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PMItemListControllerCell", forIndexPath: indexPath)
        
        // Configure the cell...
        if let it = cat?.itemList![indexPath.row] as? Item {
            if let ele = it.elementList?.objectAtIndex(0) as? Element {
                cell.textLabel?.text = ele.rightText
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
            dvc.it = cat?.itemList![tableView.indexPathForCell(sender as! UITableViewCell)!.row] as? Item
        }
    }
    
    @IBAction func unWindToItemListController(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(PMDetailController.self) {
            NSNotificationCenter.defaultCenter().postNotificationName("kRefreshData", object: nil)
        }
    }
    
}
