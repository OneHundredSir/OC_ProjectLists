//
//  ReviewIntegralDetailCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-7.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ReviewIntegralDetailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"

@implementation ReviewIntegralDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2, self.frame.size.width, 30)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_nameLabel];
        
        
        _imgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,40, 40, 20)];
        _imgLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _imgLabel.layer.cornerRadius = 3.0f;
        _imgLabel.layer.masksToBounds = YES;
        _imgLabel.adjustsFontSizeToFitWidth = YES;
        _imgLabel.textAlignment = NSTextAlignmentCenter;
        _imgLabel.textColor = [UIColor grayColor];
        _imgLabel.backgroundColor = KblackgroundColor;
        [self addSubview:_imgLabel];
        
        
        _depictLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,40, 180, 20)];
        _depictLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _depictLabel.textAlignment = NSTextAlignmentLeft;
        _depictLabel.textColor = [UIColor grayColor];
        [self addSubview:_depictLabel];
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(MSWIDTH-35, 20, 30, 30);
        [_moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateHighlighted];
        [self addSubview:_moreBtn];
        
    }
    return self;
}
@end
