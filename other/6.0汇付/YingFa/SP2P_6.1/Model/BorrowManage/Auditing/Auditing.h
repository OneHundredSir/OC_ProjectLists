//
//  Auditing.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 审核中的借款标
@interface Auditing : NSObject

@property (nonatomic, copy) NSString *title;// 借款标标题

@property (nonatomic, assign) NSInteger auditingId;// 借款标ID

@property (nonatomic, assign) NSInteger productItemCount;// 未提交资料数

@property (nonatomic, assign) NSInteger userItemCountTrue;// 未通过资料数

@property (nonatomic, copy) NSString *smallImageFilename;// 借款标类型

@end
