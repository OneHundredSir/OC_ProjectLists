//
//  InterestcalculatorViewController.h
//  SP2P_7
//
//  Created by Kiu on 14-6-12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestcalculatorViewController : UIViewController

@property (nonatomic, copy) NSString *bidAmout;             // 投标金额
@property (nonatomic, copy) NSString *apr;                  // 年利率
@property (nonatomic, copy) NSString *deadLine;             // 投标期限
@property (nonatomic, assign) int deadperiodUnit;     // 投标类型
@property (nonatomic, assign) NSUInteger repayType;         // 还款方式
@property (nonatomic, assign) int deadType;             // 投标奖励类型
@property (nonatomic, copy) NSString *deadValue;            // 投标奖励
@property (nonatomic, assign) float bonus;
@property (nonatomic, assign) float awardScale;

@property (nonatomic, assign) int status;       //0、财富工具箱 进入   1、详情页面跳入

@end
