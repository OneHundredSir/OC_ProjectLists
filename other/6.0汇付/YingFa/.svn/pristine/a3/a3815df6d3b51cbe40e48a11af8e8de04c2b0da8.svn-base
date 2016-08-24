//
//  SuccessfullyTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "SuccessfullyTableViewCell.h"

@implementation SuccessfullyTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 180, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        _typeView = [[UIImageView alloc] initWithFrame:CGRectMake(190, 8, 15, 15)];
        [self addSubview:_typeView];
        
        _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 31, 37, 18)];
        [self addSubview:_statusView];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
        
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 50, 20)];
        _periodLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _periodLabel.textColor = [UIColor grayColor];
        [self addSubview:_periodLabel];
        
        UILabel *timeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 30, 100, 20)];
        timeTextLabel.text = @"年利率：";
        timeTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        timeTextLabel.textColor  = [UIColor grayColor];
        [self addSubview:timeTextLabel];
        
        _aprLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 30, 200, 20)];
        _aprLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _aprLabel.textColor = [UIColor grayColor];
        _aprLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_aprLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
