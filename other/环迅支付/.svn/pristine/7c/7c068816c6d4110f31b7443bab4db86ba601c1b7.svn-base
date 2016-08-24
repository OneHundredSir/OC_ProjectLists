//
//  ApplyRecordCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ApplyRecordCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"

@implementation ApplyRecordCell

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
        
        
        _stateImg = [[UIImageView alloc] initWithFrame:CGRectMake(10,35, 40, 20)];
        [self addSubview:_stateImg];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-70, 8, 80, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(285, 25, 30, 30);
        [_moreBtn setImage:[UIImage imageNamed:@"cell_more_btn"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"cell_more_btn"] forState:UIControlStateHighlighted];
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
