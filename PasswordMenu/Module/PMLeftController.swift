//
//  PMLeftController.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/17.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit
import SnapKit
import MagicalRecord
class PMLeftController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var catList : NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.snp_updateConstraints { (make) -> Void in
            make.width.equalTo(self.view.snp_width).multipliedBy(0.75)
        }
    }
    
    func setupData() {
        catList = NSMutableArray(array: Category.MR_findAll())
    }
    
    // MARK: - Button Action
    @IBAction func addNewCategory(sender: UIButton) {
        let ac = UIAlertController(title: "新建分类名", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        ac.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            
        }
        ac.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { [unowned self](alertAction: UIAlertAction) -> Void in
            guard var name = ac.textFields?.first?.text else {
                return
            }
            name = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            guard let list = self.catList else {
                return
            }
            for cat in list {
                if cat.name == name {
                    return
                }
            }
            
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                let cat = Category.MR_createEntityInContext(localContext)
                if let textField = ac.textFields?.first {
                    cat.name = textField.text
                }
                }, completion: { [unowned self](success: Bool, error: NSError!) -> Void in
                    self.setupData()
                    self.tableView.reloadData()
                })
            }))
        ac.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction:UIAlertAction) -> Void in
        }))
        self.presentViewController(ac, animated: true, completion:nil)
    }
    
    @IBAction func settingButtonAction(sender: UIButton) {
        if let settingNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingNavigationController") as? PMNavigationController {
            self.showViewController(settingNavigationController, sender: sender)
        }
    }
    @IBAction func EditButtonAction(sender: UIButton) {
        sender.selected = !sender.selected
        tableView.editing = sender.selected
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catList!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftControllerCell", forIndexPath: indexPath)
        
        // Configure the cell...
        if let cat = catList![indexPath.row] as? Category {
            cell.textLabel?.text = cat.name
            
            cell.detailTextLabel?.text = "\(cat.itemList!.count)"
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let nc = self.sideMenuViewController.contentViewController as? UINavigationController {
            if let itemListController = nc.viewControllers[0] as? PMItemListController {
                if let cat = catList![indexPath.row] as? Category {
                    itemListController.cat = cat
                }
            }
        }
        self.sideMenuViewController.hideMenuViewController()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return NSBundle.mainBundle().loadNibNamed("LeftControllerSecitonFooter", owner: self, options: nil).last as? UIButton
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return NSBundle.mainBundle().loadNibNamed("LeftControllerSectionHeader", owner: self, options: nil).last as? UIView
    }
    
    // MARK: Edition
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
                        self.setupData()
                        self.tableView.reloadData()
                        // todo better animation,if use code below, the section footer will misplace
//                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
            }))
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction:UIAlertAction) -> Void in
            }))
            self.showViewController(alertController, sender: nil)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
    // Override to support rearranging the table view.
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return false
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
