//
//  WHDBaseNavigationController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDBaseNavigationController.h"

@interface WHDBaseNavigationController ()

@end

@implementation WHDBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTintColor:W_BackColor];
    [self.navigationBar setTranslucent:NO];
    //设置navigationbar的背景是黑色
    [self.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationBar.clipsToBounds = YES;
    
    
}
//设置当前导航控制器内部的所有的控制器的状态栏为高亮
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
