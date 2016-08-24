//
//  BorrowingBillDetailViewController.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 借款标详情
//

#import "BorrowingBillDetailViewController.h"

#import "ColorTools.h"

@interface BorrowingBillDetailViewController ()

@property (nonatomic, strong) UILabel *borrowTitle;  // 借款标标题
@property (nonatomic, strong) UILabel *borrowAmount;  // 借款总额
@property (nonatomic, strong) UILabel *interestSum;  // 本息合计
@property (nonatomic, strong) UILabel *borrowNum;  // 借款期数

@property (nonatomic, strong) UILabel *annualRate;  // 年利率
@property (nonatomic, strong) UILabel *eachPayment;  // 每期还款
@property (nonatomic, strong) UILabel *paidPeriods;  // 已还期数
@property (nonatomic, strong) UILabel *remainPeriods;  // 剩余期数

@end

@implementation BorrowingBillDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];

}

/**
 * 初始化数据
 */
- (void)initData
{
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    _borrowTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, MSWIDTH-30, 30)];
    _borrowTitle.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowTitle.textColor = [UIColor grayColor];
    _borrowTitle.text = [NSString stringWithFormat:@"借款标标题：%@",_billDetail.bidTitle];
    [self.view addSubview:_borrowTitle];
    
    _borrowAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, MSWIDTH-30, 30)];
    _borrowAmount.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowAmount.textColor = [UIColor grayColor];
    _borrowAmount.text = [NSString stringWithFormat:@"借款总额：%@ 元",_billDetail.loanAmount];
    [self.view addSubview:_borrowAmount];
    
    _interestSum = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, MSWIDTH-30, 30)];
    _interestSum.font = [UIFont boldSystemFontOfSize:14.0f];
    _interestSum.textColor = [UIColor grayColor];
    _interestSum.text = [NSString stringWithFormat:@"本息合计：%@ 元",_billDetail.loanPrincipalInterest];
    [self.view addSubview:_interestSum];
    
    _borrowNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 220, 30)];
    _borrowNum.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowNum.textColor = [UIColor grayColor];
    _borrowNum.text = [NSString stringWithFormat:@"借款期数：%ld 期",(long)_billDetail.loanPeriods];
    [self.view addSubview:_borrowNum];
    
    _annualRate = [[UILabel alloc] initWithFrame:CGRectMake(15, 210, 220, 30)];
    _annualRate.font = [UIFont boldSystemFontOfSize:14.0f];
    _annualRate.textColor = [UIColor grayColor];
    _annualRate.text = [NSString stringWithFormat:@"年利率：%.f%%",_billDetail.apr];
    [self.view addSubview:_annualRate];
    
    _eachPayment = [[UILabel alloc] initWithFrame:CGRectMake(15, 245, MSWIDTH-30, 30)];
    _eachPayment.font = [UIFont boldSystemFontOfSize:14.0f];
    _eachPayment.textColor = [UIColor grayColor];
    _eachPayment.text = [NSString stringWithFormat:@"每期还款：%@ 元",_billDetail.currentPayAmount];
    [self.view addSubview:_eachPayment];
    
    _paidPeriods = [[UILabel alloc] initWithFrame:CGRectMake(15, 280, 220, 30)];
    _paidPeriods.font = [UIFont boldSystemFontOfSize:14.0f];
    _paidPeriods.textColor = [UIColor grayColor];
    _paidPeriods.text = [NSString stringWithFormat:@"已还期数：%ld 期",(long)_billDetail.hasPayedPeriods];
    [self.view addSubview:_paidPeriods];
    
    _remainPeriods = [[UILabel alloc] initWithFrame:CGRectMake(15, 315, 220, 30)];
    _remainPeriods.font = [UIFont boldSystemFontOfSize:14.0f];
    _remainPeriods.textColor = [UIColor grayColor];
    _remainPeriods.text = [NSString stringWithFormat:@"剩余期限：%ld 期",(long)_billDetail.remainPeriods];
    [self.view addSubview:_remainPeriods];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款标详细情况";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
