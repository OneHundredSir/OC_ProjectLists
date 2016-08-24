//
//  LiteratureAuditTableViewCell.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiteratureAuditTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *validLabel;
@property (nonatomic,strong) UIImageView *stateView;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *stateLabel;

- (void)setStatus:(int) status;

@end
