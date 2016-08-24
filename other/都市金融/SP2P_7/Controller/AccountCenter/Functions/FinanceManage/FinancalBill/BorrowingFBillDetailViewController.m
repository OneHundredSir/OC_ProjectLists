//
//  BorrowingFBillDetailViewController.m
//  SP2P_7
//
//  Created by kiu on 14-10-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 账单详情 -> 借款标详情

#import "BorrowingFBillDetailViewController.h"

@interface BorrowingFBillDetailViewController ()<HTTPClientDelegate>

@property (nonatomic, strong) UILabel *borrowTitle;  // 借款标标题
@property (nonatomic, strong) UILabel *borrowAmount;  // 借款总额
@property (nonatomic, strong) UILabel *interestSum;  // 本息合计
@property (nonatomic, strong) UILabel *borrowNum;  // 借款期数
@property (nonatomic, strong) UILabel *annualRate;  // 年利率
@property (nonatomic, strong) UILabel *eachPayment;  // 每期还款
@property (nonatomic, strong) UILabel *paidPeriods;  // 已还期数
@property (nonatomic, strong) UILabel *remainPeriods;  // 剩余期数

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation BorrowingFBillDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self loadData];
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
    
    _borrowTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 220, 30)];
    _borrowTitle.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowTitle.textColor = [UIColor grayColor];
    _borrowTitle.text = @"借款标标题:";
    [self.view addSubview:_borrowTitle];
    
    _borrowAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, 220, 30)];
    _borrowAmount.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowAmount.textColor = [UIColor grayColor];
    _borrowAmount.text = @"借款总额:";
    [self.view addSubview:_borrowAmount];
    
    _interestSum = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 220, 30)];
    _interestSum.font = [UIFont boldSystemFontOfSize:14.0f];
    _interestSum.textColor = [UIColor grayColor];
    _interestSum.text = @"本息合计:";
    [self.view addSubview:_interestSum];
    
    _borrowNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 220, 30)];
    _borrowNum.font = [UIFont boldSystemFontOfSize:14.0f];
    _borrowNum.textColor = [UIColor grayColor];
    _borrowNum.text = @"借款期数:";
    [self.view addSubview:_borrowNum];
    
    _annualRate = [[UILabel alloc] initWithFrame:CGRectMake(15, 210, 220, 30)];
    _annualRate.font = [UIFont boldSystemFontOfSize:14.0f];
    _annualRate.textColor = [UIColor grayColor];
    _annualRate.text = @"年利率:";
    [self.view addSubview:_annualRate];
    
    _eachPayment = [[UILabel alloc] initWithFrame:CGRectMake(15, 245, 220, 30)];
    _eachPayment.font = [UIFont boldSystemFontOfSize:14.0f];
    _eachPayment.textColor = [UIColor grayColor];
    _eachPayment.text = @"每期还款:";
    [self.view addSubview:_eachPayment];
    
    _paidPeriods = [[UILabel alloc] initWithFrame:CGRectMake(15, 280, 220, 30)];
    _paidPeriods.font = [UIFont boldSystemFontOfSize:14.0f];
    _paidPeriods.textColor = [UIColor grayColor];
    _paidPeriods.text = @"已还期数:";
    [self.view addSubview:_paidPeriods];
    
    _remainPeriods = [[UILabel alloc] initWithFrame:CGRectMake(15, 315, 220, 30)];
    _remainPeriods.font = [UIFont boldSystemFontOfSize:14.0f];
    _remainPeriods.textColor = [UIColor grayColor];
    _remainPeriods.text = @"剩余期限:";
    [self.view addSubview:_remainPeriods];
    
    for (UIView *view in self.view.subviews) {
        CGRect frame = view.frame;
        frame.origin.y -= 64.f;
        view.frame = frame;
    }
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款标详细情况";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 加载数据
 */
- (void)loadData
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"38" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_kId forKey:@"id"];
        [parameters setObject:_billId forKey:@"billId"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        if (![[obj objectForKey:@"borrowTitle"] isEqual:[NSNull null]]){
            _borrowTitle.text = [NSString stringWithFormat: @"借款标标题: %@", [obj objectForKey:@"borrowTitle"]];
        }
        
        _borrowAmount.text = [NSString stringWithFormat: @"借款总额: %@元", [obj objectForKey:@"borrowAmount"]];
        _interestSum.text = [NSString stringWithFormat: @"本息合计: %@元", [obj objectForKey:@"interestSum"]];
        _borrowNum.text = [NSString stringWithFormat: @"借款期数: %@期", [obj objectForKey:@"borrowNum"]];
        _annualRate.text = [NSString stringWithFormat: @"年利率: %.1f%@", [obj[@"annualRate"] doubleValue], @"%"];
        _eachPayment.text = [NSString stringWithFormat: @"每期还款: %@ 元", [obj objectForKey:@"eachPayment"]];
        _paidPeriods.text = [NSString stringWithFormat: @"已还期数: %@期", [obj objectForKey:@"paidPeriods"]];
        _remainPeriods.text = [NSString stringWithFormat: @"剩余期限: %@期", [obj objectForKey:@"remainPeriods"]];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
   [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
