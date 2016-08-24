//
//  BorrowBillCell.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-29.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowBillCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *overdueView;
@property (nonatomic,strong) UIImageView *repayView;
@property (nonatomic,strong) UILabel *moneyLabel;

@end
