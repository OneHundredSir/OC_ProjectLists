//
//  BorrowingBillDetail.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BillDetail.h"

#import "HistoryRepayment.h"

@interface BorrowingBillDetail : NSObject

@property (nonatomic, copy) NSString *platformName;// 平台名称

@property (nonatomic, copy) NSString *hotline;// 客服专线

@property (nonatomic, strong) BillDetail *billDetail;// 账单详情

@property (nonatomic, strong) NSMutableArray *historyArrays;// 历史收款情况


@end
