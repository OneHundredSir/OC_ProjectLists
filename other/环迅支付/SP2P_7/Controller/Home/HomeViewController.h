//
//  HomeViewController.h
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  首页
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "AdScrollView.h"

#import "RESideMenu.h"
#import "REFrostedViewController.h"

@interface HomeViewController : BasicViewController

@property (nonatomic, strong) AdScrollView *adScrollView;// 广告轮播图
@end
