//
//  ShareEarningsViewController.m
//  SP2P_7
//
//  Created by Jerry on 15/6/18.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "ShareEarningsViewController.h"

@interface ShareEarningsViewController ()<HTTPClientDelegate>
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UILabel *profitLabel;
@property(nonatomic ,strong) UILabel *monthProfitLabel;
@property(nonatomic ,strong) UILabel *yearProfitLabel;
@property(nonatomic ,copy) NSString *shareUrl;
@end

@implementation ShareEarningsViewController



- (void)viewDidLoad {
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
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //收益分享
    [parameters setObject:@"165" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    
    
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
    
//    self.view.backgroundColor = SETCOLOR(187, 110, 109, 0.9);
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.image = [UIImage imageNamed:@"fxbg.jpg"];
    [self.view addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, MSWIDTH, 15)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.text =[NSString stringWithFormat:@"%@的累计收益",AppDelegateInstance.userInfo.userName];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];

    
    _profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+15, MSWIDTH, 70)];
    _profitLabel.textAlignment = NSTextAlignmentCenter;
    _profitLabel.font = [UIFont boldSystemFontOfSize:50.0f];
    _profitLabel.text = @"0.00";
    _profitLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_profitLabel];
    
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MSHIGHT/2-10, MSWIDTH - 40, 1)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineLabel];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH/2-40, MSHIGHT/2-50, 80, 80)];
    headerView.layer.cornerRadius = 40.0f;
    headerView.layer.masksToBounds = YES;
    [headerView sd_setImageWithURL:[NSURL URLWithString:AppDelegateInstance.userInfo.userImg] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [self.view addSubview:headerView];
    
    
    
    UILabel *monthTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLabel.frame)+90, MSWIDTH, 15)];
    monthTextLabel.textAlignment = NSTextAlignmentCenter;
    monthTextLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    monthTextLabel.text = @"超银行      倍";
    monthTextLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:monthTextLabel];
    
    _monthProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2-2, CGRectGetMaxY(lineLabel.frame)+82,30, 30)];
    _monthProfitLabel.textAlignment = NSTextAlignmentRight;
    _monthProfitLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    _monthProfitLabel.text = @"5";
    _monthProfitLabel.adjustsFontSizeToFitWidth = YES;
    _monthProfitLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_monthProfitLabel];
    
    UILabel *yearTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLabel.frame)+150, MSWIDTH, 20)];
    yearTextLabel.textAlignment = NSTextAlignmentCenter;
    yearTextLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    yearTextLabel.text = @"超某宝      倍";
    yearTextLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:yearTextLabel];
    
    _yearProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2-2, CGRectGetMaxY(lineLabel.frame)+142, 30, 30)];
    _yearProfitLabel.textAlignment = NSTextAlignmentRight;
    _yearProfitLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    _yearProfitLabel.text = @"4";
    _yearProfitLabel.adjustsFontSizeToFitWidth = YES;
    _yearProfitLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_yearProfitLabel];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(MSWIDTH/2-60, MSHIGHT - 70, 120, 40);
    shareBtn.layer.cornerRadius = 8.0f;
    shareBtn.layer.masksToBounds = YES;
    shareBtn.backgroundColor = PinkColor;
    [shareBtn setTitle:@"一起赚钱吧" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, MSHIGHT - 28, MSWIDTH, 15)];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    titleLabel2.font = [UIFont boldSystemFontOfSize:12.0f];
    titleLabel2.text = @"    邀请好友        开启财富之旅";
    titleLabel2.textColor = BluewordColor;
    [self.view addSubview:titleLabel2];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    //    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _profitLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"sum_income"]];
//        _monthProfitLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"month_income"]];
//        _yearProfitLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"year_income"]];
//        _shareUrl = [NSString stringWithFormat:@"%@",[dics objectForKey:@"share_income_url"]];
        
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    //    [self hiddenRefreshView];
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    //    [self hiddenRefreshView];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}




#pragma  分享按钮
- (void)shareClick
{
    
   
        
        //        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@/app/shareIncome?recommend=%@&income=%@&avator=%@", Baseurl,AppDelegateInstance.userInfo.userName,_profitLabel.text,AppDelegateInstance.userInfo.userImg];
    DLOG(@"分享连接地址%@",shareUrl);
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"我赚了%@元，你也来赚钱吧！",_profitLabel.text]
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"rich_icon"]]
                                                    title:@"晒收益，才够壕"
                                                      url:shareUrl
                                              description:@""
                                                mediaType:SSPublishContentMediaTypeNews];
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:[NSString stringWithFormat:@"我赚了%@元，你也来赚钱吧！",_profitLabel.text]
                                           title:@"晒收益，才够壕"
                                             url:shareUrl
                                      thumbImage:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"rich_icon"]]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:INHERIT_VALUE
                                           title:[NSString stringWithFormat:@"我赚了%@元，你也来赚钱吧！",_profitLabel.text]
                                             url:INHERIT_VALUE
                                      thumbImage:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"rich_icon"]]
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        DLOG(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        DLOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [error errorDescription]]];
                                    }
                                }];
}



/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"晒收益 才够壕";
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条分享按钮
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareClick)];
    shareItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:shareItem];
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
}

@end
