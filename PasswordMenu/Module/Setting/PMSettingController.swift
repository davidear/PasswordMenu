//
//  PMSettingController.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 16/2/3.
//  Copyright © 2016年 DaiFengyi. All rights reserved.
//

import UIKit
import VENTouchLock
class PMSettingSwitchCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let switchButton = UISwitch()
        self.accessoryView = switchButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PMSettingController: MMTableViewController {
    let ReuseIdentifier = "Cell"
    let SwitchReuseIdentifier = "SwitchCell"
    var dataArray: NSArray?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func loadData() {
        let path = NSBundle.mainBundle().pathForResource("SettingList", ofType: "plist")
        dataArray =  NSArray(contentsOfFile: path!)
    }
    
    func setUI() {
        tableView.registerClass(PMSettingSwitchCell.self, forCellReuseIdentifier: SwitchReuseIdentifier)
        let header = UILabel(frame: CGRectMake(0, 0, 0, 21))
        header.text = "指纹识别仅在已设置密码情况下才能开启"
        header.textAlignment = NSTextAlignment.Center
        header.font = UIFont.systemFontOfSize(13)
        tableView.tableHeaderView = header
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1;
        } else {
            return (dataArray?.count)!;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier, forIndexPath: indexPath)
            cell?.textLabel?.text = "编辑分类"
        }else {
            if indexPath.row < 2 {
                cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier, forIndexPath: indexPath)
            }else {
                cell = tableView.dequeueReusableCellWithIdentifier(SwitchReuseIdentifier, forIndexPath: indexPath)
                if let switchButton = cell?.accessoryView as? UISwitch {
                    switchButton.addTarget(self, action: NSSelectorFromString("switchValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
                    switchButton.enabled = VENTouchLock.sharedInstance().isPasscodeSet() && VENTouchLock.canUseTouchID()
                    switchButton.on = VENTouchLock.shouldUseTouchID()
                }
            }
            
            cell?.textLabel?.text = dataArray?[indexPath.row]["title"] as? String
            if indexPath.row == 0 && VENTouchLock.sharedInstance().isPasscodeSet() {
                cell?.textLabel?.text = dataArray?[indexPath.row]["title2"] as? String
            }
        }
        return cell!
    }
    
    // MARK: - Button Action
    func switchValueChanged(sender: UISwitch) {
        VENTouchLock.setShouldUseTouchID(sender.on)
    }
    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let cec = self.storyboard?.instantiateViewControllerWithIdentifier("PMCategoryEditController")
            self.navigationController?.pushViewController(cec!, animated: true)
        }else {
            if indexPath.row == 0 {
                if VENTouchLock.sharedInstance().isPasscodeSet() {
                    let vc = VENTouchLockEnterPasscodeViewController()
                    vc.willFinishWithResult = { (success: Bool) -> Void in
                        if success {
                            let createVC = VENTouchLockCreatePasscodeViewController()
                            self.navigationController?.pushViewController(createVC, animated: true)
                        }
                    }
                    let nvc = MMNavigationController(rootViewController: vc)
                    self.presentViewController(nvc, animated: true, completion: nil)
                }else { // 未设置密码
                    let vc = VENTouchLockCreatePasscodeViewController()
                    let nvc = MMNavigationController(rootViewController: vc)
                    self.presentViewController(nvc, animated: true, completion: nil)
                }
            }else if indexPath.row == 1 {
                if VENTouchLock.sharedInstance().isPasscodeSet() {
                    let vc = VENTouchLockEnterPasscodeViewController()
                    vc.willFinishWithResult = {(success: Bool) in
                        if success {
                            VENTouchLock.sharedInstance().deletePasscode()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                    let nvc = MMNavigationController(rootViewController: vc)
                    self.presentViewController(nvc, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 2 {
            return false
        }
        return true
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
