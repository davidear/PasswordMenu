//
//  PMCategorySelectionController.swift
//  PasswordMenu
//
//  Created by dai.fy on 15/11/24.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class PMCategorySelectionController: UITableViewController {
    var catList: NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        setupData()
    }
    
    func setupData() {
        catList = NSMutableArray(array: Category.MR_findAll())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (catList != nil) ? (catList?.count)! : 0
        }else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("CategorySelectionCell", forIndexPath: indexPath)
            if let cat = catList![indexPath.row] as? Category {
                cell.textLabel?.text = cat.name
            }
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("CategoryAddCell", forIndexPath: indexPath)
        default:
            cell = UITableViewCell()
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
                    self.performSegueWithIdentifier("unwindToPMDetailController", sender: ac.textFields?.first)
                })
            }))
        ac.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction:UIAlertAction) -> Void in
        }))
        self.presentViewController(ac, animated: true, completion:nil)
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
        if let vc = segue.destinationViewController as? PMDetailController {
            if let cell = sender as? UITableViewCell {
                let cat = Category.MR_findFirstByAttribute("name", withValue: cell.textLabel!.text)
                vc.it?.category = cat
            }else if let textField = sender as? UITextField {
                let cat = Category.MR_findFirstByAttribute("name", withValue: textField.text)
                vc.it?.category = cat
            }
        }
    }
    
    
}
