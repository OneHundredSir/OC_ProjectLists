//
//  CompletedFinancialCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-31.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CompletedFinancialCell.h"
#import "ColorTools.h"
@implementation CompletedFinancialCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        
        
        _stateImg = [[UIImageView alloc] initWithFrame:CGRectMake(10,35, 40, 20)];
        [self addSubview:_stateImg];
        
        
        _typeImg = [[UIImageView alloc]  initWithFrame:CGRectMake(65, 35, 20, 20)];
        [self addSubview:_typeImg];
        
//        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _moreBtn.frame = CGRectMake(285, 25, 25, 25);
//        [_moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
//        [_moreBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateHighlighted];
//        [self addSubview:_moreBtn];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 200, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
