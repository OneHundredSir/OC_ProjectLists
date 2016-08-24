//
//  AssigneeLoanStandardDetailsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  受让的借款标详情
#import "AssigneeLoanStandardDetailsViewController.h"
#import "ColorTools.h"

@interface AssigneeLoanStandardDetailsViewController ()<HTTPClientDelegate>
{
    NSArray *titleArr;
}

@property (nonatomic, strong) UILabel *borrowid;        // 借款标编号
@property (nonatomic, strong) UILabel *borrowerName;    // 借款人名称
@property (nonatomic, strong) UILabel *borrowType;      // 借款标类型
@property (nonatomic, strong) UILabel *borrowTitle;     // 借款标标题
@property (nonatomic, strong) UILabel *bidCapital;      // 投标本金
@property (nonatomic, strong) UILabel *annualRate;      // 年利率
@property (nonatomic, strong) UILabel *interestSum;     // 本息合计应收金额
@property (nonatomic, strong) UILabel *receivedAmount;  // 已收金额
@property (nonatomic, strong) UILabel *remainAmount;    // 剩余应收款
@property (nonatomic, strong) UILabel *expiryDate;      // 还款日期
@property (nonatomic, strong) UILabel *collectCapital;  // 待收本金

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AssigneeLoanStandardDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    titleArr = @[@"借款标编号:",@"借款人:",@"借款标类型:",@"借款标标题:",@"投标本金:",@"年利率:",@"本息合计应收金额:",@"已收金额:",@"剩余应收款:",@"还款日期:",@"待收本金:"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<[titleArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.view addSubview:titleLabel];
        
        if (i == 0) {
            titleLabel.frame = CGRectMake(10, 90, 90, 30);
        }else if (i == 1) {
            titleLabel.frame = CGRectMake(10, 125, 60, 30);
        }else if (i == 2) {
            titleLabel.frame = CGRectMake(10, 160, 90, 30);
        }else if (i == 3) {
            titleLabel.frame = CGRectMake(10, 195, 90, 30);
        }else if (i == 4) {
            titleLabel.frame = CGRectMake(10, 230, 75, 30);
        }else if (i == 5) {
            titleLabel.frame = CGRectMake(10, 265, 60, 30);
        }else if (i == 6) {
            titleLabel.frame = CGRectMake(10, 300, 135, 30);
        }else if (i == 7) {
            titleLabel.frame = CGRectMake(10, 335, 75, 30);
        }else if (i == 8) {
            titleLabel.frame = CGRectMake(10, 370, 90, 30);
        }else if (i == 9) {
            titleLabel.frame = CGRectMake(10, 405, 75, 30);
        }else if (i == 10) {
            titleLabel.frame = CGRectMake(10, 440, 75, 30);
        }
    }
    
    _borrowid = [[UILabel alloc] init];
    _borrowid.frame = CGRectMake(100, 90, 160, 30);
    _borrowid.text = @"";
    _borrowid.font = [UIFont boldSystemFontOfSize:15.0f];
    _borrowid.textColor = [UIColor redColor];
    [self.view addSubview:_borrowid];
    
    _borrowerName = [[UILabel alloc] init];
    _borrowerName.frame = CGRectMake(70, 125, 160, 30);
    _borrowerName.text = @"";
    _borrowerName.font = [UIFont boldSystemFontOfSize:15.0f];
    _borrowerName.textColor = [UIColor redColor];
    [self.view addSubview:_borrowerName];
    
    _borrowType = [[UILabel alloc] init];
    _borrowType.frame = CGRectMake(100, 160, 160, 30);
    _borrowType.text = @"";
    _borrowType.font = [UIFont boldSystemFontOfSize:15.0f];
    _borrowType.textColor = [UIColor redColor];
    [self.view addSubview:_borrowType];
    
    _borrowTitle = [[UILabel alloc] init];
    _borrowTitle.frame = CGRectMake(100, 195, 200, 30);
    _borrowTitle.text = @"";
    _borrowTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    _borrowTitle.textColor = [UIColor redColor];
    [self.view addSubview:_borrowTitle];
    
    // 投标本金
    _bidCapital = [[UILabel alloc] init];
    _bidCapital.frame = CGRectMake(85, 230, 160, 30);
    _bidCapital.text = @"";
    _bidCapital.font = [UIFont boldSystemFontOfSize:15.0f];
    _bidCapital.textColor = [UIColor redColor];
    [self.view addSubview:_bidCapital];
    
    // 年利率
    _annualRate = [[UILabel alloc] init];
    _annualRate.frame = CGRectMake(70, 265, 160, 30);
    _annualRate.text = @"";
    _annualRate.font = [UIFont boldSystemFontOfSize:15.0f];
    _annualRate.textColor = [UIColor redColor];
    [self.view addSubview:_annualRate];
    
    // 本息金额
    _interestSum = [[UILabel alloc] init];
    _interestSum.frame = CGRectMake(145, 300, 160, 30);
    _interestSum.text = @"";
    _interestSum.font = [UIFont boldSystemFontOfSize:15.0f];
    _interestSum.textColor = [UIColor redColor];
    [self.view addSubview:_interestSum];
    
    // 应收金额
    _receivedAmount = [[UILabel alloc] init];
    _receivedAmount.frame = CGRectMake(85, 335, 160, 30);
    _receivedAmount.text = @"";
    _receivedAmount.font = [UIFont boldSystemFontOfSize:15.0f];
    _receivedAmount.textColor = [UIColor redColor];
    [self.view addSubview:_receivedAmount];
    
    // 剩余金额
    _remainAmount = [[UILabel alloc] init];
    _remainAmount.frame = CGRectMake(100, 370, 160, 30);
    _remainAmount.text = @"";
    _remainAmount.font = [UIFont boldSystemFontOfSize:15.0f];
    _remainAmount.textColor = [UIColor redColor];
    [self.view addSubview:_remainAmount];
    
    // 还款时间
    _expiryDate = [[UILabel alloc] init];
    _expiryDate.frame = CGRectMake(85, 405, 160, 30);
    _expiryDate.text = @"";
    _expiryDate.font = [UIFont boldSystemFontOfSize:15.0f];
    _expiryDate.textColor = [UIColor redColor];
    [self.view addSubview:_expiryDate];
    
    // 待收金额
    _collectCapital = [[UILabel alloc] init];
    _collectCapital.frame = CGRectMake(85, 440, 160, 30);
    _collectCapital.text = @"";
    _collectCapital.font = [UIFont boldSystemFontOfSize:15.0f];
    _collectCapital.textColor = [UIColor redColor];
    [self.view addSubview:_collectCapital];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"受让的借款标详情";
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
        
        [parameters setObject:@"57" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_signId forKey:@"signId"];
        
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
        
        _borrowid.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"borrowid"]];
        
        if (![[obj objectForKey:@"borrowerName"] isEqual:[NSNull null]]) {
            _borrowerName.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"borrowerName"]];
        }
        if (![[obj objectForKey:@"borrowType"] isEqual:[NSNull null]]) {
            _borrowType.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"borrowType"]];
        }
        if (![[obj objectForKey:@"borrowTitle"] isEqual:[NSNull null]]) {
            _borrowTitle.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"borrowTitle"]];
        }
        if (![[obj objectForKey:@"expiryDate"] isEqual:[NSNull null]]) {
            _expiryDate.text = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"expiryDate"]] substringWithRange:NSMakeRange(0, 19)];
            NSLog(@"_expiryDate.text -> %@", _expiryDate.text);
        }
        if (![[obj objectForKey:@"collectCapital"] isEqual:[NSNull null]]) {
            _collectCapital.text = [NSString stringWithFormat:@"%.2f元", [[obj objectForKey:@"collectCapital"]floatValue]];
        }else {
            _collectCapital.text = @"0.00元";
        }
        if (![[obj objectForKey:@"receivedAmount"] isEqual:[NSNull null]]) {
            _receivedAmount.text = [NSString stringWithFormat:@"%.2f元", [[obj objectForKey:@"receivedAmount"]floatValue]];
        }else {
            _receivedAmount.text = @"0.00元";
        }

        if (![[obj objectForKey:@"interestSum"] isEqual:[NSNull null]]) {
             _interestSum.text = [NSString stringWithFormat:@"%.2f元", [[obj objectForKey:@"interestSum"]floatValue]];
        }else {
            _interestSum.text = @"0.00元";
        }
        
        if (![[obj objectForKey:@"remain_received_amount"] isEqual:[NSNull null]] && [obj objectForKey:@"remain_received_amount"] != nil) {
            _remainAmount.text = [NSString stringWithFormat:@"%.2f元", [[obj objectForKey:@"remain_received_amount"]floatValue]];
        }else {
            _remainAmount.text = @"0.00元";
        }
        
        if (![[obj objectForKey:@"bidCapital"] isEqual:[NSNull null]]) {
            _bidCapital.text = [NSString stringWithFormat:@"%.2f元", [[obj objectForKey:@"bidCapital"] floatValue]];
        }
        
        if (![[obj objectForKey:@"annualRate"] isEqual:[NSNull null]]) {
            _annualRate.text = [NSString stringWithFormat:@"%@%%", [obj objectForKey:@"annualRate"]];
        }
        
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
