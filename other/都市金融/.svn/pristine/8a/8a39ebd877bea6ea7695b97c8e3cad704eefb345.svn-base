//
//  AJClearNavBarController.m
//  com.higgs.botrip
//
//  Created by 周利强 on 15/10/20.
//  Copyright © 2015年 周利强. All rights reserved.
//

#import "AJClearNavBarController.h"
#import "UIImage+AJ.h"

@interface AJClearNavBarController ()

@end

@implementation AJClearNavBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *gradientImage44 = [UIImage imageWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0]];
    UIImage *gradientImage32 = [UIImage imageWithColor:[UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.2]];
    UINavigationBar *bar = self.navigationController.navigationBar;
    //customize the appearance of UINavigationBar
    [bar setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundImage:gradientImage32 forBarMetrics:UIBarMetricsCompact];
    
    [bar setBarStyle:UIBarStyleBlack];
    bar.translucent = YES;
//    [bar setShadowImage:gradientImage44];
    bar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barStyle = UIBarStyleDefault;
    [navBar setBarTintColor:KColor];
    navBar.translucent = NO;
    
    [navBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
}
@end
