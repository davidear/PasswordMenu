//
//  ModelFactory.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/23.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class ModelFactory: NSObject {
    class func element(type: String) -> Element {
        let ele = Element.MR_createEntity()
        ele.leftText = type
        switch type {
        case "文本":
            ele.type = "text"
        case "密码":
            ele.type = "password"
        case "日期":
            ele.type = "date"
        case "图像":
            ele.type = "image"
        default:
            break
        }
        return ele
    }
}
