//
//  BidRecordsCell.m
//  SP2P_7
//
//  Created by Jerry on 14-7-31.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BidRecordsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"

@implementation BidRecordsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _moneyLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_moneyLabel];
        
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 200, 20)];
        _numLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _numLabel.textColor = [UIColor grayColor];
        [self addSubview:_numLabel];
        
        _stateView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 40, 20)];
        [self addSubview:_stateView];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 50, 20)];
        _stateLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel];
        
        _billidLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 30, 115, 20)];
        _billidLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _billidLabel.textColor = [UIColor grayColor];
        _billidLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_billidLabel];
    }
    return self;
}

- (void)setStateColor:(int) status {
    
    switch (status) {
        case -1:
            _stateLabel.backgroundColor = BrownColor;
            break;
        case 0:
            _stateLabel.backgroundColor = [UIColor lightGrayColor];
            break;
        case 1:
            _stateLabel.backgroundColor = [UIColor redColor];
            break;
    }
}

@end
