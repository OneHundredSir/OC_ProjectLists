//
//  JoinBlackListViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-31.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  加入黑名单

#import "JoinBlackListViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

@interface JoinBlackListViewController ()<UITextViewDelegate, HTTPClientDelegate>

@property (nonatomic, strong)UITextView *reasonTextView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation JoinBlackListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    UILabel *nameTextlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 80, 30)];
    nameTextlabel.text = @"用户名";
    nameTextlabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:nameTextlabel];
    
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, 80, 30)];
    namelabel.text = _bidName;
    namelabel.font = [UIFont boldSystemFontOfSize:14.0f];
    namelabel.textColor = [UIColor grayColor];
    [self.view addSubview:namelabel];
    
    
    UILabel *reasonlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 80, 30)];
    reasonlabel.text = @"原因";
    reasonlabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:reasonlabel];
    
    _reasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 145, 300, 120)];
    _reasonTextView.backgroundColor = [UIColor whiteColor];
    _reasonTextView.delegate = self;
    _reasonTextView.layer.borderWidth = 0.5f;
    _reasonTextView.layer.cornerRadius = 5.0f;
    _reasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_reasonTextView];
    
    
    UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    SureBtn.frame = CGRectMake(self.view.frame.size.width*0.5-50, 400,100, 25);
   SureBtn.backgroundColor = GreenColor;
    [SureBtn setTitle:@"确认" forState:UIControlStateNormal];
   [SureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    SureBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [SureBtn.layer setMasksToBounds:YES];
   [SureBtn.layer setCornerRadius:3.0];
    [SureBtn addTarget:self action:@selector(SureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SureBtn];
    
    
    
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"加入黑名单";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}
#pragma mark 确认按钮

- (void)SureBtnClick
{
    DLOG(@"确认按钮");
    
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"70" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _bidId] forKey:@"bid_id"];
        [parameters setObject:_reasonTextView.text forKey:@"reason"];
        
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }

}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
//        _reasonTextView.text = @"";
//        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
