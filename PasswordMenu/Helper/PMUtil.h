//
//  SAIHelper.h
//  sai-iOS
//
//  Created by DaiFengyi on 15/9/22.
//  Copyright © 2015年 Malong Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PMUtil : NSObject
#pragma mark - HUD
// 显示提示信息
+ (void)showMsg:(NSString *)message;

// 显示加载中...
+ (void)showLoading;

+ (void)showLoading:(NSString *)message;

// 隐藏所有指示器
+ (void)hideHUD;

#pragma mark - Validation
//检测手机号码是否合法
+ (BOOL)validateMobile:(NSString *)mobileNum;
//检测邮箱格式
+ (BOOL)validateEmail:(NSString *)email;

#pragma mark - Date
+ (NSString *)stringWithDate:(NSDate *)date;
@end
