//
//  FinancialBillsCell.h
//  SP2P_7
//
//  Created by Jerry on 14-7-31.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancialBillsCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *overdueView;
@property (nonatomic,strong) UIImageView *repayView;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@end
