//
//  AJDailyEarningRepayDoneCell.m
//  SP2P_7
//
//  Created by Ajax on 16/1/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJDailyEarningRepayDoneCell.h"
#import "AJDailyEarningRepayOut.h"
#define ktextColor @"#646464"

@interface AJDailyEarningRepayDoneCell ()
// 投资人
@property (nonatomic, weak) UILabel *investor;
// 申请时间
@property (nonatomic, weak) UILabel *time;
// 投资金额
@property (nonatomic, weak) UILabel *investMoney;
// 转出金额
@property (nonatomic, weak) UILabel *TransferMoney;
@end
@implementation AJDailyEarningRepayDoneCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        self.contentView.backgroundColor = [UIColor redColor];
        //  投资人
        UILabel *investor=  [[UILabel alloc] init];
        investor.font = [UIFont boldSystemFontOfSize:14];
        investor.textColor = [ColorTools colorWithHexString:ktextColor];
        investor.backgroundColor = [UIColor clearColor];
        investor.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:investor];
        self.investor = investor;
        self.investor.text = @"投资人：lhh";
        //  投资时间
        UILabel *time=  [[UILabel alloc] init];
        time.font = investor.font;
        time.textColor = investor.textColor;
        time.backgroundColor = [UIColor clearColor];
        time.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:time];
        self.time = time;
        self.time.text = @"申请时间：2016-01-15";
        // 投资金额
        UILabel *investMoney=  [[UILabel alloc] init];
        investMoney.font = investor.font;
        investMoney.textColor = investor.textColor;
        investMoney.backgroundColor = [UIColor clearColor];
        investMoney.textAlignment = NSTextAlignmentLeft;
        //        [self.contentView addSubview:investMoney];
        self.investMoney = investMoney;
        self.investMoney.text = @"投资金额：2016";
        // 转出金额
        UILabel *TransferMoney=  [[UILabel alloc] init];
        TransferMoney.font = investor.font;
        TransferMoney.textColor = investor.textColor;
        TransferMoney.backgroundColor = [UIColor clearColor];
        TransferMoney.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:TransferMoney];
        self.TransferMoney = TransferMoney;
        self.TransferMoney.text = @"转出金额：206";
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
    //    CGFloat selfH = self.bounds.size.height;
    //  投资人
    CGFloat padding = 20.f/2;
    CGFloat investorH = 40.f/2;
    self.investor.frame = CGRectMake(padding, padding, 310.f/2 - padding, investorH);
    //  投资时间
    CGFloat timeX = selfW - CGRectGetMaxX(self.investor.frame) -4;
    CGFloat timeW = selfW - timeX;
    self.time.frame = CGRectMake(timeX, padding, timeW, investorH);
    // 投资金额
    CGFloat investMoneyY = CGRectGetMaxY(self.time.frame) + 10.f/2;
    self.investMoney.frame = CGRectMake(padding, investMoneyY, 310.f/2 - padding, investorH);
    // 转出金额
    self.TransferMoney.frame = CGRectMake(timeX, investMoneyY, timeW, investorH);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AJDailyEarningRepayDoneCell";
    AJDailyEarningRepayDoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AJDailyEarningRepayDoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setAAJDailyEarningRepayOut:(AJDailyEarningRepayOut *)aAJDailyEarningRepayOut
{
    _aAJDailyEarningRepayOut = aAJDailyEarningRepayOut;
    
    self.investor.text = [NSString stringWithFormat:@"投资人：%@", aAJDailyEarningRepayOut.Username];
    self.time.text = [NSString stringWithFormat:@"审核时间：%@", aAJDailyEarningRepayOut.Apply_time];
    self.TransferMoney.text =  [NSString stringWithFormat:@"转出金额：%@", aAJDailyEarningRepayOut.Apply_amount];
}

@end
