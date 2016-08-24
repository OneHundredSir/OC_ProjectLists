//
//  BorrowingBillTableViewCell.h
//  SP2P_7
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
@class BorrowingBill;
@interface BorrowingBillTableViewCell : UITableViewCell
@property (nonatomic,strong) BorrowingBill *aBorrowingBill;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *overdueView;
@property (nonatomic,strong) UIButton *repayView;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
