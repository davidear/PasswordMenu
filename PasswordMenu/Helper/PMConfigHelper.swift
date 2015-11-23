//
//  PMConfigHelper.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/23.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class PMConfigHelper: NSObject {
    class func defaultTypeList() -> NSArray? {
        let path = NSBundle.mainBundle().pathForResource("template", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        do {
            if let arr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSArray {
                return arr
            }
            return nil
        } catch {
            print("read template fail")
            return nil
        }
        
    }
}
