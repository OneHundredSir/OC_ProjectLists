//
//  MyRechargeViewController.m
//  SP2P_6.1
//
//  Created by EIMS-IOS on 15-3-1.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "MyRechargeViewController.h"
#import "MyWebViewController.h"
#import "MSKeyboardScrollView.h"
#import "OpenAccountViewController.h"

#define fontsize 16.0f

@interface MyRechargeViewController ()<UITextFieldDelegate,HTTPClientDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UITextField *rechargeField;
@property (nonatomic,strong) NetWorkClient *requestClient;
@property (nonatomic,strong)UILabel *rentallabel;
@property (nonatomic,strong)UILabel *balancelabel;
@property (nonatomic,strong)UILabel *yuanlabel1;
@property (nonatomic,strong)UILabel *yuanlabel2;
@property (nonatomic,strong)MSKeyboardScrollView *scrollView;
@property (nonatomic,assign)NSInteger requestType;
@end

@implementation MyRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(initData) name:@"rechargeUpdate" object:nil];
    [self initData];
    [self initView];
}

- (void)initData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        _requestType = 1;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"145" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

- (void)initView
{
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //滚动视图
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    [self.view addSubview:_scrollView];
    
    
    //总额文本
    _rentallabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, MSWIDTH-20, 30)];
    _rentallabel.font = [UIFont systemFontOfSize:fontsize];
    _rentallabel.text = @"";
    [_scrollView addSubview:_rentallabel];
    
    //余额文本
    _balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, MSWIDTH-20, 30)];
    _balancelabel.font = [UIFont systemFontOfSize:fontsize];
    _balancelabel.text = @"";
    [_scrollView addSubview:_balancelabel];
    
    UILabel *rechargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 180, 30)];
    rechargeLabel.font = [UIFont boldSystemFontOfSize:fontsize];
    rechargeLabel.text = @"充值金额：";
    [_scrollView addSubview:rechargeLabel];

    _rechargeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 105, self.view.frame.size.width-20, 30)];
    _rechargeField.borderStyle = UITextBorderStyleNone;
    _rechargeField.backgroundColor = [UIColor whiteColor];
    _rechargeField.layer.borderWidth = 0.8f;
    _rechargeField.layer.cornerRadius =3.0f;
    _rechargeField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _rechargeField.layer.masksToBounds = YES;
    _rechargeField.placeholder = @"请输入充值金额";
    _rechargeField.font = [UIFont systemFontOfSize:15.0f];
    [_rechargeField setTag:1];
    _rechargeField.delegate = self;
    _rechargeField.keyboardType = UIKeyboardTypeDecimalPad;
    [_scrollView addSubview:_rechargeField];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureBtn.frame = CGRectMake(10, CGRectGetMaxY(_rechargeField.frame)+35, self.view.frame.size.width-20, 35);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0f;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = GreenColor;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(SureClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:sureBtn];
    
}

- (void)initNavigationBar
{
    self.title = @"充值";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
}

#pragma mark - 返回按钮
- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}


#pragma mark - 充值确定
- (void)SureClick
{
      
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    [_rechargeField resignFirstResponder];
    
    _requestType = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"170" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:_rechargeField.text forKey:@"amount"];            // 申请金额
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if (_requestType == 1) {
        
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
            NSLog(@"成功 -> %@", dics);
            NSLog(@"msg -> %@", [obj objectForKey:@"msg"]);
            
            NSString *userBalance = [NSString stringWithFormat:@"%.02f",[[dics objectForKey:@"userBalance"] floatValue]];
            NSString *withdrawalAmount = [NSString stringWithFormat:@"%.02f",[[dics objectForKey:@"withdrawalAmount"] floatValue]];
            NSString *str1 = [NSString stringWithFormat:@"账单总额：%@ 元", userBalance];
            NSString *str2 = [NSString stringWithFormat:@"其中可用余额：%@ 元", withdrawalAmount];
            
            NSRange range1 = [str1 rangeOfString:@"："];
            NSRange range2 = [str2 rangeOfString:@"："];
            
            NSMutableAttributedString *mStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
            [mStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range1.location+1, userBalance.length)];
            NSMutableAttributedString *mStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
            [mStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range2.location+1, withdrawalAmount.length)];
            _rentallabel.attributedText =  mStr1;
            _balancelabel.attributedText  =  mStr2;
            
            
        }
    }
    else if (_requestType == 2)
    {
        DLOG(@"充值返回 -> %@",dics);
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"])
        {
            DLOG(@"成功 -> %@", [obj objectForKey:@"msg"]);
            _rechargeField.text = @"";
            
            NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
            MyWebViewController *web = [[MyWebViewController alloc]init];
            web.html = htmlParam;
            web.type = @"2";
            [self.navigationController pushViewController:web animated:YES];
            
        }
        else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-31"])
        {
            OpenAccountViewController *openAccount = [[OpenAccountViewController alloc] init];
            [self.navigationController pushViewController:openAccount animated:YES];
        }
        else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
