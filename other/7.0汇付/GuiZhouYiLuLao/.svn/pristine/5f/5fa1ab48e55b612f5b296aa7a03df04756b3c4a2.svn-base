//
//  SetSafePhoneNumViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 设置安全手机

#import "SetSafePhoneNumViewController.h"
#import "VerifySafeQuestionViewThreeController.h"
#import "ColorTools.h"

#import "SafePhone.h"

#import "SetSafePhoneNumTwoViewController.h"


@interface SetSafePhoneNumViewController ()<HTTPClientDelegate>
{
    BOOL _isLoading;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic, strong) SafePhone *phone;

@property (nonatomic, strong) UILabel *statuLabel;
@property (nonatomic, strong) UILabel *phoneLabel;


@property(nonatomic, strong) UIButton *changeBtn;

@end

@implementation SetSafePhoneNumViewController

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
    
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titlelabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 120, 30)];
    titlelabel1.text = @"安全手机:";
    titlelabel1.font = [UIFont boldSystemFontOfSize:18.0f];
    titlelabel1.textColor = [UIColor darkGrayColor];
    titlelabel1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titlelabel1];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 200, 30)];
    _phoneLabel.text = @"";
    _phoneLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _phoneLabel.textColor = [UIColor grayColor];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    //    _phoneLabel.layer.borderWidth = 1;
    //    _phoneLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self.view addSubview:_phoneLabel];
    
    _statuLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 100, 30)];
    _statuLabel.text = @"";
    _statuLabel.textColor = [UIColor grayColor];
    _statuLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _statuLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_statuLabel];
    
    //修改按钮
    _changeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _changeBtn.frame = CGRectMake(10, 280, self.view.frame.size.width-20, 45);
    [_changeBtn setTitle:@"已绑定" forState:UIControlStateNormal];
    _changeBtn.layer.cornerRadius = 3.0f;
    _changeBtn.layer.masksToBounds = YES;
    _changeBtn.backgroundColor = GreenColor;
    [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _changeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeBtn];
    
}

-(void) setValue
{
    if (![_phone.phone isEqual:[NSNull null]]) {
        _phoneLabel.text = [NSString stringWithFormat:@"%@***%@",[_phone.phone substringWithRange:NSMakeRange(0, 3)],[_phone.phone substringWithRange:NSMakeRange([_phone.phone  length]-4, 4)]];
    }else {
        _phoneLabel.text = @"未设置安全手机号码";
    }
    
    if (_phone.status) {
        _statuLabel.text = @"已激活";
        [_changeBtn setTitle:@"已绑定" forState:UIControlStateNormal];
    }else {
        _statuLabel.text = @"未设置";
        [_changeBtn setTitle:@"设 置" forState:UIControlStateNormal];
    }
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"设置安全手机";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark 修改按钮
- (void)changeBtnClick
{
    DLOG(@"修改按钮");
    
    if (_isTeleStatus) {
        // 修改安全手机
        //        VerifySafeQuestionViewThreeController *verifySafeQuestionViewThree = [[VerifySafeQuestionViewThreeController alloc] init];
        //        [self.navigationController pushViewController:verifySafeQuestionViewThree animated:YES];
    }else {
        // 未设置安全手机
        SetSafePhoneNumTwoViewController *SetSafePhoneNumTwoView = [[SetSafePhoneNumTwoViewController alloc] init];
        [self.navigationController pushViewController:SetSafePhoneNumTwoView animated:YES];
    }
}


#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"111" forKey:@"OPT"];// 客户端安全手机详情和状态接口
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    _isLoading = YES;
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    DLOG(@"===%@=======", dics);
    
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _phone = [[SafePhone alloc] init];
        _phone.phone = [dics objectForKey:@"phoneNum"];
        _phone.status = [[dics objectForKey:@"status"] intValue];
        
        [self setValue];
        
    } else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    _isLoading = NO;
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    _isLoading = NO;
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    _isLoading = NO;
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
