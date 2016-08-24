//
//  RootViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = W_BackColor;
    //先把控制器加到子控制器
    [self addChildViewController:self.personVC];
    self.personVC.view.frame=(CGRect){0,0,W_width,W_height};
    [self.view addSubview:self.personVC.view];
    
    //先把控制器加到子控制器
    [self addChildViewController:self.tabarVC];
    self.tabarVC.view.frame=(CGRect){0,0,W_width,W_height};
    [self.view addSubview:self.tabarVC.view];
    
}

//加到这里才能实现bar的高亮 设置高亮为白色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 懒加载
-(PersonViewController *)personVC
{
    if (_personVC == nil) {
        _personVC = [PersonViewController new];
    }
    return _personVC;
}

-(WHDBaseTabBarController *)tabarVC
{
    if (_tabarVC == nil) {
        _tabarVC = [WHDBaseTabBarController new];
    }
    return _tabarVC;
}


@end
