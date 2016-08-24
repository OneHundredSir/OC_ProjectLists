//
//  LiteratureAudit.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 资料审核

@interface LiteratureAudit : NSObject

@property (nonatomic, copy) NSString *name;//证件名称

@property (nonatomic, copy) NSString *no;// 审核科目编号

@property (nonatomic, assign) NSInteger status;//	是否有效	3是失效,2是有效 否则无效

@property (nonatomic, copy) NSString *strStatus;//审核状态

@property (nonatomic, copy) NSString *expireTime;// 到期时间

@property (nonatomic, copy) NSString *auditTime;// 审核时间

@property (nonatomic, copy) NSString *time;// 时间

@property (nonatomic, copy) NSString *mark;// 审核资料唯一标识

@property (nonatomic, assign) NSInteger creditScore;// 信用积分

@property (nonatomic, assign) NSInteger period;//

@end
