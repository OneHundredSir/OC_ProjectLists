//
//  RootViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BaseTabBarViewController *tabarVc = [BaseTabBarViewController new];
    self.tabarVc = tabarVc;
    [self addChildViewController:tabarVc];
    tabarVc.view.frame = self.view.frame;
    [self.view addSubview:tabarVc.view];
    
    
}


@end
