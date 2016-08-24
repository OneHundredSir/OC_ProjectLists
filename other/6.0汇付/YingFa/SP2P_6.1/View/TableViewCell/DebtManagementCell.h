//
//  DebtManagementCell.h
//  SP2P_6.1
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebtManagementCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *stateImg;
@property (nonatomic,strong) UIImageView *typeImg;
@property (nonatomic,strong) UIButton *typeBtn;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *transferLabel;
@property (nonatomic,strong) UILabel *highestLabel;

@property (nonatomic,strong) UILabel *stateLabel;

- (void)setStateColor:(int)status;
- (void)typeLabelBack:(int)status;
@end
