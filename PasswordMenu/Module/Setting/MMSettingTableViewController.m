//
//  MMSettingTableViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/2.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMSettingTableViewController.h"
#import "VENTouchLock.h"
#import "MMNavigationController.h"
@interface MMSettingSwitchCell: UITableViewCell

@end
@implementation MMSettingSwitchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UISwitch *switchButton = [[UISwitch alloc] init];
        self.accessoryView = switchButton;
    }
    return self;
}
@end
#pragma mark -
@interface MMSettingTableViewController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation MMSettingTableViewController
static NSString * const reuseIdentifier = @"Cell";
static NSString * const SwitchReuseIdentifier = @"SwitchCell";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {//可以在三种情况的presented的vc被dismiss的时候进行动作，不过使代码太难读，这里牺牲一些性能
    [self.tableView reloadData];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SettingList" ofType:@"plist"];
    self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];
}
- (void)setUI {
    [self.tableView registerClass:[MMSettingSwitchCell class] forCellReuseIdentifier:SwitchReuseIdentifier];
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 21)];
    header.text = @"指纹识别仅在已设置密码情况下才能开启";
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont systemFontOfSize:13];
    self.tableView.tableHeaderView = header;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row < 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }else if(indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:SwitchReuseIdentifier forIndexPath:indexPath];
        UISwitch *switchButton = (UISwitch *)cell.accessoryView;
        [switchButton addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        switchButton.enabled = [[VENTouchLock sharedInstance] isPasscodeSet] && [VENTouchLock canUseTouchID];
        switchButton.on = [VENTouchLock shouldUseTouchID];
    }
    // Configure the cell...
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    if (indexPath.row == 0 && [[VENTouchLock sharedInstance] isPasscodeSet]) {
        cell.textLabel.text = self.dataArray[indexPath.row][@"title2"];
    }
    return cell;
}

#pragma mark - Button Action
- (void)switchValueChanged:(UISwitch *)sender {
    [VENTouchLock setShouldUseTouchID:sender.isOn];
}
#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if ([[VENTouchLock sharedInstance] isPasscodeSet]) {//已设置密码
            VENTouchLockEnterPasscodeViewController *vc = [[VENTouchLockEnterPasscodeViewController alloc] init];
            __weak typeof(vc) weakself = vc;
            vc.willFinishWithResult = ^void(BOOL success) {
                if (success) {
                    VENTouchLockCreatePasscodeViewController *createVC = [[VENTouchLockCreatePasscodeViewController alloc] init];
                    [weakself.navigationController pushViewController:createVC animated:YES];
                }
            };
            MMNavigationController *nvc = [[MMNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
            
        }else {//未设置密码
            VENTouchLockCreatePasscodeViewController *vc = [[VENTouchLockCreatePasscodeViewController alloc] init];
            MMNavigationController *nvc = [[MMNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
        }
    }else if(indexPath.row == 1) {
        if ([[VENTouchLock sharedInstance] isPasscodeSet]) {
            VENTouchLockEnterPasscodeViewController *vc = [[VENTouchLockEnterPasscodeViewController alloc] init];
            __weak typeof(vc) weakself = vc;
            vc.willFinishWithResult = ^void(BOOL success) {
                if (success) {
                    [[VENTouchLock sharedInstance] deletePasscode];
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                }
            };
            MMNavigationController *nvc = [[MMNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return NO;
    }
    return YES;
}
@end
