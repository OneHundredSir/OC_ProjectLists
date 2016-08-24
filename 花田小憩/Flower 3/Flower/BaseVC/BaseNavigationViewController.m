//
//  BaseNavigationViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];//只是测试用的
    [self.navigationBar setTranslucent:NO];
    self.navigationBar.alpha = 1;

//    self.navigationBar.clipsToBounds= YES;
//    [self.navigationBar setTintColor:[UIColor redColor]];
    
}



@end
