//
//  AJDailyEarningRepayDoneCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AJDailyEarningRepayOut;
@interface AJDailyEarningRepayDoneCell : UITableViewCell
@property (nonatomic,strong) AJDailyEarningRepayOut *aAJDailyEarningRepayOut;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
