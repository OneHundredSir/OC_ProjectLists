//
//  LiteratureAuditMainViewController.m
//  SP2P_7
//
//  Created by 李小斌 on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "LiteratureAuditMainViewController.h"
#import "LiteratureAuditViewController.h"
#import "ScreenViewController.h"

@interface LiteratureAuditMainViewController ()<RESideMenuDelegate>

@end

@implementation LiteratureAuditMainViewController


- (instancetype)rootViewController
{
    LiteratureAuditViewController *contentViewController = [[LiteratureAuditViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    
    ScreenViewController *rightMenu = [[ScreenViewController alloc] init];
    rightMenu.leftMargin = kRightMenuMargin;
    UINavigationController *rightNavigationController =  [[UINavigationController alloc] initWithRootViewController:rightMenu];
    
    LiteratureAuditMainViewController *sideMenuViewController = [[LiteratureAuditMainViewController alloc] initWithContentViewController:navigationController
                                                                                    leftMenuViewController:nil
                                                                                   rightMenuViewController:rightNavigationController];
    
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];// 背景阴影颜色
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);// 背景阴影偏移量
    sideMenuViewController.contentViewShadowOpacity = 0.6;// 阴影透明度
    sideMenuViewController.contentViewShadowRadius = 12;// 阴影的圆角
    sideMenuViewController.contentViewShadowEnabled = YES;
    
    sideMenuViewController.fadeMenuView = NO; // 禁用淡入淡出
    sideMenuViewController.menuPrefersStatusBarHidden = NO;
    
    sideMenuViewController.bouncesHorizontally = NO;// 禁用反弹功能
    
    [sideMenuViewController setContentViewLeftScaleValue:0.8];
    [sideMenuViewController setContentViewRightScaleValue:1.0];
    
    [sideMenuViewController setContentViewInPortraitOffsetLeftCenterX:80];// 主视图水平偏移量
    [sideMenuViewController setContentViewInPortraitOffsetRightCenterX:100];// 主视图水平偏移量
    
    sideMenuViewController.panFromEdge = NO;// 是否只能从屏幕边缘拖动菜单
    sideMenuViewController.scaleMenuView = NO;// 是否缩放菜单视图
    sideMenuViewController.parallaxEnabled = NO; // 视觉误差
    sideMenuViewController.scaleBackgroundImageView = NO;// 是否缩放背景图
    
    sideMenuViewController.panLeftGestureEnabled = NO;// 左边菜单是否支持手势
    sideMenuViewController.panRightGestureEnabled = NO;// 右边菜单是否支持手势
    
    navigationController.navigationBar.hidden = NO;
    
    return sideMenuViewController;
}

- (void) changeRightMenu:(UIViewController *)controller
{
    
    UINavigationController *rightNavigationController =  [[UINavigationController alloc] initWithRootViewController:controller];
    self.rightMenuViewController = rightNavigationController;
    
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    DLOG(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    DLOG(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    DLOG(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    DLOG(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}


@end
