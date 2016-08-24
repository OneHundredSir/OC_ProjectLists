//
//  AccountInfo.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 账户信息

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject

@property (nonatomic, assign) BOOL isAddBaseInfo;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger carStatus;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *cellPhone1;
@property (nonatomic, copy) NSString *cellPhone2;

@property (nonatomic, assign) NSInteger higtestEdu;
@property (nonatomic, assign) NSInteger housrseStatus;
@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, assign) NSInteger maritalStatus;
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *randomCode1;
@property (nonatomic, copy) NSString *randomCode2;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, assign) NSInteger registedPlaceCity;
@property (nonatomic, assign) NSInteger registedPlacePro;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) NSInteger sexId;


@end
