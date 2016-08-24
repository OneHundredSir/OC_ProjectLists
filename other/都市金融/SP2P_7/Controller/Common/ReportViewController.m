//
//  ReportViewController.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  举报=======================================

#import "ReportViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>
@interface ReportViewController ()<UITextViewDelegate,HTTPClientDelegate>


@property (nonatomic ,strong) UILabel *titleLabel1;
@property (nonatomic ,strong) UILabel *titleLabel2;
@property (nonatomic ,strong) UITextView *reasonView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation ReportViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
//    _titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width, 30)];
//    _titleLabel1.font = [UIFont systemFontOfSize:13.0f];
//    _titleLabel1.text = [NSString stringWithFormat:@"举报人:%@",self.reportName];
//    _titleLabel1.textColor = [UIColor darkGrayColor];
//    _titleLabel1.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:_titleLabel1];
//    
//    _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width, 30)];
//    _titleLabel2.font = [UIFont systemFontOfSize:13.0f];
//    _titleLabel2.text = [NSString stringWithFormat:@"被举报人:%@***", [self.borrowName substringWithRange:NSMakeRange(0, 1)]];
////    _titleLabel2.text = [NSString stringWithFormat:@"被举报人:%@",self.borrowName];
//    _titleLabel2.textAlignment = NSTextAlignmentLeft;
//    _titleLabel2.textColor = [UIColor darkGrayColor];
//    [self.view addSubview:_titleLabel2];
    
    CGFloat titleLabelY = 80.f - 64;
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabelY, self.view.frame.size.width-20, 30)];
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"具体描述";
    titleLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:titleLabel];
    
    _reasonView  = [[UITextView alloc]  initWithFrame:CGRectMake(10, 110-64, self.view.frame.size.width-20, 100)];
    _reasonView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _reasonView.layer.cornerRadius = 5.0f;
    _reasonView.layer.borderWidth = 0.5f;
    _reasonView .delegate = self;
    [self.view addSubview:_reasonView];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(self.view.frame.size.width*0.5-70, 260-64,140, 40);
    reportBtn.backgroundColor = GreenColor;
    [reportBtn setTitle:@"举   报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    reportBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [reportBtn.layer setMasksToBounds:YES];
    [reportBtn.layer setCornerRadius:3.0];
    [reportBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:reportBtn];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"举报";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    

}

- (void)reportBtnClick
{


    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //举报用户 （opt=69）
    [parameters setObject:@"69" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_bidIdSign] forKey:@"bidIdSign"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_bidUserIdSign] forKey:@"bidUserIdSign"];
    [parameters setObject:_reasonView.text forKey:@"reason"];
    [parameters setObject:@"" forKey:@"sign"];

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
    
    DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
          [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
        
            [self.navigationController popViewControllerAnimated:YES];
        });
       
        
   
    }
    else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else{
        
        DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
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

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
    }else {
        if ([textView.text length] < 70) {//判断字符个数
            return YES;
        }
    }
    return NO;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


@end
