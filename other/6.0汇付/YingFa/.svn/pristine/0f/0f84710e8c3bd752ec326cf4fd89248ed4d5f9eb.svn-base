//
//  LiteratureAuditTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "LiteratureAuditTableViewCell.h"

@implementation LiteratureAuditTableViewCell


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
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 60, 20)];
        _stateLabel.font = [UIFont systemFontOfSize:11.0f];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-170, 30, 200, 20)];
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

- (void)setStatus:(int) status {
    switch (status) {
        case 0:
        {
            _stateLabel.backgroundColor = [UIColor redColor];
        }
            break;
        case 1:
        {
            _stateLabel.backgroundColor = [UIColor blueColor];
        }
            break;
        case 2:
        {
            _stateLabel.backgroundColor = [UIColor grayColor];
        }
            break;
        case 3:
        {
            _stateLabel.backgroundColor = [UIColor redColor];
        }
            break;
        case 4:
        {
            _stateLabel.backgroundColor = [UIColor redColor];
        }
            break;
            
        default:
            break;
    }
}


@end
