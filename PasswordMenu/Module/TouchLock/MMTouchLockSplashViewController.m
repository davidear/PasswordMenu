//
//  MMTouchLockSplashViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMTouchLockSplashViewController.h"

@interface MMTouchLockSplashViewController ()

@end

@implementation MMTouchLockSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

- (void)initSubviews {
    self.view.backgroundColor = [UIColor colorFromHexString:kColorDark];
    
    
    UIButton *fingerprint1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [fingerprint1 setTitle:@"点击指纹进行解锁" forState:UIControlStateNormal];
    [fingerprint1 setTitleColor:[UIColor colorFromHexString:kColorLight] forState:UIControlStateNormal];
    [fingerprint1 addTarget:self action:@selector(fingerprint:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fingerprint1];
    
    UIButton *fingerprint2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [fingerprint2 setImage:[UIImage imageNamed:@"iconfont-augiczhiwentubiao"] forState:UIControlStateNormal];
    [fingerprint2 addTarget:self action:@selector(fingerprint:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fingerprint2];
    
    UIButton *passcode = [UIButton buttonWithType:UIButtonTypeSystem];
    [passcode setTitle:@"使用密码解锁" forState:UIControlStateNormal];
    [passcode setTitleColor:[UIColor colorFromHexString:kColorLight] forState:UIControlStateNormal];
    [passcode addTarget:self action:@selector(passcode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passcode];
    
    [fingerprint1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
    
    [fingerprint2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.bottom.equalTo(fingerprint1.mas_top).offset(-8);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
    
    [passcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
    }];
}
- (void)setUI {
    self.view.backgroundColor = [UIColor blueColor];
}

#pragma mark - Button Action
//**
//Displays a Touch ID prompt if the device can support it.
//*/
//- (void)showUnlockAnimated:(BOOL)animated;
//
///**
// Displays a Touch ID prompt if the device can support it.
// */
//- (void)showTouchID;
//
///**
// Presents a VENTouchLockEnterPasscodeViewController instance.
// */
//- (void)showPasscodeAnimated:(BOOL)animated;
- (void)fingerprint:(UIButton *)sender {
    [self showUnlockAnimated:YES];

}
- (void)passcode:(UIButton *)sender {
    [self showPasscodeAnimated:YES];
}
@end
