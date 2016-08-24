//
//  MainViewController.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

#define kRightMenuMargin 60.0f

@interface MainViewController : RESideMenu

- (instancetype)rootViewController;

- (void) changeRightMenu:(UIViewController *)controller;

@end
