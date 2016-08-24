//
//  AuditDataPointsCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AuditDataPointsCell.h"

@implementation AuditDataPointsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _DocumentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, self.frame.size.width, 20)];
        _DocumentNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _DocumentNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_DocumentNameLabel];
        
        
        _backView = [[UIImageView alloc] init];
        _backView.frame =CGRectMake(MSWIDTH-150, 5, 25, 25);
        [_backView setImage:[UIImage imageNamed:@"integral_red_back"]];
        [self addSubview:_backView];
        
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 3, 25, 20)];
        _scoreLabel.textColor = [UIColor whiteColor];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.font = [UIFont boldSystemFontOfSize:10.5f];
        [_backView addSubview:_scoreLabel];
        
//        _backView = [[UIImageView alloc] init];
//        _backView.frame =CGRectMake(100, 2, 30, 30);
//        [_backView setImage:[UIImage imageNamed:@"integral_red_back"]];
//        [self addSubview:_backView];
//        
//        
//        
//        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, 30, 20)];
//        _scoreLabel.textColor = [UIColor whiteColor];
//        _scoreLabel.font = [UIFont boldSystemFontOfSize:12.0f];
//        [_backView addSubview:_scoreLabel];
        
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH - 80, 8, 80, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,35, 250, 18)];
        _resultLabel.font = [UIFont systemFontOfSize:14.0f];
        _resultLabel.textAlignment = NSTextAlignmentLeft;
        _resultLabel.textColor = [UIColor grayColor];
        [self addSubview:_resultLabel];
        
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
