//
//  SetSafeEmailTwoViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 安全邮箱设置

#import "SetSafeEmailTwoViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

@interface SetSafeEmailTwoViewController ()<UITextFieldDelegate, HTTPClientDelegate>
{
    BOOL _isLoading;
}

@property (nonatomic,strong) UITextField *safeEmailtextfield;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SetSafeEmailTwoViewController

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
    
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    
    UILabel *titlelabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 120, 30)];
    titlelabel1.text = @"安全邮箱";
    titlelabel1.font = [UIFont boldSystemFontOfSize:16.0f];
    titlelabel1.textAlignment = NSTextAlignmentLeft;
    titlelabel1.textColor = [UIColor darkGrayColor];
    [self.view addSubview:titlelabel1];
    
    
    // 输入框
    _safeEmailtextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-20, 45)];
    _safeEmailtextfield.borderStyle = UITextBorderStyleNone;
    _safeEmailtextfield.layer.borderWidth = 0.5f;
    _safeEmailtextfield.layer.borderColor = [[UIColor grayColor] CGColor];
    _safeEmailtextfield.layer.cornerRadius = 3.0f;
    _safeEmailtextfield.delegate = self;
    _safeEmailtextfield.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_safeEmailtextfield];
    
    
    //保存并激活按钮
    UIButton *ChangeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ChangeBtn.frame = CGRectMake(10, 260, self.view.frame.size.width-20, 45);
    [ChangeBtn setTitle:@"保存并激活" forState:UIControlStateNormal];
    ChangeBtn.layer.cornerRadius = 3.0f;
    ChangeBtn.layer.masksToBounds = YES;
    ChangeBtn.backgroundColor = BrownColor;
    [ChangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ChangeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [ChangeBtn addTarget:self action:@selector(ChangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ChangeBtn];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"安全邮箱设置";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark UItextfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    
    for (UITextField *textField in [self.view subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark 保存并激活按钮
- (void)ChangeBtnClick
{
    DLOG(@"保存并激活按钮");
    
    if([_safeEmailtextfield.text isEqualToString:@""]){
        DLOG(@"请填写邮箱");
        return;
    }
    [self requestData];
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"110" forKey:@"OPT"];// 客户端修改邮箱接口
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_safeEmailtextfield.text forKey:@"emailaddress"];
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
        
        // 通知全局广播 LeftMenuController 修改UI操作
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"updatelist" object:@"2"];
        
         [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
         [self.navigationController popViewControllerAnimated:YES];
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
