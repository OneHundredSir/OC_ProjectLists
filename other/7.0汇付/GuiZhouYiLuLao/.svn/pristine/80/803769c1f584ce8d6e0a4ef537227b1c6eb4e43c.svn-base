//
//  InformationViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  财富资讯
//

#import "InformationViewController.h"

#import "BarButtonItem.h"
#import "ColorTools.h"


@interface InformationViewController ()

@end

@implementation InformationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initData
{
    
}

/**
 初始化数据
 */
- (void)initView
{
    self.title = NSLocalizedString(@"Tab_Infromation", nil);
    
    [self initNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSString *badgeValue = @"10";
//    [[[[[self tabBarController] viewControllers] objectAtIndex:4] tabBarItem] setBadgeValue:badgeValue];

  
}

- (void)initNavigationBar
{
    BarButtonItem *leftButton = [BarButtonItem barItemWithImage:[UIImage imageNamed:@"ic_account_normal"] selectedImage:[UIImage imageNamed:@"ic_account_normal"] target:self action:@selector(leftClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];// 左边导航按钮
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:KColor];
}

- (void)leftClick:(id)sender{
    
    [self performSelector:@selector(presentLeftMenuViewController:) withObject:self];
}

@end
