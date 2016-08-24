//
//  Collection.h
//  SP2P_7
//
//  Created by kiu on 14-9-29.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  理财子账户 -> 收款中（数据模型）

#import <Foundation/Foundation.h>

@interface Collection : NSObject

@property (nonatomic, copy) NSString *totalNum;                 // 已还款列表总次数
@property (nonatomic, copy) NSString *title;                    // 借款标标题
@property (nonatomic, assign) int transferStatus;           // 借款状态
@property (nonatomic, assign) float bidAmount;                // 借款金额
@property (nonatomic) float receivingAmount;          // 本息合计应收金额
@property (nonatomic) float hasReceivedAmount;        // 已收金额
@property (nonatomic, copy) NSString *hasPaybackPeriod;         // 已还账单
@property (nonatomic, copy) NSString *overduePaybackPeriod;     // 逾期未还账单
@property (nonatomic, assign) int periodUnit;               // 借款期限单位
@property (nonatomic, assign) int bidId;                    // 借款标ID
@property (nonatomic, assign) int investId;
@property (nonatomic, copy) NSString *name;                     // 借款人

@property (nonatomic, assign) BOOL isSecBid;
@property (nonatomic, assign) int period;

@end
