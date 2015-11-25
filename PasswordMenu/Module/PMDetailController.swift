//
//  PMDetailController.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/20.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class PMDetailController: UITableViewController {
    private let elementTypeList = ["text", "date", "image", "password"]
    var newType : String?
    var it : Item?
    private var enableDelete = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        setupData()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.setEditing(newType != nil ? true : false, animated: false)
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    private func setupData() {
        if newType == nil {//   非新增
            return
        }
        //  新增
        if let arr = PMConfigHelper.defaultTypeList() {
            for aDic in arr {
                if aDic["category"] as? String == newType {
                    let eleList = Element.MR_importFromArray(aDic["elementList"] as? [AnyObject])
                    it = Item.MR_createEntity()
                    it!.elementList = NSMutableOrderedSet(array: eleList)
                }
            }
            
        }
        
    }
    //    func setupSubviews() {
    //        let rightButton = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain , target: self, action: Selector("save"))
    //        self.navigationItem.rightBarButtonItem = rightButton
    //    }
    //
    // MARK: - Button action
    override func setEditing(editing: Bool, animated: Bool) {   //如何区分初始代码设置和点击事件: 通过animated
        super.setEditing(editing, animated: animated)
        if !editing { // 点击保存
            if animated {
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                self.performSegueWithIdentifier("unWindToTableController", sender: nil)
            }
            self.editButtonItem().title = "编辑"
            self.tableView.userInteractionEnabled = false
        }else { //  点击编辑
            self.editButtonItem().title = "保存"
            self.tableView.userInteractionEnabled = true
            if animated {
                self.enableDelete = true
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return !self.editing ? 1 : 3 + (self.enableDelete ? 1: 0)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.editing {
            return (it?.elementList?.count)!
        }
        
        switch section {
        case 0:
            return 1
        case 1:
            return (it?.elementList?.count)!
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !self.editing {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailControllerCell", forIndexPath: indexPath) as!PMDetailControllerCell
            cell.ele = it?.elementList![indexPath.row] as? Element
            return cell
        }
        
        var cell : UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
            if let text = it?.category?.name {
                cell.textLabel?.text = text
            }else {
                cell.textLabel?.text = "请选择分类"
            }
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("DetailControllerCell", forIndexPath: indexPath) as!PMDetailControllerCell
            if let c = cell as? PMDetailControllerCell {
                c.ele = it?.elementList![indexPath.row] as? Element
                c.superController = self
            }
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("AddButtonCell", forIndexPath: indexPath)
        case 3:
            cell = tableView.dequeueReusableCellWithIdentifier("DeleteButtonCell", forIndexPath: indexPath)
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
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath {
        case NSIndexPath(forRow: 0, inSection: 2):
            let ac = UIAlertController(title: "选择类型", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            for eleType in elementTypeList {
                ac.addAction(UIAlertAction(title: eleType, style: UIAlertActionStyle.Default, handler: {[unowned self] (alertAction: UIAlertAction) -> Void in
                    let ele = ModelFactory.element(alertAction.title!)
                    ele.item = self.it
                    self.it?.elementList?.addObject(ele)
                    self.tableView.reloadData()
                    }))
            }
            ac.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction:UIAlertAction) -> Void in
            }))
            self.presentViewController(ac, animated: true, completion:nil)
        case NSIndexPath(forRow: 0, inSection: 3):
            let ac = UIAlertController(title: "确认删除", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            ac.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: {[unowned self] (alertAction: UIAlertAction) -> Void in
                self.it?.MR_deleteEntity()
                self.performSegueWithIdentifier("unWindToTableController", sender: nil)
                }))
            ac.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction:UIAlertAction) -> Void in
            }))
            self.presentViewController(ac, animated: true, completion:nil)
        default:
            break
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 2 || indexPath == NSIndexPath(forRow: 0, inSection: 1) || indexPath == NSIndexPath(forRow: 1, inSection: 1) || indexPath.section == 0 || indexPath.section == 3 {
            return false
        }
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            it?.elementList?.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        it?.elementList?.moveObjectsAtIndexes(NSIndexSet(index: fromIndexPath.row), toIndex: toIndexPath.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 2 || indexPath == NSIndexPath(forRow: 0, inSection: 1) || indexPath == NSIndexPath(forRow: 1, inSection: 1) || indexPath.section == 0 || indexPath.section == 3 {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.section == 2 {
            let count = tableView.numberOfRowsInSection(1)
            return NSIndexPath(forRow: count - 1, inSection: 1)
        }else if proposedDestinationIndexPath == NSIndexPath(forRow: 0, inSection: 1) || proposedDestinationIndexPath == NSIndexPath(forRow: 1, inSection: 1) {
            return NSIndexPath(forRow: 2, inSection: 1)
        }else if proposedDestinationIndexPath.section == 0 {
            return NSIndexPath(forRow: 2, inSection: 1)
        }
        return proposedDestinationIndexPath
    }
    
    //    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    //        return UITableViewCellEditingStyle.Delete
    //    }
    
    // MARK: - Segue
    @IBAction func unwindToPMDetailController(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(PMCategorySelectionController) {
        tableView .reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        if segue.sourceViewController.isKindOfClass(PMPasswordGeneratorController) {
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
