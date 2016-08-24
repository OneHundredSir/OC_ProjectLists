//
//  CollectionBorrow.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionBorrow : NSObject

@property (nonatomic, copy) NSString *rowId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;// 借款标类型 small_image_filename

@property (nonatomic, assign) NSInteger status;// 状态

@property (nonatomic, copy) NSString *creditLevel;// imageFilename

@property (nonatomic, assign) CGFloat amount;// amount

@property (nonatomic, assign) CGFloat apr;

@property (nonatomic, assign) NSInteger period;

@property (nonatomic, assign) NSInteger periodUnit;// 借款期限单位

@property (nonatomic, assign) NSInteger productItemCount;// 需要审核的资料

@property (nonatomic, assign) NSInteger userItemCountTrue;// 已经审核的资料

@property (nonatomic, assign) NSInteger bidId;

@end
