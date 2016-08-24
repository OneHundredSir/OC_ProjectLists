//
//  LoanType.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanType : NSObject


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *minAmount;
@property (nonatomic, copy) NSString *maxAmount;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSString *applicantCondition;
@end
