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
        ele.type = type
        switch type {
        case "text":
            ele.leftText = "文本"
        case "password":
            ele.leftText = "密码"
        case "date":
            ele.leftText = "日期"
        case "image":
            ele.leftText = "图像"
        default:
            break
        }
        return ele
    }
}
