//
//  BorrowDetailsCell.m
//  SP2P_7
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BorrowDetailsCell.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>
@implementation BorrowDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        _headimgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headimgBtn.frame = CGRectMake(5, 5, 60, 60);
        _headimgBtn.backgroundColor = [UIColor whiteColor];
        [_headimgBtn.layer setMasksToBounds:YES];
        [_headimgBtn.layer setCornerRadius:30.0]; //设置矩形四个圆角半径
        [_headimgBtn setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
        [self addSubview:_headimgBtn];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(5, 70, 60, 18);
        _attentionBtn.backgroundColor = BrownColor;
        [_attentionBtn setTitle:@"+加关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _attentionBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
        [_attentionBtn.layer setMasksToBounds:YES];
        [_attentionBtn.layer setCornerRadius:3.0];
        [self addSubview:_attentionBtn];
        
        // 用户名
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 65, 40)];
        _NameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12.0];
        _NameLabel.numberOfLines = 0;
        _NameLabel.adjustsFontSizeToFitWidth = YES;
        _NameLabel.textColor = KColor;
        [self addSubview:_NameLabel];
        
        _borrowRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,35, 190, 30)];
        _borrowRecordLabel.text = @"贷款记录:";
        _borrowRecordLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_borrowRecordLabel];
        
        _repayRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,60, 190, 30)];
        _repayRecordLabel.text = @"还款记录:";
        _repayRecordLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_repayRecordLabel];

        
        
        _vipView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 10, 20, 20)];
//        _vipView.image = [UIImage imageNamed:@"member_vip"];
        [self addSubview:_vipView];
        
        
        _LevelimgView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 20, 20)];
        //_MemberimgView.backgroundColor = [UIColor redColor];
        [self addSubview:_LevelimgView];
        
        
        _ReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ReportBtn.frame = CGRectMake(250, 5, 30, 30);
        //_ReportBtn.backgroundColor = [UIColor blueColor];
        [self addSubview:_ReportBtn];
        
        
        _MailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MailBtn.frame = CGRectMake(280, 5, 30, 30);
        //_MailBtn.backgroundColor = [UIColor blueColor];
        [self addSubview:_MailBtn];
        
        
        
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
