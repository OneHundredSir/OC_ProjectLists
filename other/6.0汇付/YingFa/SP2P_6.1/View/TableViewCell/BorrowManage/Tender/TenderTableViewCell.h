//
//  TenderTableViewCell.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface TenderTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *typeView;
@property (nonatomic,strong) UILabel *nopostLabel;// 未提交的
@property (nonatomic,strong) UILabel *nopassLabel;// 未通过的
@property (nonatomic,strong) UIImageView *roundimgView;
@property (nonatomic,strong) UILabel *progressLabel;

@end
