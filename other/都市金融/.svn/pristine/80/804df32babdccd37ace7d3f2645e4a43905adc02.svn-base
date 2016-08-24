//
//  Investment.h
//  SP2P_7
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Investment : NSObject

@property (nonatomic, strong) NSNumber *product_id; // 产品类型：5==稳赢宝，7==新手表，其他==商理宝
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *borrowId;

@property (nonatomic, copy) NSString *levelStr;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *unitstr;

@property (nonatomic, assign) BOOL isQuality;

@property (nonatomic, assign) CGFloat amount;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) int repaytime;

@property (nonatomic, assign) CGFloat rate;

@property (nonatomic, copy) NSString *numStr;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) NSString *repayTypeStr;

@property (nonatomic, strong) NSNumber *status;

////  传值到利率计算机页面
@property (nonatomic, assign) int repayType;

@property (nonatomic, assign) int deadperiodUnit;

@property (nonatomic, assign) int deadType;

@property (nonatomic, assign) int bonus;

@property (nonatomic, assign) int awardScale;

- (instancetype)initWithDict:(NSDictionary *)dic;
@end
