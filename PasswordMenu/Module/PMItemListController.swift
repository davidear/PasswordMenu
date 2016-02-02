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
class PMItemListCell: UITableViewCell {
    var indexPath: NSIndexPath?
}
class PMItemListController: UITableViewController {
    var catList : NSMutableArray?
    var expansionList : Array<Bool>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catList = NSMutableArray(array: Category.MR_findAll())
        expansionList = Array(count: (catList?.count)!, repeatedValue: false)
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
        catList = NSMutableArray(array: Category.MR_findAll())
        self.tableView.reloadData()
    }
    
    // MARK: - Button Action
    @IBAction func setting(sender: UIBarButtonItem) {
        if let settingNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingNavigationController") as? PMNavigationController {
            self.showViewController(settingNavigationController, sender: sender)
        }
    }
    func sectionHeaderClick(sender: UIButton) {
        expansionList![sender.tag] = !expansionList![sender.tag]
        tableView.reloadSections(NSIndexSet(index: sender.tag), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let count = catList?.count {
            return count
        }
        return 0
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "hello,world"
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expansionList![section] == false {
            return 0
        }
        if let c = catList?[section] as? Category {
            if let count = c.itemList?.count {
                return count
            }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let btn = UIButton(frame:CGRectMake(0,0,0,44))
//        btn.backgroundColor = UIColor.blueColor()
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
//        btn.titleLabel?.textAlignment = NSTextAlignment.Left
        btn.titleLabel?.font = UIFont.systemFontOfSize(12)
        if let cat = catList?[section] as? Category {
            btn .setTitle(cat.name, forState: UIControlState.Normal)
        }
        btn.addTarget(self, action: NSSelectorFromString("sectionHeaderClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = section
        return btn
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PMItemListControllerCell", forIndexPath: indexPath)
        if let cat = catList?[indexPath.section] as? Category {
            if let it = cat.itemList![indexPath.row] as? Item {
                if let ele = it.elementList?.objectAtIndex(0) as? Element {
                    cell.textLabel?.text = ele.rightText
                }
            }
        }
        if let c = cell as? PMItemListCell {
            c.indexPath = indexPath
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
            if let cat = catList?[(sender?.indexPath.section)!] as? Category {
                if let it = cat.itemList?[(sender?.indexPath.row)!] as? Item {
                    dvc.it = it
                }
            }
        }
    }
    
    @IBAction func unWindToItemListController(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(PMDetailController.self) {
            NSNotificationCenter.defaultCenter().postNotificationName("kRefreshData", object: nil)
        }
    }
    
}
