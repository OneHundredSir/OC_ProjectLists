//
//  RegistrationViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  注册

#import "RegistrationViewController.h"

#import "ColorTools.h"
#import "LoginWindowTextField.h"
#import "MemberProtocolViewController.h"
#import "NSString+Shove.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "NSString+encryptDES.h"
#import "LoginViewController.h"
#import "FristGestureLockViewController.h"

#define kWidthWin self.view.frame.size.width - 40

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH

#define NUMBERS @"0123456789.\n"

@interface RegistrationViewController ()<HTTPClientDelegate, UITextFieldDelegate> {
    BOOL _isEmail;
    NSInteger _typeNum;
}

// 密码框
@property (nonatomic, strong) LoginWindowTextField *passWindow;
@property (nonatomic, strong) LoginWindowTextField *phoneWindow;
@property (nonatomic, strong) LoginWindowTextField *nameWindow;
@property (nonatomic, strong) LoginWindowTextField *refereeText; // 推荐人
@property (nonatomic, strong) UITextField *verificationPCode;       // 验证码
@property (nonatomic, strong) UIButton *verifyBtn;                  // 获取验证码按钮

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation RegistrationViewController

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
 初始化数据
 */
- (void)initData
{
    _typeNum = 0;
    
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
    self.title = @"注册";
    [self.view setBackgroundColor:KblackgroundColor];
//    if (self.ismodal) {//首页present过来
//        
//    }else{
//        
//    }
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    if(iOS9){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    CGFloat signBtn1Y = 80.f - 64;
    UIButton *signBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn1.frame = CGRectMake(20, signBtn1Y, kWidthWin, 35);
    signBtn1.backgroundColor = [UIColor whiteColor];
    [signBtn1.layer setMasksToBounds:YES];
    [signBtn1.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn1.layer setBorderWidth:1.0];   //边框宽度
    [signBtn1.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn1];
    
    // 手机输入框
    _phoneWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, signBtn1Y, kWidthWin, 35)];
    [_phoneWindow textWithleftImage:@"login_phone" rightImage:nil placeName:@"请输入手机号码"];
    _phoneWindow.tag = 1001;
    _phoneWindow.delegate = self;
    _phoneWindow.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneWindow];
    
    CGFloat signBtn2Y = signBtn1Y + 50;
    UIButton *signBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn2.frame = CGRectMake(20, signBtn2Y, kWidthWin, 35);
    signBtn2.backgroundColor = [UIColor whiteColor];
    [signBtn2.layer setMasksToBounds:YES];
    [signBtn2.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn2.layer setBorderWidth:1.0];   //边框宽度
    [signBtn2.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn2];
    
    // 用户名 输入框
    _nameWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, signBtn2Y, kWidthWin, 35)];
    _nameWindow.delegate = self;
    [_nameWindow textWithleftImage:@"login_icon" rightImage:nil placeName:@"请输入用户名"];
    CGFloat signBtn3Y = signBtn2Y + 50;
    UIButton *signBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn3.frame = CGRectMake(20, signBtn3Y, kWidthWin, 35);
    signBtn3.backgroundColor = [UIColor whiteColor];
    [signBtn3.layer setMasksToBounds:YES];
    [signBtn3.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn3.layer setBorderWidth:1.0];   //边框宽度
    [signBtn3.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn3];
    // 密码 输入框
    _passWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, signBtn3Y, kWidthWin, 35)];
    _passWindow.secureTextEntry = YES;
    _passWindow.delegate = self;
    [_passWindow textWithleftImage:@"login_lock" rightImage:nil placeName:@"请设置登录密码"];
    
    [self.view addSubview:_nameWindow];
    [self.view addSubview:_passWindow];
    
    UISwitch *_rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kWidthWin - 40, signBtn3Y+2, 30, 24)];
    [_rightSwitch setOn:YES];
    [_rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_rightSwitch];
    
     CGFloat signBtn4Y = signBtn3Y + 50;
    UIButton *signBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn4.frame = CGRectMake(70, signBtn4Y, MSWIDTH - 90, 35);
    signBtn4.backgroundColor = [UIColor whiteColor];
    [signBtn4.layer setMasksToBounds:YES];
    [signBtn4.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn4.layer setBorderWidth:1.0];   //边框宽度
    [signBtn4.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn4];
    
    // 推荐人 输入框
    _refereeText = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, signBtn4Y, kWidthWin, 35)];
    [_refereeText textWithleftImage:@"login_referee" rightImage:nil placeName:@"请填写邀请码（非必填）"];
    [self.view addSubview:_refereeText];
    
    // 验证码输入框
    CGFloat _verificationPCodeY = signBtn4Y + 50;
    _verificationPCode = [[UITextField alloc] initWithFrame:CGRectMake(20, _verificationPCodeY, MSWIDTH - 170, 35)];
    _verificationPCode.borderStyle = UITextBorderStyleNone;
    _verificationPCode.font =  [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    _verificationPCode.placeholder = @"请输入短信验证码";
    _verificationPCode.backgroundColor = [UIColor whiteColor];
    _verificationPCode.layer.borderWidth = 1;
    _verificationPCode.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _verificationPCode.keyboardType = UIKeyboardTypeNumberPad;
    [_verificationPCode.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [self.view addSubview:_verificationPCode];
    
    // 验证按钮
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(MSWIDTH - 130, _verificationPCodeY, 110, 35);
    _verifyBtn.backgroundColor = GreenColor;
    [_verifyBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_verifyBtn.layer setMasksToBounds:YES];
    [_verifyBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_verifyBtn addTarget:self action:@selector(VerifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verifyBtn];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(20, _verificationPCodeY+50, kWidthWin, 35);
    signBtn.backgroundColor = GreenColor;
    [signBtn setTitle:@"同意用户协议并创建帐号" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [signBtn addTarget:self action:@selector(CompleteClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signBtn];
    // 用户注册协议
    CGFloat getBackbuttonW = 150.f;
    UIButton *getBackbutton = [[UIButton alloc] initWithFrame:CGRectMake((MSWIDTH - getBackbuttonW)*0.5, self.view.bounds.size.height- (30+20) - 49, getBackbuttonW, 30)];
    [getBackbutton setTitle:@"用户注册协议" forState:UIControlStateNormal];
    [getBackbutton setTitleColor:BluewordColor forState:UIControlStateNormal];
    getBackbutton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
    [getBackbutton addTarget:self action:@selector(getBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:getBackbutton];
    
}

/**
 * backButton
 */
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 密码输入框右边的开关按钮
 * 切换密码是否明文
 */
- (void)switchAction:(UISwitch *)sender
{
    UISwitch *switchButton = sender;
    
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        _passWindow.secureTextEntry = YES;
    }else {
        _passWindow.secureTextEntry = NO;
    }
}

// 点击 完成 按钮
- (void)CompleteClick
{
    _typeNum = 0;
    DLOG(@"_refereeText -> %@", _refereeText.text);
    
    if (_phoneWindow.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"手机号码为空"];
        return;
    }
    if (![_phoneWindow.text isPhone]) {
        
        [SVProgressHUD showImage:nil status:@"手机号码格式不正确"];
        return;
    }
    if (_nameWindow.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"用户名为空"];
        return;
    }
    if (_passWindow.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"密码为空"];
        return;
    }
    if (_verificationPCode.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"验证码为空"];
        return;
    }
    
    [self ControlAction];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *phoneStr = _phoneWindow.text;
    NSString *name = _nameWindow.text;
    NSString *password1 = [NSString encrypt3DES:_passWindow.text key:DESkey];
    [parameters setObject:@"166" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:phoneStr forKey:@"mobile"];
    [parameters setObject:name forKey:@"userName"];
    [parameters setObject:_verificationPCode.text forKey:@"smsCode"];
    [parameters setObject:password1 forKey:@"password"];
    [parameters setObject:_refereeText.text forKey:@"recommendName"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

// 会员用户协议
- (void)getBackClick
{
    MemberProtocolViewController *protocolView = [[MemberProtocolViewController alloc] init];
    protocolView.opt = @"8";
    [self.navigationController pushViewController:protocolView animated:YES];
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    for (UITextField *textField in [self.view subviews]) {
        
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if (_typeNum == 0) {
            
            DLOG(@"返回成功  id -> %@",[obj objectForKey:@"id"]);
            
            [[AppDefaultUtil sharedInstance] setDefaultUserName:_nameWindow.text];// 保存用户账号
             [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
            
            [SVProgressHUD showSuccessWithStatus:@"恭喜您注册成功！"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * 600000000ull)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if (_typeNum == 2) {
            
            // 成功发送验证码
            DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
            
        }
        
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}




#pragma mark 验证按钮
- (void)VerifyBtnClick
{
    if (_phoneWindow.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"手机号码为空"];
        return;
    }
    
    if ([_phoneWindow.text isPhone]) {
        DLOG(@"email is right");
        __block int timeout = 60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    
                    [_verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    _verifyBtn.userInteractionEnabled = YES;
                    [_verifyBtn setAlpha:1];
                });
            }else{
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    
                    [_verifyBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    _verifyBtn.userInteractionEnabled = NO;
                    [_verifyBtn setAlpha:0.4];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        _typeNum = 2;
        
        [self getVerification:nil];
        
    }else {
        
        [SVProgressHUD showImage:nil status:@"手机号码格式不正确"];
    }
}
#pragma 请求数据

//  获取验证码
-(void) getVerification:(UIButton *)sender
{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_phoneWindow.text forKey:@"cellPhone"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

#pragma 限制只能输入数字和.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange = YES;
    if (textField.tag == 1001) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.nameWindow == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 8) { //如果输入框内容大于8则弹出警告
            textField.text = [toBeString substringToIndex:8];
            //           [SVProgressHUD showImage:nil status:@"用户名长度不超过8个"];
            canChange = NO;
        }else
            canChange = YES;
    }
    
    if (self.passWindow == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 15) { //如果输入框内容大于8则弹出警告
            textField.text = [toBeString substringToIndex:15];
            //            [SVProgressHUD showImage:nil status:@"密码不超过15位"];
            canChange = NO;
        }else
            canChange = YES;
    }
    
    
    return canChange;
}




-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
