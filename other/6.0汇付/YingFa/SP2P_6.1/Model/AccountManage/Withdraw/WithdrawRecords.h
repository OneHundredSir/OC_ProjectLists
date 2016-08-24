//
//  WithdrawRecords.h
//  SP2P_6.1
//
//  Created by kiu on 14/10/23.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawRecords : NSObject

@property (nonatomic, copy) NSString *withdrawMoney;    // 提现金额
@property (nonatomic, copy) NSString *withdrawTime;     // 提现时间
@property (nonatomic, assign) int withdrawStatus;       // 提现状态
@property (nonatomic, copy) NSString *bankName;         // 提现银行
@property (nonatomic, copy) NSString *cardNum;          // 提现账号
@property (nonatomic, copy) NSString *auditTime;        // 申请时间
@property (nonatomic, copy) NSString *payTime;          // 付款时间

@end
