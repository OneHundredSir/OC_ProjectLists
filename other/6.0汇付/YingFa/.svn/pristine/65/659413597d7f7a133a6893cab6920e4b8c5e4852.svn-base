//
//  BorrowingBill.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 工具箱 >>>>> 借款账单
@interface BorrowingBill : NSObject

@property (nonatomic, copy) NSString *title;

//"sign":"FDE807961E6D92E636224B65C23185A9CCC61C2BC1371FEA0B561FA63E72943351fd7cd6"
@property (nonatomic, copy) NSString *sign;// 账单ID

@property (nonatomic, assign) CGFloat repaymentAmount;// 本期需还款金额

@property (nonatomic, assign) NSInteger isOverdue;// 逾期状态	0不是,1是

@property (nonatomic, assign) NSInteger status;// 还款状态	-1，-2未还款,否则为已还款

@property (nonatomic, assign) NSInteger checkPeriod;//检查期数

@end
