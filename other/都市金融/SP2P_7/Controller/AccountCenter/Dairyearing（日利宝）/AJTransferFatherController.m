//
//  AJTransferFatherController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/23.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJTransferFatherController.h"
#import "AJDailyEarningRepayController.h"
#import "SCNavTabBarController.h"

@interface AJTransferFatherController ()<SCNavTabBarControllerDelegate>

@end

@implementation AJTransferFatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 两个列表 AJTransferFatherController本控制器起错名字。。。。。。。。。
    NSArray *items = @[@"转出审核管理", @"已还款"];
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (int i = 0; i <items.count; i++) {
        AJDailyEarningRepayController *controller = [[AJDailyEarningRepayController alloc] initWithStyle:UITableViewStyleGrouped];
        controller.title = items[i];
        [arrTemp addObject:controller];
    }
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = arrTemp;
    navTabBarController.delegate = self;
    //    navTabBarController.showArrowButton = YES;
    navTabBarController.scrollAnimation = YES;
    navTabBarController.mainViewBounces = YES;
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    [navTabBarController addParentController:self];

}

#pragma  mark - SCNavTabBarControllerDelegate
- (void)SCNavTabBarController:(SCNavTabBarController *)navTabBarController didSelectedSubController:(UIViewController *)subController
{
    for (UITableViewController *controller in navTabBarController.subViewControllers) {
        controller.tableView.scrollsToTop = NO;
    }
    NSArray *dataArr = [subController valueForKey:@"data"];
    UITableView *tableView = [subController valueForKey:@"tableView"];
    tableView.scrollsToTop = YES;
    if (dataArr.count == 0) {
        [tableView headerBeginRefreshing];
    }
}
@end
