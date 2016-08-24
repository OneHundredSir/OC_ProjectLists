//
//  FundRecord.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
// 资金记录

@interface FundRecord : NSObject

@property (nonatomic, assign) CGFloat amount; // amount	金额 --- 交易金额

@property (nonatomic, copy) NSString *time;// 时间 - 操作时间

@property (nonatomic, copy) NSString *name;// 用途

@property (nonatomic, assign) NSInteger type; // 交易类型	1收入2支出3冻结4解冻

@property (nonatomic, assign) CGFloat balance; // 可用余额

@property (nonatomic, assign) CGFloat userBalance; // 账户总额

@property (nonatomic, assign) CGFloat freeze; // 冻结金额

@property (nonatomic, assign) CGFloat recieveAmount; // 待收金额


@end
