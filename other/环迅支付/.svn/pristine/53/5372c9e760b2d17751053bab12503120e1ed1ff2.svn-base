//
//  ReachargeWebViewController.m
//  SP2P_7
//
//  Created by Jerry on 14/11/11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ReachargeWebViewController.h"

@interface ReachargeWebViewController ()

@end

@implementation ReachargeWebViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIWebView *adWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",Baseurl,@"/front/account/recharge?id=", AppDelegateInstance.userInfo.userId];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [adWebView loadRequest:request];
    adWebView.scalesPageToFit =YES;
    [adWebView setUserInteractionEnabled:YES];
    [self.view addSubview:adWebView];
    
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [adWebView addSubview : activityIndicatorView] ;
    
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"充   值";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:NO];
    
    
}

@end
