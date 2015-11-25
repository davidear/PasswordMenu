//
//  RandomStringGenerator.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/25.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class RandomStringGenerator: NSObject {
    class func randomString(length: NSInteger, enableLowercase: Bool, enableUppercase: Bool, enableDigit: Bool, enableSymbol: Bool) -> String {
        var strArr = [Character]()
        if enableLowercase {
            strArr.appendContentsOf(self.lowercaseString())
        }
        if enableUppercase {
            strArr.appendContentsOf(self.uppercaseString())
        }
        if enableDigit {
            strArr.appendContentsOf(self.digitString())
        }
        if enableSymbol {
            strArr.appendContentsOf(self.symbol())
        }
        
        var randomString = String()
        for var i = 0; i < length; i++ {
            randomString.append(self.randomCharacter(strArr))
        }
        return randomString
    }
    
    private class func randomCharacter(arr: [Character]) -> Character {
        return arr[Int(arc4random_uniform(UInt32(arr.count)))]
    }
    
    private class func lowercaseString() -> [Character] {
        return ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    }
    
    private class func numberString() -> [Character] {
        return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    }
    
    private class func uppercaseString() -> [Character]  {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    private class func digitString() -> [Character] {
        return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    }
    
    private class func symbol() -> [Character] {
        return ["!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "`", "{", "|", "}", "~", "_"]
    }
}
