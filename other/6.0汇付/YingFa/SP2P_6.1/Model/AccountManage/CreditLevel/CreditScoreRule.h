//
//  CreditScoreRule.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 信用积分规则

@interface CreditScoreRule : NSObject

@property (nonatomic, assign) NSInteger creditLimit;// 信用额度

@property (nonatomic, assign) NSInteger investpoints;// 投标积分

@property (nonatomic, assign) NSInteger normalPayPoints;// 正常还款积分

@property (nonatomic, assign) NSInteger overDuePoints;// 逾期罚款积分

@property (nonatomic, assign) NSInteger fullBidPoints;// 成功满标积分

@property (nonatomic, assign) NSInteger auditItemCount;// 审核资料科目

@end
