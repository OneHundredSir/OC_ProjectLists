//
//  CreditRatingRule.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 信用等级规则

@interface CreditRatingRule : NSObject

@property (nonatomic, assign) NSInteger rowId;//  主键

@property (nonatomic, copy) NSString *imageFileName;// 信用等级图标

@property (nonatomic, assign) NSInteger minAuditItems;// 最低审核科目数量

@property (nonatomic, assign) NSInteger minCreditScore;// 最低信用积分

@property (nonatomic, copy) NSString *isAllowOverdue;// 逾期扣分(false否 true是)

@property (nonatomic, copy) NSString *mustItems;// 必审科目

@property (nonatomic, copy) NSString *suggest;// 信贷建议

@property (nonatomic, copy) NSString *name;// 信用等级名称

//{
//    "is_allow_overdue" : "是",
//    "id" : 1,
//    "image_filename" : "\/images?uuid=2b601645-217e-47b6-a950-05073ed992db",
//    "min_audit_items" : 0,
//    "entityId" : 1,
//    "min_credit_score" : 0,
//    "must_items" : "",
//    "persistent" : true,
//    "suggest" : "借款人审核资料少，历史记录一般，不建议投标。",
//    "is_enable" : true,
//    "name" : "信用等级为HR"
//}


@end
