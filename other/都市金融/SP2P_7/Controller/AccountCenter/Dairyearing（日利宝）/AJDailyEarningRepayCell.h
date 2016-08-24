//
//  AJDailyEarningRepayCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/20.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJDailyEarningRepayOut;
typedef void(^AJDailyEarningRepayCellBlock)(NSString *Id);
@interface AJDailyEarningRepayCell : UITableViewCell

@property (nonatomic,strong) AJDailyEarningRepayOut *aAJDailyEarningRepayOut;
@property (nonatomic, copy) AJDailyEarningRepayCellBlock block;
+ (instancetype)cellWithTableView:(UITableView *)tableView block:(AJDailyEarningRepayCellBlock)block;
@end
