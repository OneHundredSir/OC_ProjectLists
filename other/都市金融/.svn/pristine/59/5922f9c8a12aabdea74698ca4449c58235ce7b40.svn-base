//
//  AJHomeCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/15.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AJHomeCellbtnClickBlock)();
@class Investment;
@interface AJHomeCell : UITableViewCell
@property (nonatomic,strong) Investment *aInvestment;
@property (nonatomic, copy) AJHomeCellbtnClickBlock bidBtnClick;
+ (instancetype)cellWithTableView:(UITableView *)tableView btnClickBlock:(AJHomeCellbtnClickBlock)block;
@end
