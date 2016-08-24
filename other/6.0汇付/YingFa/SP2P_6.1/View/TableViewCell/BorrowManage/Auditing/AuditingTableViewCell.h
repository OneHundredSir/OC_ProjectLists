//
//  AuditingTableViewCell.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface AuditingTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *typeView;
@property (nonatomic,strong) UILabel *nopostLabel;
@property (nonatomic,strong) UILabel *nopassLabel;
@property (nonatomic,strong) UIImageView *roundimgView;
@property (nonatomic,strong) UILabel *progressLabel;

@end
