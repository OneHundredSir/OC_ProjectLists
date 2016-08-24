//
//  RechargeViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心 --》账户管理---》充值
#import "RechargeViewController.h"
#import "ReachargeWebViewController.h"

#import "ColorTools.h"

@interface RechargeViewController ()<UITextFieldDelegate,UIWebViewDelegate,NSURLConnectionDelegate>
{

    NSArray *titleArr;

}
@property (nonatomic,strong)UITextField *Rechargefield;
@property (nonatomic,strong)UILabel *rentallabel;
@property (nonatomic,strong)UILabel *balancelabel;
@property (nonatomic,strong)NSURLRequest *originRequest;
@property (nonatomic,copy)NSURL *currenURL;
@property (nonatomic,assign)BOOL authed;
@property (nonatomic,strong)UIWebView *rechargewebView;
@end

@implementation RechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    _authed = NO;
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];        
    }else{
    _rechargewebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Baseurl,@"/front/account/rechargeApp"];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_rechargewebView loadRequest:request];
    _rechargewebView.delegate = self;
    _rechargewebView.scalesPageToFit =YES;
      
    [_rechargewebView setUserInteractionEnabled:YES];
    [self.view addSubview:_rechargewebView];
    
    
//    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
//                                                      initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
//    [activityIndicatorView setCenter: self.view.center] ;
//    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
//    [_rechargewebView addSubview : activityIndicatorView];
        
    }
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"充   值";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setOpaque:YES];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}

#pragma mark - UIWebViewDelegate
//在webview开始加载网页的时候首先判断判断该站点是不是https站点，如果是的话，先然他暂停加载，先用NSURLConnection 来访问改站点，然后再身份验证的时候，将该站点置为可信任站点。然后在用webview重新加载请求。
- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    DLOG(@"scheme = %@",scheme);
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.authed) {
            _originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [_rechargewebView stopLoading];
            return NO;
        }
    }
    NSURL *theUrl = [request URL];
    DLOG(@"the url is %@",theUrl);
    self.currenURL = theUrl;
  
    return YES;
}




//在NSURLConnection 代理方法中处理信任问题。
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    if ([challenge previousFailureCount]== 0) {
        _authed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}
//在NSURLConnection 代理方法中收到响应之后，再次使用web view加载https站点。

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    
    DLOG(@"%@",request);
    return request;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    _authed = YES;
    //webview 重新加载请求。
    [_rechargewebView loadRequest:_originRequest];
    _rechargewebView.scalesPageToFit = YES;
    [connection cancel];
}


#pragma 返回按钮触发方法
- (void)backClick
{
//     [[NSNotificationCenter defaultCenter]  postNotificationName:@"update2" object:nil];
//     [self dismissViewControllerAnimated:YES completion:^(){}];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
