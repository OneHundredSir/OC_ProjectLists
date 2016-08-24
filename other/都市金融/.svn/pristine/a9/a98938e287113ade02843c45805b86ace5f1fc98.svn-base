//
//  AJDailyManagerHeader.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "ColorTools.h"
#define kbottomBgColor @"#c64037"
#define kRechargeColor @"#63caff"
#define krateColor @"#646464"
#define krateTextColor @"#969696"
#import "AJDailyManagerHeader.h"
#import "AJDailyManagerHeaderData.h"
@interface AJDailyManagerHeader ()
// 1 钱包总额amount
@property (nonatomic, weak) UILabel *accountAmount;
// 2 钱包总额amount文字
@property (nonatomic, weak) UILabel *amountText;
// 3.利息View
@property (nonatomic, weak) UIView *interestV;
// 4今日利息
@property (nonatomic, weak) UILabel *tadayIncome;
// 4今日利息(元)
@property (nonatomic, weak) UILabel *tadayIncomeText;
// 5累计利息
@property (nonatomic, weak) UILabel *totalIncome;
// 5累计利息（元）
@property (nonatomic, weak) UILabel *totalIncomeText;
// 6底部收益率、起始金额view
@property (nonatomic, weak) UIView *bottomView;
// 7年化收益率
@property (nonatomic, weak) UILabel *rate;
// 7年化收益率
@property (nonatomic, weak) UILabel *rateText;
// 8起始金额
@property (nonatomic, weak) UILabel *baseMoney;
// 8起始金额
@property (nonatomic, weak) UILabel *baseMoneyText;

@end

@implementation AJDailyManagerHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KColor;
        //1 钱包总额amount
        UILabel *accountAmount = [[UILabel alloc] init];
        accountAmount.font = [UIFont systemFontOfSize:28];
        accountAmount.textColor = [UIColor whiteColor];
        accountAmount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:accountAmount];
        self.accountAmount = accountAmount;
        self.accountAmount.text = @"000000.00";
        //2 钱包总额（元
        UILabel *amountText = [[UILabel alloc] init];
        amountText.font = [UIFont systemFontOfSize:14];
        amountText.textColor = [UIColor whiteColor];
        amountText.textAlignment = NSTextAlignmentCenter;
        amountText.text = @"钱包总额（元）";
        [self addSubview:amountText];
        self.amountText = amountText;
        // 收益余额
        [self initInterestV];
        // 提现 明细
        [self initBottomView];
    }
    return self;
}
- (void)initBottomView
{
    // 3.利息View
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    //利率
    UILabel *rate = [[UILabel alloc] init];
    rate.font = [UIFont systemFontOfSize:18];
    rate.textColor = [ColorTools colorWithHexString:krateColor];
    rate.backgroundColor = [UIColor clearColor];
    rate.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:rate];
    self.rate = rate;
    self.rate.text = @"5.0%";
    // 利率文字
    UILabel * rateText= [[UILabel alloc] init];
    rateText.font = self.tadayIncomeText.font;
    rateText.textColor = [ColorTools colorWithHexString:krateTextColor];
    rateText.backgroundColor = [UIColor clearColor];
    rateText.textAlignment = NSTextAlignmentCenter;
    rateText.text = @"预期年化收益率";
    [bottomView addSubview:rateText];
    self.rateText = rateText;
    //起始金额
    UILabel *baseMoney = [[UILabel alloc] init];
    baseMoney.font = self.rate.font;
    baseMoney.textColor = self.rate.textColor;
    baseMoney.backgroundColor = [UIColor clearColor];
    baseMoney.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:baseMoney];
    self.baseMoney = baseMoney;
    self.baseMoney.text = @"000.00";
    // 起始金额（元）
    UILabel * baseMoneyText= [[UILabel alloc] init];
    baseMoneyText.font = self.rateText.font;
    baseMoneyText.textColor = self.rateText.textColor;
    baseMoneyText.backgroundColor = [UIColor clearColor];
    baseMoneyText.textAlignment = NSTextAlignmentCenter;
    baseMoneyText.text = @"起始加入金额（元）";
    [bottomView addSubview:baseMoneyText];
    self.baseMoneyText = baseMoneyText;
}
- (void)initInterestV
{
    //利息view
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    view.backgroundColor = [ColorTools colorWithHexString:kbottomBgColor];
    self.interestV = view;
    //今日利息
    UILabel *income = [[UILabel alloc] init];
    income.font = [UIFont systemFontOfSize:20];
    income.textColor = [UIColor whiteColor];
    income.backgroundColor = [UIColor clearColor];
    income.textAlignment = NSTextAlignmentCenter;
    [view addSubview:income];
    self.tadayIncome = income;
    self.tadayIncome.text = @"000.00";
    // 今日利息文字
    UILabel * todayIncomeText= [[UILabel alloc] init];
    todayIncomeText.font = [UIFont systemFontOfSize:13];
    todayIncomeText.textColor = [UIColor whiteColor];
    todayIncomeText.backgroundColor = [UIColor clearColor];
    todayIncomeText.textAlignment = NSTextAlignmentCenter;
    todayIncomeText.text = @"今日利息（元）";
    [view addSubview:todayIncomeText];
    self.tadayIncomeText = todayIncomeText;
    //累计利息
    UILabel *totalIncome = [[UILabel alloc] init];
    totalIncome.font = self.tadayIncome.font;
    totalIncome.textColor = [UIColor whiteColor];
    totalIncome.backgroundColor = [UIColor clearColor];
    totalIncome.textAlignment = NSTextAlignmentCenter;
    [view addSubview:totalIncome];
    self.totalIncome = totalIncome;
    self.totalIncome.text = @"000.00";
    // 累计利息（元）
    UILabel * totalIncomeText= [[UILabel alloc] init];
    totalIncomeText.font = self.tadayIncomeText.font;
    totalIncomeText.textColor = [UIColor whiteColor];
    totalIncomeText.backgroundColor = [UIColor clearColor];
    totalIncomeText.textAlignment = NSTextAlignmentCenter;
    totalIncomeText.text = @"累计利息（元）";
    [view addSubview:totalIncomeText];
    self.totalIncomeText = totalIncomeText;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
//    CGFloat selfH = self.bounds.size.height;
    //1 钱包总额amount
    CGFloat top = 30.f/2;
    self.accountAmount.frame = CGRectMake(0, top, selfW, 54.f/2);
    //2 钱包总额（元
    self.amountText.frame = CGRectMake(0, CGRectGetMaxY(self.accountAmount.frame) + 5, selfW, 38.f/2);
    //利息view
    CGFloat interestH = 130.f/2;
   self.interestV.frame = CGRectMake(0, CGRectGetMaxY(self.amountText.frame) + 50.f/2, selfW, interestH);
    //今日利息
    CGFloat tadayIncomeY = 20.f/2;
    CGFloat tadayIncomeH = 42.f/2;
   self.tadayIncome.frame = CGRectMake(0, tadayIncomeY, selfW/2, tadayIncomeH);
    // 今日利息文字
    CGFloat tadayIncomeTextH = 30.f/2;
    self.tadayIncomeText.frame = CGRectMake(0, CGRectGetMaxY(self.tadayIncome.frame) + 5, selfW/2, tadayIncomeTextH);
    //累计利息
    self.totalIncome.frame = CGRectMake(selfW/2, tadayIncomeY, selfW/2, tadayIncomeH);
    // 累计利息（元）
   self.totalIncomeText.frame = CGRectMake(selfW/2, CGRectGetMaxY(self.tadayIncome.frame) + 5, selfW/2, tadayIncomeTextH);
    // 3.利率、起始金额View
   self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.interestV.frame), selfW, interestH);
    //利率
   self.rate.frame = CGRectMake(0, tadayIncomeY, selfW/2, tadayIncomeH);
    // 利率文字
   self.rateText.frame = CGRectMake(0, CGRectGetMaxY(self.tadayIncome.frame) + 5, selfW/2, tadayIncomeTextH);
    //起始金额
    self.baseMoney.frame = CGRectMake(selfW/2, tadayIncomeY, selfW/2, tadayIncomeH);
    // 起始金额（元）
    self.baseMoneyText.frame =  CGRectMake(selfW/2, CGRectGetMaxY(self.tadayIncome.frame) + 5, selfW/2, tadayIncomeTextH);
}

//- (instancetype)initWithDelegate:(id)delegate
//{
//    if (self = [super init]) {
////        self.delegate = delegate;
//    }
//    return self;
//}
//+ (instancetype)headerViewWithDelegate:(id)delegate
//{
//    return [[self alloc] initWithDelegate:delegate];
//}
- (void)setAAJDailyManagerHeaderData:(AJDailyManagerHeaderData *)aAJDailyManagerHeaderData
{
    _aAJDailyManagerHeaderData = aAJDailyManagerHeaderData;
    if ([aAJDailyManagerHeaderData.isBorrower intValue] == 1) {// 是借款人
        self.amountText.text = @"钱包支付总额（元）";
        self.tadayIncomeText.text = @"今日付利息（元）";
        self.totalIncomeText.text = @"总付利息（元）";
    }else{
        self.amountText.text = @"钱包总额（元）";
        self.tadayIncomeText.text = @"今日利息（元）";
        self.totalIncomeText.text = @"累计利息（元）";
        }
    self.accountAmount.text = aAJDailyManagerHeaderData.balance;
    self.tadayIncome.text = aAJDailyManagerHeaderData.interest;
    self.totalIncome.text = aAJDailyManagerHeaderData.total_interest;
    self.rate.text = [NSString stringWithFormat:@"%@%@",aAJDailyManagerHeaderData.year_apr, @"%"];
    self.baseMoney.text = aAJDailyManagerHeaderData.min_invest_amount;
}
@end
