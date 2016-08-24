//
//  CreditRatingRuleCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-7.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditRatingRuleCell.h"

@implementation CreditRatingRuleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _RatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, self.frame.size.width, 25)];
        _RatingLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _RatingLabel.textAlignment = NSTextAlignmentLeft;
        _RatingLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_RatingLabel];
        
        _RatingImg = [[UIImageView alloc] init];
        _RatingImg.frame = CGRectMake(8, 35, 25, 25);
        [self addSubview:_RatingImg];
    
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(MSWIDTH-35, 20, 30, 30);
        [_moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateHighlighted];
        [self addSubview:_moreBtn];
    }
    return self;
}



@end
