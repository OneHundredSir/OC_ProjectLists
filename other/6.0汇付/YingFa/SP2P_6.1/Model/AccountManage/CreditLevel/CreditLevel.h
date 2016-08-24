//
//  CreditLevel.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 信用等级

@interface CreditLevel : NSObject

@property (nonatomic, strong) NSString *creditRating;// 信用等级

@property (nonatomic, assign) CGFloat creditScore;// 信用积分

@property (nonatomic, assign) CGFloat lastCreditLine;// 标准信用额度

@property (nonatomic, assign) CGFloat creditLimit; // 当前信用额度

@property (nonatomic, assign) CGFloat overCreditLine; // 超额借款信用额度

@end
