//
//  BankCardManageCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-5.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BankCardManageCell.h"
#import "ColorTools.h"

@implementation BankCardManageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *banknametext = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 80, 30)];
        banknametext.font = [UIFont boldSystemFontOfSize:14.0f];
        banknametext.text = @"银行名称:";
        [self addSubview:banknametext];
        
        _banknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 130, 30)];
        _banknameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _banknameLabel.textColor = [UIColor grayColor];
        _banknameLabel.numberOfLines = 0;
        _banknameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _bankNumLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_banknameLabel];
        
        UILabel *bankNumtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 50, 30)];
        bankNumtext.font = [UIFont boldSystemFontOfSize:14.0f];
        bankNumtext.text = @"账号:";
        [self addSubview:bankNumtext];
        
        _bankNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 45, 180, 30)];
        _bankNumLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _bankNumLabel.textColor = [UIColor grayColor];
        [self addSubview:_bankNumLabel];
        
        
        UILabel *nametext = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 60, 30)];
        nametext.font = [UIFont boldSystemFontOfSize:14.0f];
        nametext.text = @"收款人:";
        [self addSubview:nametext];
        
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 75, 150, 30)];
        _NameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _NameLabel.textColor = [UIColor grayColor];
        [self addSubview:_NameLabel];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(MSWIDTH-90, 0, 70, 120)];
        _backView.backgroundColor = GreenColor;
        [self addSubview:_backView];
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(MSWIDTH -95, 0, 75, 120);
        [_editBtn setImage:[UIImage imageNamed:@"bankcard_edit"] forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"bankcard_edit"] forState:UIControlStateSelected];
        [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0 ,0)];
        
        [self addSubview:_editBtn];
        
        
        UILabel *editLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH - 72, 65, 30, 30)];
        editLabel.text = @"编辑";
        editLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        editLabel.textColor = [UIColor whiteColor];
        [self addSubview:editLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _backView.backgroundColor = GreenColor;
    
}

@end
