//
//  FundRecordCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-5.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FundRecordCell.h"

@implementation FundRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, self.frame.size.width, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
        
        
        _wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,32, 200, 20)];
        _wayLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _wayLabel.textAlignment = NSTextAlignmentLeft;
        _wayLabel.textColor = [UIColor grayColor];
        [self addSubview:_wayLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-40, 8, 80, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(285, 25, 30, 30);
        [_moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateHighlighted];
        [self addSubview:_moreBtn];
        
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
