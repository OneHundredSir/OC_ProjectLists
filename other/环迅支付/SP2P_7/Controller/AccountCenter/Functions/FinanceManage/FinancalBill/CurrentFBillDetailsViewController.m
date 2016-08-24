//
//  CurrentFBillDetailsViewController.m
//  SP2P_7
//
//  Created by kiu on 14-10-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  理财子账户 -> 理财账单 -> 本期理财账单明细

#import "CurrentFBillDetailsViewController.h"

@interface CurrentFBillDetailsViewController ()<HTTPClientDelegate>
@property (nonatomic, strong) UILabel *repayAmount;  // 本期应收金额
@property (nonatomic, strong) UILabel *expiryDate;  // 还款到期时间
@property (nonatomic, strong) UILabel *repayWay;  // 还款方式
@property (nonatomic, strong) UILabel *repayCapital;  // 投标本金
@property (nonatomic, strong) UILabel *annualRate;  // 年利率
@property (nonatomic, strong) UILabel *interestSum;  // 本息合计应收金额
@property (nonatomic, strong) UILabel *receivedAmount;  // 已收金额
@property (nonatomic, strong) UILabel *receivedNum;  // 已收期数
@property (nonatomic, strong) UILabel *remainNum;  // 剩余期数
@property (nonatomic, strong) UILabel *remainAmount;  // 剩余应收款

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation CurrentFBillDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self requestData];
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
    
    _repayAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 220, 30)];
    _repayAmount.font = [UIFont boldSystemFontOfSize:14.0f];
    _repayAmount.textColor = [UIColor grayColor];
    _repayAmount.text = @"本期应收金额:";
    [self.view addSubview:_repayAmount];
    
    _expiryDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, 280, 30)];
    _expiryDate.font = [UIFont boldSystemFontOfSize:14.0f];
    _expiryDate.textColor = [UIColor grayColor];
    _expiryDate.text = @"还款到期时间:";
    [self.view addSubview:_expiryDate];
    
    _repayWay = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 220, 30)];
    _repayWay.font = [UIFont boldSystemFontOfSize:14.0f];
    _repayWay.textColor = [UIColor grayColor];
    _repayWay.text = @"还款方式:";
    [self.view addSubview:_repayWay];
    
    _repayCapital = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 220, 30)];
    _repayCapital.font = [UIFont boldSystemFontOfSize:14.0f];
    _repayCapital.textColor = [UIColor grayColor];
    _repayCapital.text = @"投标本金:";
    [self.view addSubview:_repayCapital];
    
    _annualRate = [[UILabel alloc] initWithFrame:CGRectMake(15, 210, 220, 30)];
    _annualRate.font = [UIFont boldSystemFontOfSize:14.0f];
    _annualRate.textColor = [UIColor grayColor];
    _annualRate.text = @"年利率:";
    [self.view addSubview:_annualRate];
    
    _interestSum = [[UILabel alloc] initWithFrame:CGRectMake(15, 245, 220, 30)];
    _interestSum.font = [UIFont boldSystemFontOfSize:14.0f];
    _interestSum.textColor = [UIColor grayColor];
    _interestSum.text = @"本息合计应收金额:";
    [self.view addSubview:_interestSum];
    
    _receivedAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 280, 220, 30)];
    _receivedAmount.font = [UIFont boldSystemFontOfSize:14.0f];
    _receivedAmount.textColor = [UIColor grayColor];
    _receivedAmount.text = @"已收金额:";
    [self.view addSubview:_receivedAmount];
    
    _receivedNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 315, 220, 30)];
    _receivedNum.font = [UIFont boldSystemFontOfSize:14.0f];
    _receivedNum.textColor = [UIColor grayColor];
    _receivedNum.text = @"已收期数:";
    [self.view addSubview:_receivedNum];
    
    _remainNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 350, 220, 30)];
    _remainNum.font = [UIFont boldSystemFontOfSize:14.0f];
    _remainNum.textColor = [UIColor grayColor];
    _remainNum.text = @"剩余期数:";
    [self.view addSubview:_remainNum];
    
    _remainAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 385, 220, 30)];
    _remainAmount.font = [UIFont boldSystemFontOfSize:14.0f];
    _remainAmount.textColor = [UIColor grayColor];
    _remainAmount.text = @"剩余应收款:";
    [self.view addSubview:_remainAmount];
    
}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"本期理财账单明细";
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

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
         [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"37" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_userId forKey:@"user_id"];
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
        
        _repayAmount.text = [NSString stringWithFormat: @"本期应收金额: %@", [obj objectForKey:@"repayAmount"]];
        
        if (![[obj objectForKey:@"repayCapital"] isEqual:[NSNull null]]){
            _repayCapital.text = [NSString stringWithFormat: @"投标本金: %@", [obj objectForKey:@"repayCapital"]];
        }
        if (![[obj objectForKey:@"repayWay"] isEqual:[NSNull null]]){
            _repayWay.text = [NSString stringWithFormat: @"还款方式: %@", [obj objectForKey:@"repayWay"]];
        }
        if (![[obj objectForKey:@"expiryDate"] isEqual:[NSNull null]]){
            _expiryDate.text = [NSString stringWithFormat: @"还款到期时间: %@", [obj objectForKey:@"expiryDate"]];
        }
        if (![[obj objectForKey:@"repayCapital"] isEqual:[NSNull null]]){
            _repayCapital.text = [NSString stringWithFormat: @"投标本金: %@", [obj objectForKey:@"repayCapital"]];
        }
        
        _annualRate.text = [NSString stringWithFormat: @"年利率: %@", [obj objectForKey:@"annualRate"]];
        _interestSum.text = [NSString stringWithFormat: @"本息合计应收金额: %@", [obj objectForKey:@"interestSum"]];
        _receivedAmount.text = [NSString stringWithFormat: @"已收金额: %@", [obj objectForKey:@"receivedAmount"]];
        _receivedNum.text = [NSString stringWithFormat: @"已收期数: %@", [obj objectForKey:@"receivedNum"]];
        _remainNum.text = [NSString stringWithFormat: @"剩余期数: %@", [obj objectForKey:@"remainNum"]];
        _remainAmount.text = [NSString stringWithFormat: @"剩余应收款: %@", [obj objectForKey:@"remainAmount"]];
        
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
