//
//  DebtManagementCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "DebtManagementCell.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation DebtManagementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, MSWIDTH-130, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        _stateImg = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH-122,5, 40, 20)];
        [self addSubview:_stateImg];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-124,5, 40, 20)];
        _stateLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        [self addSubview:_stateLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(CGRectGetMaxX(_stateImg.frame)-1, CGRectGetMinY(_stateImg.frame),40, 20);
        _timeLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        _timeLabel.backgroundColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_timeLabel];
        
        _typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 20, 20)];
        [self addSubview:_typeImg];
        
        _typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 35, 20, 20)];
        [_typeBtn setTintColor:[UIColor whiteColor]];
        _typeBtn.layer.cornerRadius = 10;
        _typeBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0];
        [self addSubview:_typeBtn];
        
        _transferLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,35, 125, 20)];
        _transferLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _transferLabel.textAlignment = NSTextAlignmentCenter;
        _transferLabel.textColor = [UIColor grayColor];
        [self addSubview:_transferLabel];
        
        _highestLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-160,35, 150, 20)];
        _highestLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _highestLabel.textAlignment = NSTextAlignmentCenter;
        _highestLabel.textColor = [UIColor grayColor];
        [self addSubview:_highestLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    _timeLabel.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)setStateColor:(int)status {
    switch (status) {
        case -5:
        {
            _stateLabel.backgroundColor = [UIColor redColor];
        }
            break;
        case -3:
        {
            _stateLabel.backgroundColor = [UIColor redColor];
        }
            break;
        case -2:
        {
            _stateLabel.backgroundColor = [UIColor redColor];
        }
            break;
        case -1:
        {
            _stateLabel.backgroundColor = [UIColor redColor];
        }
            break;
        case 0:
        {
            _stateLabel.backgroundColor = GreenColor;
        }
            break;
        case 1:
        {
            _stateLabel.backgroundColor = GreenColor;
        }
            break;
        case 2:
        {
            _stateLabel.backgroundColor = GreenColor;
        }
            break;
        case 3:
        {
            _stateLabel.backgroundColor = KColor;
        }
            break;
        case 4:
        {
            _stateLabel.backgroundColor = KColor;
        }
            break;
    }
}

- (void)typeLabelBack:(int)status {
//    switch (status) {
//        case 0:
//        {
//            _typeBtn.backgroundColor = [UIColor greenColor];
//        }
//            break;
//        case 1:
//        {
//            _typeBtn.backgroundColor = [UIColor lightGrayColor];
//        }
//            break;
//        case 2:
//        {
//            _typeBtn.backgroundColor = [UIColor redColor];
//        }
//            break;
//    }
}

@end
