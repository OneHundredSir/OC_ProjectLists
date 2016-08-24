//
//  DebtManagement.h
//  SP2P_7
//
//  Created by kiu on 14-9-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebtManagement : NSObject

@property (nonatomic, copy) NSString *titleName;  // 借款标标题

/**
 * 转让债权状态(0成功,1转让中,2审核中,3不通过,4失败)
 *
 * 受让债权状态(0竞拍成功,1竞拍中,2定向转让)
 */
@property (nonatomic, assign) int status;

@property (nonatomic, copy) NSString *endTime;   // 转让期限

@property (nonatomic, copy) NSString *time1; 

@property (nonatomic, assign) int type;   // 债权转让类型(0是竞价, 1是定向)

@property (nonatomic, assign) float transferPrice;  // 转让定价

@property (nonatomic, assign) float maxOfferPrice;  // 最高竞价

@property (nonatomic, copy) NSString *sign;  // 加密债权ID

@property (nonatomic, copy) NSString *signId;  // 受让债权视图加密ID

@property (nonatomic, copy) NSString *bidName;  // 受人Name


@end
