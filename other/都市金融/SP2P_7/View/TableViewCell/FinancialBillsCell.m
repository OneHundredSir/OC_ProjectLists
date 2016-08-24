//
//  FinancialBillsCell.m
//  SP2P_7
//
//  Created by Jerry on 14-7-31.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FinancialBillsCell.h"
#import "UIImage+AJ.h"
#import "FinancialBills.h"

@implementation FinancialBillsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, MSWIDTH - 140, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        CGFloat _repayViewTring = 35.f;
        _repayView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repayView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _repayView.layer.cornerRadius = 5;
        _repayView.titleLabel.font = [UIFont systemFontOfSize:12];
        _repayView.layer.masksToBounds = YES;
        _repayView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self addSubview:_repayView];
        
        CGFloat _overdueViewW = 20.f;
        CGFloat _overdueViewX = MSWIDTH - _repayViewTring - _overdueViewW;
        _overdueView = [[UIImageView alloc] initWithFrame:CGRectMake(_overdueViewX, 32, _overdueViewW, _overdueViewW)];
        [self addSubview:_overdueView];
        
        CGFloat _moneyLabelX = MSWIDTH/2;
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_moneyLabelX, 7, MSWIDTH - _moneyLabelX - _repayViewTring, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 + 5, 88, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setAFinancialBills:(FinancialBills *)aFinancialBills
{
    _aFinancialBills = aFinancialBills;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", aFinancialBills.title];
    self.timeLabel.text = aFinancialBills.time;
    
    CGFloat _repayViewH = 20.f;
    CGFloat _repayViewW = 47.f;
    CGFloat _repayViewY = self.overdueView.frame.origin.y;
    if(aFinancialBills.status == -2 ||aFinancialBills.status == -3||aFinancialBills.status == -4||aFinancialBills.status == -6){
        // 逾期
        self.overdueView.hidden = NO;
        self.overdueView.image = [UIImage imageNamed:@"state_exceed"];
        
        self.repayView.frame = CGRectMake(CGRectGetMinX(self.overdueView.frame) - _repayViewW - 5, _repayViewY, _repayViewW, _repayViewH);
    }else {
        // 未逾期
        self.overdueView.hidden = YES;
        self.repayView.frame = CGRectMake(CGRectGetMaxX(self.overdueView.frame) - _repayViewW, _repayViewY, _repayViewW, _repayViewH);
    }
    
    UIImage *bgImgGreen = [UIImage imageWithColor:kAttentionColor];
    UIImage *bgImgRed = [UIImage imageWithColor:GreenColor];
    // 状态： 已收款（-3， -4， 0） 已转出（-7）；未收款（其他
    if (aFinancialBills.status == 0||aFinancialBills.status == -3||aFinancialBills.status == -4) {
        [self.repayView setTitle:@"已收款" forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgGreen forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgGreen forState:UIControlStateHighlighted];
    }else if(aFinancialBills.status == -7){
        [self.repayView setTitle:@"已转出" forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgGreen forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgGreen forState:UIControlStateHighlighted];
    }else {
        [self.repayView setTitle:@"未收款" forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgRed forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgRed forState:UIControlStateHighlighted];
        
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",aFinancialBills.incomeAmounts];
}


@end
