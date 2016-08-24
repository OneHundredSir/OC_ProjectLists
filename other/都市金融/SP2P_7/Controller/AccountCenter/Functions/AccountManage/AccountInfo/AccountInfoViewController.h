//
//  AccountInfoViewController.h
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 账户中心--》账户管理--》账户信息

#import <UIKit/UIKit.h>
#import "CreditBorrowingScaleViewController.h"
#import "ProductDescriptionViewController.h"
#import "ReleaseBorrowInfoViewController.h"

@interface AccountInfoViewController : BasicViewController

@property (nonatomic,assign) NSInteger typeNum;
@property (nonatomic,strong) CreditBorrowingScaleViewController *cbsVC;
@property (nonatomic,strong) ProductDescriptionViewController *pdpVC;

@end
