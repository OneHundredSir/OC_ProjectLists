//
//  AJFinancialBillHistoryCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/29.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJFinancialBillHistoryCell.h"
#import "FinancialBills.h"
#import "UIImage+AJ.h"

@interface AJFinancialBillHistoryCell ()
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIButton *repayView;
@property (nonatomic,weak) UILabel *moneyLabel;
@property (nonatomic, weak) UIImageView *overdueView;
@end
@implementation AJFinancialBillHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.userInteractionEnabled = NO;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:titleLabel];
        self.titleLabel =titleLabel;

        UIButton *repayView = [[UIButton alloc] init];
        [repayView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        repayView.layer.cornerRadius = 5;
        repayView.titleLabel.font = [UIFont systemFontOfSize:12];
        repayView.layer.masksToBounds = YES;
        repayView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self addSubview:repayView];
        self.repayView = repayView;

        CGFloat overdueViewLeading = 10.f;
        CGFloat overdueViewW = 20.f;
        UIImageView *overdueView = [[UIImageView alloc] initWithFrame:CGRectMake(overdueViewLeading, 32, overdueViewW, overdueViewW)];
        [self addSubview:overdueView];
        self.overdueView = overdueView;
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        moneyLabel.textColor = [UIColor grayColor];
        moneyLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:moneyLabel];
        self.moneyLabel = moneyLabel;

    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AJHomeCell";
    AJFinancialBillHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJFinancialBillHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setAFinancialBills:(FinancialBills *)aFinancialBills
{
    _aFinancialBills = aFinancialBills;
    
    self.titleLabel.text = aFinancialBills.title;
    CGFloat selfW = self.bounds.size.width;
    CGFloat leading = 10.f;
    self.titleLabel.frame =CGRectMake(leading, leading, selfW - 2*leading, 20);
    
    CGFloat _repayViewH = 20.f;
    CGFloat _repayViewW = 47.f;
    CGFloat _repayViewY = self.overdueView.frame.origin.y;
    if(aFinancialBills.status == -2 ||aFinancialBills.status == -3||aFinancialBills.status == -4||aFinancialBills.status == -6){
        // 逾期
        self.overdueView.hidden = NO;
        self.overdueView.image = [UIImage imageNamed:@"state_exceed"];
        
        self.repayView.frame = CGRectMake(CGRectGetMaxX(self.overdueView.frame)+ 5, _repayViewY, _repayViewW, _repayViewH);
    }else {
        // 未逾期
        self.overdueView.hidden = YES;
        self.repayView.frame = CGRectMake(CGRectGetMinX(self.overdueView.frame), _repayViewY, _repayViewW, _repayViewH);
    }
    
    CGFloat moneyLabelW = 150;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f元",aFinancialBills.incomeAmounts];
    self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.repayView.frame) + 10, _repayViewY, moneyLabelW, _repayViewH);
    
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
}
@end
