//
//  WithdrawRecordsCell.h
//  SP2P_6.1
//
//  Created by Jerry on 14-8-5.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawRecordsCell : UITableViewCell
@property (nonatomic,strong) UILabel *moneyLabel;   // 提现金额
@property (nonatomic,strong) UILabel *stateLabel;   // 状态
@property (nonatomic,strong) UILabel *timeLabel;    // 提现时间
@property (nonatomic,strong) UIButton *moreBtn;

@end
