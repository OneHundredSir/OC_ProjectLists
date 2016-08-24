//
//  Repaymentcalculator.h
//  SP2P_6.1
//
//  Created by kiu on 14-10-14.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  还款计算器 数据模型

#import <Foundation/Foundation.h>

@interface Repaymentcalculator : NSObject

@property (nonatomic, assign) float monRate;     // 月利率
@property (nonatomic, assign) float monPay;     // 月还本息
@property (nonatomic, assign) float allPay;     // 本息总额

@end
