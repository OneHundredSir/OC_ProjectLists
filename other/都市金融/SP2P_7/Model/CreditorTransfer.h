//
//  CreditorTransfer.h
//  SP2P_7
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditorTransfer : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *apr;

@property (nonatomic, assign) NSInteger creditorId;

@property (nonatomic, assign) BOOL isQuality;

@property (nonatomic, copy) NSString *time;// 字符串具体到分--转成字符串
@property (nonatomic, copy) NSDate *leftDate;// 剩余时间--转成字NSDate

@property (nonatomic, assign) int  repaytime;

@property (nonatomic, assign) NSInteger sortTime;

@property (nonatomic, copy) NSString *units;

@property (nonatomic, assign) CGFloat principal;// 本金

@property (nonatomic, assign) CGFloat minPrincipal;// 底价

@property (nonatomic, assign) CGFloat currentPrincipal; // 当前价格

@property (nonatomic, assign) NSInteger attentionDebtId;

@property (nonatomic, copy) NSString *joinNumStr;

@property (nonatomic, assign) NSInteger status;
- (instancetype)initWithDict:(NSDictionary *)dic;
@end
