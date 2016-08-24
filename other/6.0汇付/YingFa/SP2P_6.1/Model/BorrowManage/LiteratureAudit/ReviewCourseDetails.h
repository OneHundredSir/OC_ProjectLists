//
//  ReviewCourseDetails.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewCourseDetails : NSObject

@property (nonatomic, copy) NSString *auditItemName;// 证件名称

@property (nonatomic, assign) NSInteger status;//	是否有效	3是失效,2是有效 否则无效

@property (nonatomic, assign) NSInteger subjectId;// 审核科目编号

@property (nonatomic, assign) NSInteger period;// 有效期

@property (nonatomic, assign) NSInteger creditScore;// 信用积分

@property (nonatomic, copy) NSString *expireTime;// 到期时间


@property (nonatomic, copy) NSString *signId;// 到期时间

@property (nonatomic, copy) NSString *time;// 时间

@property (nonatomic, copy) NSString *auditTime;// 审核时间

@property (nonatomic, assign) NSInteger creditCycle;// 审核周期

@property (nonatomic, copy) NSArray *productNames;// 关联借款类型	数组

@property (nonatomic, copy) NSString *suggestion;// 关联借款类型	数组

@end
