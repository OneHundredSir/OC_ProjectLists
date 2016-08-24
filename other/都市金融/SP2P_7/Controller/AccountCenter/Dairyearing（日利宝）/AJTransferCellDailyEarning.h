//
//  AJTransferCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJTransfer.h"

typedef void(^AJTransferCellDailyEarningBlock)(NSString *money);

@interface AJTransferCellDailyEarning : UITableViewCell
// 金额
@property (nonatomic, weak,readonly) UITextField *cashField;
@property (nonatomic, copy) AJTransferCellDailyEarningBlock block;
@property (nonatomic,strong) AJTransfer *aAJTransfer;
+ (instancetype)cellWithTableView:(UITableView *)tableView btnClickBlock:(AJTransferCellDailyEarningBlock)block;
@end
