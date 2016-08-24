//
//  BorrowingBillTableViewCell.m
//  SP2P_7
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BorrowingBillTableViewCell.h"
#import "UIImage+AJ.h"
#import "BorrowingBill.h"

@implementation BorrowingBillTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, MSWIDTH - 140, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];

        CGFloat _repayViewTring = 35.f;
         _repayView = [UIButton buttonWithType:UIButtonTypeCustom];
        _repayView.highlighted = NO;
        _repayView.adjustsImageWhenHighlighted = NO;
        [_repayView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _repayView.layer.cornerRadius = 5;
        _repayView.titleLabel.font = [UIFont systemFontOfSize:14];
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
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 88, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
        
    }
    return self;
}
// overdue	逾期状态	0不是, 其他为逾期
#define Overdue_None 0
- (void)setABorrowingBill:(BorrowingBill *)aBorrowingBill
{
    _aBorrowingBill = aBorrowingBill;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", aBorrowingBill.title];
    self.timeLabel.text = aBorrowingBill.time;
    
    CGFloat _repayViewH = self.overdueView.bounds.size.height;
    CGFloat _repayViewW = 47.f;
    CGFloat repayViewY = self.overdueView.frame.origin.y;
    if(aBorrowingBill.isOverdue == Overdue_None){
        // 未逾期
        self.overdueView.hidden = YES;
        self.repayView.frame = CGRectMake(CGRectGetMaxX(self.overdueView.frame) - _repayViewW, repayViewY, _repayViewW, _repayViewH);
        
    }else {
        // 逾期
         self.overdueView.hidden = NO;
        self.overdueView.image = [UIImage imageNamed:@"state_exceed"];
         self.repayView.frame = CGRectMake(CGRectGetMinX(self.overdueView.frame) - 8 - _repayViewW, repayViewY, _repayViewW, _repayViewH);
    }
    
    // 还款状态	-1，-2未还款,否则为已还款
    UIImage *bgImgGreen = [UIImage imageWithColor:kAttentionColor];
    UIImage *bgImgRed = [UIImage imageWithColor:GreenColor];
    if (aBorrowingBill.status == -1 || aBorrowingBill.status == -2) {//未还款
        
        [self.repayView setTitle:@"未还" forState:UIControlStateNormal];
        [_repayView setBackgroundImage:bgImgRed forState:UIControlStateNormal];
        [_repayView setBackgroundImage:bgImgRed forState:UIControlStateHighlighted];
    }else{// 已还款
        [self.repayView setTitle:@"已还" forState:UIControlStateNormal];
        [_repayView setBackgroundImage:bgImgGreen forState:UIControlStateNormal];
        [_repayView setBackgroundImage:bgImgGreen forState:UIControlStateHighlighted];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",aBorrowingBill.repaymentAmount];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BorrowingBillTableViewCell";
    BorrowingBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BorrowingBillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
@end
