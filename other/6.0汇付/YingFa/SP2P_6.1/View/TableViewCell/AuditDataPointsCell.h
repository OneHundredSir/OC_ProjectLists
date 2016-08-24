//
//  AuditDataPointsCell.h
//  SP2P_6.1
//
//  Created by Jerry on 14-8-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuditDataPointsCell : UITableViewCell

@property (nonatomic,strong) UILabel *DocumentNameLabel;
@property (nonatomic,strong) UIImageView *backView;
@property (nonatomic,strong) UILabel *scoreLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *resultLabel;

@end
