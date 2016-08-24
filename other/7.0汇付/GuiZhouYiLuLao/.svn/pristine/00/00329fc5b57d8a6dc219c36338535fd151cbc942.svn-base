//
//  AttentionUserCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-7.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AttentionUserCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation AttentionUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _headImgView.layer.cornerRadius = 25;
        _headImgView.userInteractionEnabled = NO;
        _headImgView.layer.masksToBounds = YES;
        [self addSubview:_headImgView];
        
        
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 30)];
        _NameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _NameLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_NameLabel];
        
        _mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mailBtn.frame = CGRectMake(60, 35, 45, 25) ;
        [_mailBtn setImage:[UIImage imageNamed:@"Loan_mail"] forState:UIControlStateNormal];
        [self addSubview:_mailBtn];
        
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(MSWIDTH-80, 0, 80, self.frame.size.height+20)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bgView];
        
        
        
        UILabel *TextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 20)];
        TextLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        TextLabel.textAlignment = NSTextAlignmentCenter;
        TextLabel.textColor = [UIColor whiteColor];
        TextLabel.text = @"- 已关注";
        [_bgView addSubview:TextLabel];
        
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    
     _bgView.backgroundColor = [UIColor lightGrayColor];




}


@end
