//
//  BankCard.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCard : NSObject

@property (nonatomic, assign) NSInteger bankCardId;// 银行卡id

@property (nonatomic, copy) NSString *bankName;// 银行名称

@property (nonatomic, copy) NSString *account;// 银行卡号

@property (nonatomic, copy) NSString *accountName;// 银行卡持有人

@end
