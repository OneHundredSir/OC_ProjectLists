//
//  AuditDataCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AuditDataCell.h"
#import "ColorTools.h"
@implementation AuditDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        

        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        

        _validLabel= [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 80, 20)];
        _validLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_validLabel];
        
        
        
        _stateView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 32, 40, 20)];
        [self addSubview:_stateView];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 200, 20)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
       
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _validLabel.font = [UIFont boldSystemFontOfSize:14.0f];
   _timeLabel.textColor = [UIColor grayColor];


}

@end
