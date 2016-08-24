//
//  CreditScoreRuleCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-7.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditScoreRuleCell.h"

@implementation CreditScoreRuleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,5, self.frame.size.width, 30)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_nameLabel];
        
        
        _ScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,45, self.frame.size.width, 20)];
        _ScoreLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _ScoreLabel.textAlignment = NSTextAlignmentLeft;
        _ScoreLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_ScoreLabel];
        
        
    }
    return self;
}

@end
