//
//  WithdrawRecordsCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-5.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "WithdrawRecordsCell.h"

@implementation WithdrawRecordsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, self.frame.size.width, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
        
        
        UILabel *stateTextlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 40, 20)];
        stateTextlabel.font = [UIFont boldSystemFontOfSize:14.0f];
        stateTextlabel.text = @"状态:";
        [self addSubview:stateTextlabel];
        
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,32, 200, 20)];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.textColor = [UIColor grayColor];
        [self addSubview:_stateLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-40, 8, 80, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(MSWIDTH-35, 25, 30, 30);
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
