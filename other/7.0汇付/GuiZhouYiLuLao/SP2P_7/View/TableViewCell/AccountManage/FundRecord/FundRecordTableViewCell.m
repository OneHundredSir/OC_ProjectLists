//
//  FundRecordTableViewCell.m
//  SP2P_7
//
//  Created by 李小斌 on 14-10-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FundRecordTableViewCell.h"

@implementation FundRecordTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-130,8, 100, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = [UIColor grayColor];
        _moneyLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_moneyLabel];
        
        
        _wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, MSWIDTH - 140, 20)];
        _wayLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _wayLabel.textAlignment = NSTextAlignmentLeft;
        _wayLabel.textColor = [UIColor blackColor];
        [self addSubview:_wayLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 120, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
//        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _moreBtn.frame = CGRectMake(MSWIDTH - 35, 25, 30, 30);
//        [_moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
//        [_moreBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateHighlighted];
//        [self addSubview:_moreBtn];
        
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
