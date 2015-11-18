//
//  MMNavigationController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNavigationController.h"
#import "Colours.h"
#import "MMConstant.h"
@interface MMNavigationController ()

@end

@implementation MMNavigationController
+(void)initialize {
    [super initialize];
//    [[UINavigationBar appearance] setTranslucent:YES];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi-dark-bg-64"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorFromHexString:kColorDark]];
//    [[UINavigationBar appearance] setTitleTextAttributes:<#(NSDictionary *)#>]
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
