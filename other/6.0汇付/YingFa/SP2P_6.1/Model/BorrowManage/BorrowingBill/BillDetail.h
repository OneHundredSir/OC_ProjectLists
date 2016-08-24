//
//  BillDetail.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillDetail : NSObject

@property (nonatomic, copy) NSString *userName;//

@property (nonatomic, copy) NSString *bidTitle;// 借款标标题

@property (nonatomic, copy) NSString *loanAmount;// 借款总额

@property (nonatomic, copy) NSString *loanPrincipalInterest;// 借款本息合计

@property (nonatomic, assign) NSInteger loanPeriods;// 借款期数

@property (nonatomic, assign) CGFloat apr;// 年利率

@property (nonatomic, copy) NSString *currentPayAmount;// 本期还款金额

@property (nonatomic, assign) NSInteger hasPayedPeriods;// 已还期数

@property (nonatomic, assign) NSInteger remainPeriods;// 剩余期限 (loanPeriods - hasPayedPeriods)

@property (nonatomic, copy) NSString *repaymentTime;// 本期还款日

@property(nonatomic, copy) NSString *billNumber;// 账单编号

@property(nonatomic, copy) NSString *produceBillTime;// 账单生成日期

@property(nonatomic, copy) NSString *repaymentType;// 还款方式

@property(nonatomic, copy) NSString *userBalance;// 账户余额

@property(nonatomic, copy) NSString *userAmount;// 账户总额
//{
//    "produce_bill_time" : {
//        "year" : 114,
//        "time" : 1408433283000,
//        "day" : 2,
//        "date" : 19,
//        "hours" : 15,
//        "month" : 7,
//        "nanos" : 0,
//        "seconds" : 3,
//        "minutes" : 28,
//        "timezoneOffset" : -480
//    },
//    "user_name" : "刘文辉",
//    "status" : -1,
//    "user_amount" : 1908630.57,
//    "user_id" : 2,
//    "current_period" : 1,
//    "has_payed_periods" : 0,
//    "persistent" : true,
//    "bid_id" : 25,
//    "apr" : 10,
//    "bill_number" : "Z39",
//    "repayment_type" : "按月还款、等额本息",
//    "id" : 39,
//    "bid_title" : "打工打累了，想自己创业当老板",
//    "sign" : "3566C7B6E8BDD8FD02820EB147FDEA1039A22B438E95EC584D720683F67AFA93b7cd33ca",
//    "loan_principal_interest" : 1012.52,
//    "user_balance" : 1109430.57,
//    "loan_amount" : 1000,
//    "loan_periods" : 2,
//    "repayment_time" : {
//        "year" : 114,
//        "time" : 1411091091000,
//        "day" : 5,
//        "date" : 19,
//        "hours" : 9,
//        "month" : 8,
//        "nanos" : 0,
//        "seconds" : 51,
//        "minutes" : 44,
//        "timezoneOffset" : -480
//    },
//    "current_pay_amount" : 506.26,
//    "entityId" : 39
//}

@end
