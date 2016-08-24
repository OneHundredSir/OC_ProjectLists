//
//  ReviewIntegralDetail.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 审核科目积分明细
@interface ReviewIntegralDetail : NSObject

@property (nonatomic, assign) NSInteger rowId;// 主键

@property (nonatomic, copy) NSString *name;// 审核科目名称

@property (nonatomic, copy) NSString *descriptionStr;// 审核科目名称描述

@property (nonatomic,assign) CGFloat labHeight;//描述文字长度

@property (nonatomic, assign) NSInteger creditScore;// 信用积分

@property (nonatomic, assign) NSInteger auditFee;// 审核费用

@property (nonatomic, assign) NSInteger applyReason;// 文件格式	1图片2文本3视频4音频5表格

@property (nonatomic, assign) NSInteger type;// 文件格式	1图片2文本3视频4音频5表格

@property (nonatomic, assign) NSInteger auditCycle;// 审核周期

@property (nonatomic, assign) NSInteger period;// 有效期

@property (nonatomic, assign) NSInteger creditLimit;// 信用额度

@property (nonatomic, copy) NSString *no;// 编号

@property (nonatomic, copy) NSString *stateStr;// 编号

//标签
@property (nonatomic,assign) NSInteger Tag;
//选中状态
@property (nonatomic,assign) NSInteger Checked;
//名字
//@property (nonatomic,assign) NSString *name;


@end
