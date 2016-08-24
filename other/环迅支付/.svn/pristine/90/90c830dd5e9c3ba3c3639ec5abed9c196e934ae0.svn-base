//
//  ActivationViewController.m
//  SP2P_7
//
//  Created by Jerry on 14/11/12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ActivationViewController.h"
#import "RestUIAlertView.h"

@interface ActivationViewController ()<HTTPClientDelegate>
{
    
    NSArray *titleArr;
    NSInteger _typeNum;
    
}

@property (nonatomic , strong) UILabel  *nameLabel;
@property (nonatomic , strong) UILabel  *emailLabel;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end


@implementation ActivationViewController

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
    _typeNum = 0;
    titleArr = @[@"额度范围:",@"贷款利率:",@"贷款期限:",@"投标时间:",@"审核时间:",@"还款方式:"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //3.1客户端借款标产品列表接口
    [parameters setObject:@"3" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId   forKey:@"id"];

    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;

    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 72, 260,30)];
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _nameLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.view addSubview:_nameLabel];
    

    UILabel  *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20,110, 280,50)];
    textlabel2.numberOfLines = 0;
    textlabel2.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel2.font = [UIFont systemFontOfSize:13.0f];
    textlabel2.text = @"您的会员账户未激活，已将激活链接以邮件的的形式发送至您注册时所填的邮箱，请前往注册邮箱激活您的账户。";
    [self.view addSubview:textlabel2];
    

    
    _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, 260,30)];
    _emailLabel.numberOfLines = 0;
    _emailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _emailLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:_emailLabel];
    
    
    
    UIButton *AuctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AuctionBtn.frame = CGRectMake(self.view.frame.size.width*0.5-75, 230,150, 28);
    AuctionBtn.backgroundColor = GreenColor;
    [AuctionBtn setTitle:@"发送激活邮件" forState:UIControlStateNormal];
    [AuctionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    AuctionBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [AuctionBtn.layer setMasksToBounds:YES];
    [AuctionBtn.layer setCornerRadius:3.0];
    [AuctionBtn addTarget:self action:@selector(emailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:AuctionBtn];


}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"激活账户";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
 
    
    
}




#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    DLOG(@"==产品描述返回成功=======%@",obj);
    NSDictionary *dics = obj;
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if (_typeNum == 0) {
            _nameLabel.text = [NSString stringWithFormat:@"尊敬的会员%@:",AppDelegateInstance.userInfo.userName];
            
            _emailLabel.text = [NSString stringWithFormat:@"注册邮箱: %@",[dics objectForKey:@"email"]];
        }else{
        
        
            [SVProgressHUD showSuccessWithStatus:@"发送成功,请登录邮箱激活帐号"];
            NSString *emailUrl = [NSString stringWithFormat:@"%@",[dics objectForKey:@"activationLink"]];
            [self openweb:emailUrl];
        }
        
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];        
    }else {
        
        DLOG(@"返回失败===========%@",[dics objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dics objectForKey:@"msg"]]];
        
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
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

- (void)openweb:(NSString *)urlstr
{

    NSURL *requestURL = [[NSURL alloc] initWithString:urlstr];
    [[UIApplication sharedApplication] openURL:requestURL];

}

#pragma 返回按钮触发方法
- (void)backClick
{
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:NO];
    
}


-(void)emailBtnClick
{

   _typeNum = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //客户端后台发送激活邮件接口
    [parameters setObject:@"25" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId   forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];


}



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


@end


