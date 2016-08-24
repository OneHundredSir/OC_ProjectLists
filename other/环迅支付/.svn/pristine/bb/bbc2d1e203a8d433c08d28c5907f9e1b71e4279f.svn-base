//
//  FinancialBillsCell.m
//  SP2P_7
//
//  Created by Jerry on 14-7-31.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FinancialBillsCell.h"

@implementation FinancialBillsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, MSWIDTH - 140, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        
        _overdueView = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH-100, 32, 20, 20)];
        [self addSubview:_overdueView];
        
        
        _repayView = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH-70, 32, 30, 20)];
        [self addSubview:_repayView];
        
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-130,8, 100, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 88, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
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
