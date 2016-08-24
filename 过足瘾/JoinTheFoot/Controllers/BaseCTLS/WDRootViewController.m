//
//  WDRootViewController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "WDRootViewController.h"

@interface WDRootViewController ()

@end

@implementation WDRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    将personal的控制器添加为当前控制器的子控制器
    [self addChildViewController:self.personal];
//    重新修改personal控制器的view的frmae
    self.personal.view.frame = CGRectMake(0, 0, kScreen_W, kScreen_H);
//    将persoal的view添加到当前的selfview
    [self.view addSubview:self.personal.view];
//    添加mianTabbar控制器作为当前控制器的子控制器
    [self addChildViewController:self.mianTabBar];
//    添加maintabbar的view
    [self.view addSubview:self.mianTabBar.view];
    
    self.view.frame = CGRectMake(0, 0, kScreen_W, kScreen_H - 64);
    
}

//设置 状态栏的文字颜色为 高亮  白色
- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//懒加载 maintabbar
- (MainTabBarController *)mianTabBar
{
    if (!_mianTabBar) {
        
        _mianTabBar = [[MainTabBarController alloc]init];
    }


    return _mianTabBar;
}

//懒加载personal控制器
- (PersonalViewController *)personal
{
    if (!_personal) {
        _personal = [[PersonalViewController alloc]init];
        
    }
    return _personal;

}
@end
