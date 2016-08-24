//
//  BlackListCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BlackListCell.h"

@implementation BlackListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, self.frame.size.width, 20)];
        _NameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _NameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_NameLabel];
        
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,32, 200, 20)];
        _idLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _idLabel.textAlignment = NSTextAlignmentLeft;
        _idLabel.textColor = [UIColor grayColor];
        [self addSubview:_idLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 8, 80, 15)];
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
