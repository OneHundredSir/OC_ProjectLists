//
//  CapitalViewController.m
//  SP2P_7
//
//  Created by Jerry on 15/6/17.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "CapitalViewController.h"
#import "TabViewController.h"
#import "RechargeViewController.h"
#import "WithdrawalViewController.h"
#import "ShareEarningsViewController.h"
#import "AddBankVCardViewController.h"
#import "MyRechargeViewController.h"
#import "MyWithdrawalViewController.h"

@interface CapitalViewController ()<HTTPClientDelegate>
{

    NSString *_hasBankStr;

}
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic, strong) UILabel *availabelLabel; // 可用
@property(nonatomic, strong) UILabel *profitLabel; // 累计收益
@property(nonatomic, strong) UILabel *amountLabel; // 账户总额
@property(nonatomic, strong) UILabel *freeZingLabel;
@property(nonatomic, strong) UILabel *repayLabel;
@property(nonatomic, strong) UILabel *receivableLabel;
@end

@implementation CapitalViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //竞拍相关信息
    [parameters setObject:@"164" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
}

- (void)viewDidLoad {
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
    _hasBankStr = @"0";

    
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    self.view.backgroundColor = KblackgroundColor;
    
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, 164)];
    backView1.backgroundColor = KColor;
    backView1.alpha = 0.8;
    [self.view addSubview:backView1];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15,30, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:backBtn];
    
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(MSWIDTH - 45,30, 30, 30);
//    [shareBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//    [backView1 addSubview:shareBtn];
//    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2 -50, 30, 100, 30)];
//    titleLabel.backgroundColor = GreenColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
    titleLabel.text = @"资金";
    [backView1 addSubview:titleLabel];
    
    _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, MSWIDTH, 40)];
    _profitLabel.textAlignment = NSTextAlignmentCenter;
    _profitLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    _profitLabel.text = @"0.00";
    _profitLabel.textColor = [UIColor whiteColor];
    _profitLabel.userInteractionEnabled = YES;
    backView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareClick)];
    tapClick.numberOfTapsRequired = 1;
    tapClick.numberOfTouchesRequired = 1;
    [_profitLabel addGestureRecognizer:tapClick];
    [backView1 addSubview:_profitLabel];
    
    UILabel *profitTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_profitLabel.frame), MSWIDTH, 15)];
    profitTextLabel.textAlignment = NSTextAlignmentCenter;
    profitTextLabel.font = [UIFont systemFontOfSize:13.0f];
    profitTextLabel.text = @"累计收益(元)";
    profitTextLabel.textColor = [UIColor whiteColor];
    [backView1 addSubview:profitTextLabel];
    
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 164, MSWIDTH, 225)];
    backView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView2];
    
    _availabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, MSWIDTH/2, 20)];
    _availabelLabel.textAlignment = NSTextAlignmentCenter;
    _availabelLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _availabelLabel.text = @"0.00";
    _availabelLabel.textColor = [UIColor blackColor];
    [backView2 addSubview:_availabelLabel];
    
    UILabel *availabelTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_availabelLabel.frame), MSWIDTH/2, 15)];
    availabelTextLabel.textAlignment = NSTextAlignmentCenter;
    availabelTextLabel.font = [UIFont systemFontOfSize:12.0f];
    availabelTextLabel.text = @"可用余额(元)";
    availabelTextLabel.textColor = [UIColor lightGrayColor];
    [backView2 addSubview:availabelTextLabel];
    
    
    
    _freeZingLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2, 20, MSWIDTH/2, 20)];
    _freeZingLabel.textAlignment = NSTextAlignmentCenter;
    _freeZingLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _freeZingLabel.text = @"0.00";
    _freeZingLabel.textColor = [UIColor blackColor];
    [backView2 addSubview:_freeZingLabel];
    
    UILabel *freezingTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2, CGRectGetMaxY(_freeZingLabel.frame), MSWIDTH/2, 15)];
    freezingTextLabel.textAlignment = NSTextAlignmentCenter;
    freezingTextLabel.font = [UIFont systemFontOfSize:12.0f];
    freezingTextLabel.text = @"冻结金额(元)";
    freezingTextLabel.textColor = [UIColor lightGrayColor];
    [backView2 addSubview:freezingTextLabel];
    
    _repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, MSWIDTH/2, 20)];
    _repayLabel.textAlignment = NSTextAlignmentCenter;
    _repayLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _repayLabel.text = @"0.00";
    _repayLabel.textColor = [UIColor blackColor];
    [backView2 addSubview:_repayLabel];
    
    UILabel *repayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_repayLabel.frame), MSWIDTH/2, 15)];
    repayTextLabel.textAlignment = NSTextAlignmentCenter;
    repayTextLabel.font = [UIFont systemFontOfSize:12.0f];
    repayTextLabel.text = @"应还金额(元)";
    repayTextLabel.textColor = [UIColor lightGrayColor];
    [backView2 addSubview:repayTextLabel];
    
    _receivableLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2, 95, MSWIDTH/2, 20)];
    _receivableLabel.textAlignment = NSTextAlignmentCenter;
    _receivableLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _receivableLabel.text = @"0.00";
    _receivableLabel.textColor = [UIColor blackColor];
    [backView2 addSubview:_receivableLabel];
    
    UILabel *receivableTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2, CGRectGetMaxY(_repayLabel.frame), MSWIDTH/2, 15)];
    receivableTextLabel.textAlignment = NSTextAlignmentCenter;
    receivableTextLabel.font = [UIFont systemFontOfSize:12.0f];
    receivableTextLabel.text = @"应收金额(元)";
    receivableTextLabel.textColor = [UIColor lightGrayColor];
    [backView2 addSubview:receivableTextLabel];
    
    
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, MSWIDTH/2, 20)];
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _amountLabel.text = @"0.00";
    _amountLabel.textColor = [UIColor blackColor];
    [backView2 addSubview:_amountLabel];
    
    UILabel *amountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_amountLabel.frame), MSWIDTH/2, 15)];
    amountTextLabel.textAlignment = NSTextAlignmentCenter;
    amountTextLabel.font = [UIFont systemFontOfSize:12.0f];
    amountTextLabel.text = @"账户总额(元)";
    amountTextLabel.textColor = [UIColor lightGrayColor];
    [backView2 addSubview:amountTextLabel];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MSHIGHT - 44, MSWIDTH, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, MSWIDTH/2, 44);
    btn1.backgroundColor = KColor;
    [btn1 setTitle:@"充值" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(MSWIDTH/2, 0, MSWIDTH/2, 44);
    btn2.backgroundColor = KColor;
    [btn2 setTitle:@"提现" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn2];
    
  
    
}

#pragma mark --
#pragma mark 充值点击方法

-(void)rechargeClick
{
    if (IS_TRUSTEESHIP) {
        MyRechargeViewController *rechargeView = [[MyRechargeViewController alloc] init];
        [self.navigationController pushViewController:rechargeView animated:YES];
    }else{
        RechargeViewController *rechargeView = [[RechargeViewController alloc] init];
        [self.navigationController pushViewController:rechargeView animated:YES];
    }
  
}

#pragma mark --
#pragma mark 提现点击方法
-(void)withdrawClick
{
    if (IS_TRUSTEESHIP) {
        MyWithdrawalViewController *withdraw = [[MyWithdrawalViewController alloc] init];
        [self.navigationController pushViewController:withdraw animated:YES];
    }else{
        if ([_hasBankStr isEqualToString:@"0"] ) {
            
            [SVProgressHUD showErrorWithStatus:@"请先绑定银行卡"];
            
            AddBankVCardViewController *addBankVCardView = [[AddBankVCardViewController alloc] init];
            [addBankVCardView setBankCard:nil];
            [addBankVCardView setEditType:BankCardEditAdd];
            [self.navigationController pushViewController:addBankVCardView animated:YES];
            
        }else{
            
            WithdrawalViewController *withdrawView = [[WithdrawalViewController alloc] init];
            [self.navigationController pushViewController:withdrawView animated:YES];
            
        }
    }

}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"资金管理";
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
//    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _availabelLabel.text = [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"balance"] doubleValue]];
        
        _amountLabel.text = [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"amount"] doubleValue]];
        _repayLabel.text = [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"back_amount"] doubleValue]];
        _receivableLabel.text = [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"repay_amount"] doubleValue]];
        _freeZingLabel.text = [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"frozen_amount"] doubleValue]];
        _profitLabel.text =
        _hasBankStr = [NSString stringWithFormat:@"%@",[dics objectForKey:@"hasBanks"]];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@"###,##0.00;"];
        NSString *numberString2 = [formatter stringFromNumber:[NSNumber numberWithDouble:[[dics objectForKey:@"sum_income"] doubleValue]]];
        _profitLabel.text = numberString2;


    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
//    [self hiddenRefreshView];
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
//    [self hiddenRefreshView];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}



#pragma 返回按钮触发方法
- (void)backClick
{
    
//    TabViewController *tabViewController = [[TabViewController alloc] init];
     TabViewController *tabViewController = [TabViewController shareTableView];
    [self.frostedViewController presentMenuViewController];
    self.frostedViewController.contentViewController = tabViewController;
    
    
}

#pragma mark 分享页面
- (void)shareClick
{
    
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        
        ShareEarningsViewController *shareEarningsView = [[ShareEarningsViewController alloc] init];
        [self.navigationController pushViewController:shareEarningsView animated:YES];
    }
}
@end
