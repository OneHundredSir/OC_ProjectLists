//
//  BaseNavigationController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//设置导航控制的 tabbar的颜色
    [self.navigationBar setBarTintColor:mian_color];
//    设置tabbar为不透明
    [self.navigationBar setTranslucent:NO];
//    设置navigationBar 背景为纯黑
    [self.navigationBar setBarStyle:UIBarStyleBlack];
    
}

//设置当前导航控制器内部的所有的控制器的 状态栏 为高亮
- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
