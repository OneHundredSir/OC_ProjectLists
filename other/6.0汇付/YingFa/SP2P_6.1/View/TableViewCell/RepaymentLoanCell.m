//
//  RepaymentLoanCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "RepaymentLoanCell.h"

@implementation RepaymentLoanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        
        _typeView = [[UIImageView alloc] initWithFrame:CGRectMake(190, 8, 15, 15)];
        [self addSubview:_typeView];
        
        
        _LoanView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 31, 18, 18)];
        [self addSubview:_LoanView];
        
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
        
        
        _termLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 50, 20)];
        _termLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _termLabel.textColor = [UIColor grayColor];
        [self addSubview:_termLabel];
        
        
        
        UILabel *timeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 30, 100, 20)];
        timeTextLabel.text = @"还款时间:";
        timeTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        timeTextLabel.textColor  = [UIColor grayColor];
        [self addSubview:timeTextLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 30, 200, 20)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
        
        
        
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
