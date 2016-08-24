//
//  FinancialReceivables.h
//  SP2P_6.1
//
//  Created by kiu on 14-9-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinancialReceivables : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger tenderId;

@property (nonatomic, copy) NSString *smallImageFilename;// 借款标类型

@property (nonatomic, copy) NSString *investAmount; // 投标金额

@property (nonatomic, copy) NSString *receivingAmount; // 本息合计应收金额

@property (nonatomic, copy) NSString *transferStatus; // 借款状态

@property (nonatomic, copy) NSString *hasReceivedAmount; // 已收金额

@property (nonatomic, assign) NSInteger overduePaybackPeriod; // 逾期未还账单

@end
