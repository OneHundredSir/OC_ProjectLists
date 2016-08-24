//
//  InfromationBaseTabBarViewController.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-9.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  媒体咨询新闻基类视图
//

#import "InfromationBaseTabBarViewController.h"

@interface InfromationBaseTabBarViewController ()

@property(nonatomic , weak, readwrite) UIViewController *selectedViewController;

@property(nonatomic, readwrite) NSUInteger selectedIndex;

@property (nonatomic) NSMutableArray *subViewControllers;

@end

@implementation InfromationBaseTabBarViewController

- (void)setViewControllers:(NSArray *)viewControllers
{
    self.subViewControllers = [NSMutableArray array];
    for (int i = 0; i < viewControllers.count; i++) {
        id object = [viewControllers objectAtIndex:i];
        [self addChildViewController:object];
        [self.subViewControllers addObject:object];
        if (i == 0) {
            [self.view addSubview:((UIViewController *)object).view];
            self.selectedIndex = 0;
            self.selectedViewController = object;
        }
    }
}

- (void)selecteViewControllerWithIndex:(NSInteger)index
{
    if (index < self.subViewControllers.count) {
        UIViewController *object = [self.subViewControllers objectAtIndex:index];
        [self transitionFromViewController:self.selectedViewController toViewController:object duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            self.selectedViewController = object;
            self.selectedIndex = index;
        }];
    }
}

@end
