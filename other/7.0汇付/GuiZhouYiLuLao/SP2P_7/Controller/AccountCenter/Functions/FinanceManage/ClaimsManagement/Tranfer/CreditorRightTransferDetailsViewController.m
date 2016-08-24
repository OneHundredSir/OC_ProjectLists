//
//  CreditorRightTransferDetailsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(转让债权管理) -> 已成功 -> 债权转让详情 [成功,转让中,审核中,不通过,失败](opt=49)

#import "CreditorRightTransferDetailsViewController.h"
#import "ColorTools.h"

@interface CreditorRightTransferDetailsViewController ()<HTTPClientDelegate>
{
    NSArray *titleArr;
 
}

@property (nonatomic, strong) UILabel *transferTitle;  // 转让标题
@property (nonatomic, strong) UILabel *transferBP;  // 转让底价
@property (nonatomic, strong) UILabel *transferDeadline;  // 转让截止时间
@property (nonatomic, strong) UILabel *transferReason;  // 转让原因
@property (nonatomic, strong) UILabel *receiveCorpus;  // 待收本金

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation CreditorRightTransferDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    titleArr = @[@"转让标题:",@"待收本金:",@"转让底价:",@"转让截止时间:",@"转让原因:"];
    
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
        titleLabel.frame = CGRectMake(10, 95+i*40, 150, 30);
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.view addSubview:titleLabel];
        
    }
    
    _transferTitle = [[UILabel alloc] init];
    _transferTitle.frame = CGRectMake(80, 95, 160, 30);
    _transferTitle.text = @"";
    _transferTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferTitle.textColor = [UIColor redColor];
    [self.view addSubview:_transferTitle];
    
    _receiveCorpus = [[UILabel alloc] init];
    _receiveCorpus.frame = CGRectMake(80, 135, 160, 30);
    _receiveCorpus.text = @"";
    _receiveCorpus.font = [UIFont boldSystemFontOfSize:15.0f];
    _receiveCorpus.textColor = [UIColor redColor];
    [self.view addSubview:_receiveCorpus];
    
    _transferBP = [[UILabel alloc] init];
    _transferBP.frame = CGRectMake(80, 175, 160, 30);
    _transferBP.text = @"";
    _transferBP.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferBP.textColor = [UIColor redColor];
    [self.view addSubview:_transferBP];
    
    _transferDeadline = [[UILabel alloc] init];
    _transferDeadline.frame = CGRectMake(110, 215, 160, 30);
    _transferDeadline.text = @"";
    _transferDeadline.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferDeadline.textColor = [UIColor redColor];
    [self.view addSubview:_transferDeadline];
    
    _transferReason = [[UILabel alloc] init];
    _transferReason.frame = CGRectMake(80, 255, 160, 30);
    _transferReason.text = @"";
    _transferReason.font = [UIFont boldSystemFontOfSize:15.0f];
    _transferReason.textColor = [UIColor redColor];
    [self.view addSubview:_transferReason];
}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"转让债权详情";
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
        
        [parameters setObject:@"49" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_sign forKey:@"sign"];
        
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
        
        _transferTitle.text = [obj objectForKey:@"transferTitle"];
        _transferBP.text = [NSString stringWithFormat:@" %.2f 元",[[obj objectForKey:@"transferBP"] floatValue]];
        if (![[obj objectForKey:@"transferDeadline"] isEqual:[NSNull null]]) {
            
            _transferDeadline.text = [[NSString stringWithFormat:@"%@",[obj objectForKey:@"transferDeadline"]] substringWithRange:NSMakeRange(0, 19)];
            
        }
        _transferReason.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"transferReason"]];
        _receiveCorpus.text = [NSString stringWithFormat:@" %.2f 元",[[obj objectForKey:@"receiveCorpus"]floatValue]];
        
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
