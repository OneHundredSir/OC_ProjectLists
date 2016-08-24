//
//  AJAddCellData.h
//  SP2P_7
//
//  Created by Ajax on 16/1/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJAddCellData : NSObject
@property (nonatomic, copy) NSString *transfer_time;//: 操作时间
@property (nonatomic, copy) NSString *Transfer_amount;//Transfer_amount:操作金额
@property (nonatomic, copy) NSString *Type_id;//:操作类型	1转入	2转出
@property (nonatomic, copy) NSString *Id;//序号
//文本写死：转入写“转入投资资金”、转出写“转出投资资金”
- (instancetype)initWithDict:(NSDictionary*)dic;
@end
