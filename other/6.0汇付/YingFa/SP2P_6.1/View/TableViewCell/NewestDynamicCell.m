//
//  NewestDynamicCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "NewestDynamicCell.h"
#import "ColorTools.h"

@implementation NewestDynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_titleLabel];
        
    
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, self.frame.size.width, 30)];
        _NameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _NameLabel.textColor = BluewordColor;
        [self addSubview:_NameLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, self.frame.size.width, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        _timeLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_timeLabel];
    }
    return self;
}

@end
