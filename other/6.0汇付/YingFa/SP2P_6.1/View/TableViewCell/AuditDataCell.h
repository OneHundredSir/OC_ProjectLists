//
//  AuditDataCell.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditDataCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *validLabel;
@property (nonatomic,strong) UIImageView *stateView;
@property (nonatomic,strong) UILabel *timeLabel;
@end
