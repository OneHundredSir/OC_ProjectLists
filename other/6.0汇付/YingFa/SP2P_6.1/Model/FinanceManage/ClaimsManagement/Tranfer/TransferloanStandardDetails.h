//
//  TransferloanStandardDetails.h
//  SP2P_6.1
//
//  Created by kiu on 14-10-16.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(转让债权管理) -> 已成功 -> 转让的借款标详情 [成功,转让中,审核中,不通过,失败](opt=49)

#import <Foundation/Foundation.h>

@interface TransferloanStandardDetails : NSObject

@property (nonatomic, copy) NSString *borrowid;        // 借款标编号
@property (nonatomic, copy) NSString *borrowerName;    // 借款人名称
@property (nonatomic, copy) NSString *borrowType;      // 借款标类型
@property (nonatomic, copy) NSString *borrowTitle;     // 借款标标题
@property (nonatomic, copy) NSString *bidCapital;                  // 投标本金
@property (nonatomic, copy) NSString *annualRate;                  // 年利率
@property (nonatomic, copy) NSString *interestSum;                 // 本息合计应收金额
@property (nonatomic, copy) NSString *receivedAmount;              // 已收金额
@property (nonatomic, copy) NSString *remainAmount;                // 剩余应收款
@property (nonatomic, copy) NSString *expiryDate;                  // 还款日期
@property (nonatomic, copy) NSString *collectCapital;              // 待收本金

@end
