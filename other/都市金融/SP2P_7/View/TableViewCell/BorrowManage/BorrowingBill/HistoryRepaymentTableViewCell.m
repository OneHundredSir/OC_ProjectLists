//
//  HistoryRepaymentTableViewCell.m
//  SP2P_7
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "HistoryRepaymentTableViewCell.h"
#import "HistoryRepayment.h"
#import "UIImage+AJ.h"
// 还款状态	-1，-2未还款,否则为已还款
#define Repayment_None1 -1
#define Repayment_None2 -2

// overdue	逾期状态	0不是, 其他为逾期
#define Overdue_None 0
@implementation HistoryRepaymentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width - 30, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];

        _repayView = [UIButton buttonWithType:UIButtonTypeCustom];
        _repayView.highlighted = NO;
        _repayView.adjustsImageWhenHighlighted = NO;
        [_repayView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _repayView.layer.cornerRadius = 5;
        _repayView.titleLabel.font = [UIFont systemFontOfSize:13];
        _repayView.layer.masksToBounds = YES;
        _repayView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self addSubview:_repayView];
        
        CGFloat _overdueViewW = 20.f;
        CGFloat _overdueViewX = 10;
        _overdueView = [[UIImageView alloc] initWithFrame:CGRectMake(_overdueViewX, 32, _overdueViewW, _overdueViewW)];
        [self addSubview:_overdueView];
        
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
        
        CGFloat _timeLabelX = CGRectGetMaxX(_moneyLabel.frame);
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabelX, 30, MSWIDTH - _timeLabelX - 10, 20)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        [self addSubview:_timeLabel];
        
    }
    return self;
}

- (void)setAHistoryRepayment:(HistoryRepayment *)aHistoryRepayment
{
    _aHistoryRepayment = aHistoryRepayment;

    self.titleLabel.text = [NSString stringWithFormat:@"%@（第%ld期）", aHistoryRepayment.title ,(long)aHistoryRepayment.period];
    
    CGFloat _repayViewH = self.overdueView.bounds.size.height;
    CGFloat _repayViewW = 47.f;
    CGFloat repayViewY = self.overdueView.frame.origin.y;
    if(aHistoryRepayment.overdueMark == Overdue_None){
        // 未逾期
        self.overdueView.hidden = YES;
        self.repayView.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), repayViewY, _repayViewW, _repayViewH);
    }else {
        // 逾期
        self.overdueView.hidden = NO;
        self.overdueView.image = [UIImage imageNamed:@"state_exceed"];
        self.repayView.frame = CGRectMake(CGRectGetMaxX(self.overdueView.frame) + 6, repayViewY, _repayViewW, _repayViewH);
    }
    
    self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.repayView.frame)+12, repayViewY, 100, 20);
    
    UIImage *bgImgGreen = [UIImage imageWithColor:kAttentionColor];
    UIImage *bgImgRed = [UIImage imageWithColor:GreenColor];
    if (aHistoryRepayment.status == Repayment_None1 || aHistoryRepayment.status == Repayment_None2) {
        [self.repayView setTitle:@"未还款" forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgRed forState:UIControlStateNormal];
    }else{
        
        [self.repayView setTitle:@"已还款" forState:UIControlStateNormal];
        [self.repayView setBackgroundImage:bgImgGreen forState:UIControlStateNormal];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"￥ %@元",aHistoryRepayment.currentPayAmount];
    self.timeLabel.text = aHistoryRepayment.repaymentTime;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HistoryRepaymentTableViewCell";
    HistoryRepaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HistoryRepaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
@end
