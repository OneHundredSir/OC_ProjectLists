//
//  WebCommonVC.m
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WebCommonVC.h"

@interface WebCommonVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebCommonVC
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak id weakself = self;
    self.leftBtnBlock = ^(UIButton *btn){
        [weakself dismissViewControllerAnimated:YES completion:nil];
    };
    [self _initWeb];
}

- (void)_initWeb{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在加载";
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    [HUD show:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlString]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
     
}

#pragma mark Webdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

@end
