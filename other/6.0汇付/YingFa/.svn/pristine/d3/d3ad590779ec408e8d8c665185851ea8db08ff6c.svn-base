//
//  PartnersWebViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14/12/30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  合作伙伴 Web

#import "PartnersWebViewController.h"

@interface PartnersWebViewController ()

@end

@implementation PartnersWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = _titleName;
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:16.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initContentView{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = KblackgroundColor;
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [webView loadRequest:request];
    webView.scalesPageToFit = YES;
    [webView setUserInteractionEnabled:YES];
    
    [self.view addSubview:webView];
}

@end
