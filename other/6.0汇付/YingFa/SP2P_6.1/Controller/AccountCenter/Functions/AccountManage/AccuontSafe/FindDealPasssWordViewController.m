//
//  FindDealPasssWordViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FindDealPasssWordViewController.h"
#import "FindDealPasswordTwoViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

#import "SafePhone.h"

@interface FindDealPasssWordViewController ()<UITextFieldDelegate, HTTPClientDelegate>
{
    NSInteger isOPT; // 0代表获取安全手机状态
    NSInteger isTele;
}

@property (nonatomic, strong) UITextField *authCodeField;
@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) SafePhone *safePhone;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation FindDealPasssWordViewController

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
    
    [self requestSafePhoneData];
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

    self.view.backgroundColor =KblackgroundColor;
    
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 85, 30, 30)];
    [imgView setImage:[UIImage imageNamed:@"find_dealpassword_success"]];
    //imgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imgView];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, 255, 60)];
    _phoneLabel.text = @"已验证安全手机: ";
    _phoneLabel.lineBreakMode =   NSLineBreakByCharWrapping;
    _phoneLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _phoneLabel.textColor = [UIColor darkGrayColor];
    _phoneLabel.numberOfLines = 0;
    [self.view addSubview:_phoneLabel];
    
    //输入框
    _authCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 140, MSWIDTH-160,40)];
    _authCodeField.borderStyle = UITextBorderStyleNone;
    _authCodeField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _authCodeField.layer.borderWidth = 0.5f;
    _authCodeField.backgroundColor = [UIColor whiteColor];
    _authCodeField.font = [UIFont systemFontOfSize:15.0f];
    _authCodeField.delegate = self;
    _authCodeField.placeholder = @"请输入验证码";
    _authCodeField.keyboardType =UIKeyboardTypeNumberPad;
    [self.view addSubview:_authCodeField];
    
    // 验证按钮
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(MSWIDTH-135, 140, 120, 40);;
    _verifyBtn.backgroundColor = GreenColor;
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    _verifyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_verifyBtn.layer setMasksToBounds:YES];
    [_verifyBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_verifyBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verifyBtn];
    
    //下一步按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = CGRectMake(10, 220, self.view.frame.size.width-20, 40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 3.0f;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.backgroundColor = GreenColor;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"找回交易密码";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
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

#pragma mark 下一步ann
- (void)nextBtnClick
{
    DLOG(@"下一步按钮");
    
    if ([_authCodeField.text isEqualToString:@""]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"输入的信息有误，请重新输入!"];
        });
        
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        isOPT = 5;
        [parameters setObject:@"5" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_safePhone.phone forKey:@"cellPhone"];
        [parameters setObject:_authCodeField.text forKey:@"randomCode"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}
    
#pragma mark 重新获取验证码按钮
- (void)verifyBtnClick
{
    DLOG(@"重新获取按钮");
    
    __block int timeout = 30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _verifyBtn.userInteractionEnabled = YES;
                [_verifyBtn setAlpha:1];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                DLOG(@"____%@",strTime);
                
                [_verifyBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                _verifyBtn.userInteractionEnabled = NO;
                [_verifyBtn setAlpha:0.4];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    isOPT = 4;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_safePhone.phone forKey:@"cellPhone"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma 请求数据
-(void) requestSafePhoneData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    isTele = 111;
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
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    DLOG(@"===%@=======", dics);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);

        DLOG(@"isOPT  -> %ld", (long)isOPT);
        
        if (isOPT == 5) {
            
            FindDealPasswordTwoViewController *findDeal = [[FindDealPasswordTwoViewController alloc] init];
            [self.navigationController pushViewController:findDeal animated:YES];
            
        }else if (isOPT == 4) {
            DLOG(@" 获取验证码成功！");
        }
        
        else if(isTele == 111) {
            
            _safePhone = [[SafePhone alloc] init];
            _safePhone.phone = [dics objectForKey:@"phoneNum"];
            _safePhone.status = [[dics objectForKey:@"status"] intValue];
            
            _phoneLabel.text = [NSString stringWithFormat:@"已验证安全手机: %@", _safePhone.phone];
            
        }

        
    } else {
        // 服务器返回数据异常
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
