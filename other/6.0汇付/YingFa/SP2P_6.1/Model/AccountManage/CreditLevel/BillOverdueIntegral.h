//
//  BillOverdueIntegral.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillOverdueIntegral : NSObject

@property (nonatomic, copy) NSString *title;// 借款标名称

@property (nonatomic, copy) NSString *bidNo;// 借款标ID

@property (nonatomic, assign) int score;// 信用积分

@property (nonatomic, copy) NSString *auditTime;// 时间

@property (nonatomic, copy) NSString *period;// 比例

@end
