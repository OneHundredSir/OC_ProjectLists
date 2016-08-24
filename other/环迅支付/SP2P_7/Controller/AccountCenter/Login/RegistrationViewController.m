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
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
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
    
    UIButton *signBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn1.frame = CGRectMake(20, 80, kWidthWin, 35);
    signBtn1.backgroundColor = [UIColor whiteColor];
    [signBtn1.layer setMasksToBounds:YES];
    [signBtn1.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn1.layer setBorderWidth:1.0];   //边框宽度
    [signBtn1.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn1];
    
    // 手机输入框
    _phoneWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 80, kWidthWin, 35)];
    [_phoneWindow textWithleftImage:@"login_phone" rightImage:nil placeName:@"请输入手机号码"];
    _phoneWindow.tag = 1001;
    _phoneWindow.delegate = self;
    [self.view addSubview:_phoneWindow];
    _phoneWindow.keyboardType = UIKeyboardTypeNamePhonePad;
//    _mailWindow.delegate = self;
    
    
    UIButton *signBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn2.frame = CGRectMake(20, 130, kWidthWin, 35);
    signBtn2.backgroundColor = [UIColor whiteColor];
    [signBtn2.layer setMasksToBounds:YES];
    [signBtn2.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn2.layer setBorderWidth:1.0];   //边框宽度
    [signBtn2.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn2];
    
    // 用户名 输入框
    _nameWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 130, kWidthWin, 35)];
    _nameWindow.delegate = self;
    [_nameWindow textWithleftImage:@"login_icon" rightImage:nil placeName:@"请输入用户名"];
    
    UIButton *signBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn3.frame = CGRectMake(20, 180, kWidthWin, 35);
    signBtn3.backgroundColor = [UIColor whiteColor];
    [signBtn3.layer setMasksToBounds:YES];
    [signBtn3.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn3.layer setBorderWidth:1.0];   //边框宽度
    [signBtn3.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn3];
    // 密码 输入框
    _passWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 180, kWidthWin, 35)];
    _passWindow.secureTextEntry = YES;
    _passWindow.delegate = self;
    [_passWindow textWithleftImage:@"login_lock" rightImage:nil placeName:@"请设置登录密码"];
    
    [self.view addSubview:_nameWindow];
    [self.view addSubview:_passWindow];
    
    UISwitch *_rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kWidthWin - 40, 182, 30, 24)];
    [_rightSwitch setOn:YES];
    [_rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_rightSwitch];
    
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 182, 50, 30)];
//    titleLabel.text = @"推荐人";
//    titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
//    [self.view addSubview:titleLabel];
    
    UIButton *signBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn4.frame = CGRectMake(70, 230, MSWIDTH - 90, 35);
    signBtn4.backgroundColor = [UIColor whiteColor];
    [signBtn4.layer setMasksToBounds:YES];
    [signBtn4.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn4.layer setBorderWidth:1.0];   //边框宽度
    [signBtn4.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn4];
    
    // 推荐人 输入框
    _refereeText = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 230, kWidthWin, 35)];
    [_refereeText textWithleftImage:@"login_referee" rightImage:nil placeName:@"请填写推荐人用户名或邀请码（非必填）"];
    [self.view addSubview:_refereeText];
    
    // 验证码输入框
    _verificationPCode = [[UITextField alloc] initWithFrame:CGRectMake(20, 280, MSWIDTH - 170, 35)];
    _verificationPCode.borderStyle = UITextBorderStyleNone;
   _verificationPCode.font =  [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    _verificationPCode.placeholder = @"请输入短信验证码";
    _verificationPCode.backgroundColor = [UIColor whiteColor];
    _verificationPCode.layer.borderWidth = 1;
    _verificationPCode.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _verificationPCode.keyboardType = UIKeyboardTypeDecimalPad;
    [_verificationPCode.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [self.view addSubview:_verificationPCode];
    
    // 验证按钮
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(MSWIDTH - 130, 280, 110, 35);
    _verifyBtn.backgroundColor = GreenColor;
    [_verifyBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_verifyBtn.layer setMasksToBounds:YES];
    [_verifyBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_verifyBtn addTarget:self action:@selector(VerifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verifyBtn];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(20, 330, kWidthWin, 35);
    signBtn.backgroundColor = GreenColor;
    [signBtn setTitle:@"同意用户协议并创建帐号" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [signBtn addTarget:self action:@selector(CompleteClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signBtn];
    
    UIButton *getBackbutton = [[UIButton alloc] initWithFrame:CGRectMake((MSWIDTH - 150)*0.5, MSHIGHT-50, 150, 30)];
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
        
        DLOG(@"返回成功  id -> %@",[obj objectForKey:@"id"]);
                
        [[AppDefaultUtil sharedInstance] setDefaultUserName:_nameWindow.text];// 保存用户账号
//        [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_passWindow.text];// 保存用户密码
        
//        LoginViewController *loginView = [[LoginViewController alloc] init];
//        loginView.selfView = self.navigationController;
//        [self.navigationController pushViewController:loginView animated:YES];
        if (_typeNum == 0) {
            
             [self registrationLogin:_nameWindow.text pwd:_passWindow.text];
            
        }else if (_typeNum == 2) {
            
            // 成功发送验证码
            DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
            
        }else{
        
            
            DLOG(@"返回成功  username -> %@",[obj objectForKey:@"username"]);
            DLOG(@"返回成功  id -> %@",[obj objectForKey:@"id"]);
            DLOG(@"返回成功  vipStatus -> %@",[obj objectForKey:@"vipStatus"]);
            DLOG(@"返回成功  imgUrl is  -> %@",[NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]]);
            
            UserInfo *usermodel = [[UserInfo alloc] init];
            usermodel.userName = [obj objectForKey:@"username"];
            if ([[obj objectForKey:@"headImg"] hasPrefix:@"http"]) {
                
                usermodel.userImg = [NSString stringWithFormat:@"%@",[obj objectForKey:@"headImg"]];
            }
            else
            {
                usermodel.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
                
            }
            
            if([[obj objectForKey:@"creditRating"] hasPrefix:@"http"])
            {
                usermodel.userCreditRating = [obj objectForKey:@"creditRating"];
                
            }else{
                usermodel.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
            }
            usermodel.userLimit = [obj objectForKey:@"creditLimit"];
            usermodel.isVipStatus = [obj objectForKey:@"vipStatus"];
            usermodel.userId = [obj objectForKey:@"id"];
            usermodel.isLogin = @"1";
            usermodel.deviceType = @"2";
            usermodel.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] floatValue]];
            usermodel.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] floatValue]];
            usermodel.isEmailStatus = [[obj objectForKey:@"hasEmail"] boolValue];
            usermodel.isMobileStatus = [[obj objectForKey:@"hasMobile"] boolValue];
            AppDelegateInstance.userInfo = usermodel;
            
            // 通知全局广播 LeftMenuController 修改UI操作
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:[obj objectForKey:@"username"]];
            
            [self loginSuccess];// 登录成功

        }
       
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
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

#pragma mark 调用文本代理
- (void)textFieldDidEndEditing:(UITextField *)textField {
    DLOG(@"textField -> %@", textField.text);

}

-(void) loginSuccess
{
    
    // 登录成功，记住密码. 保存账号密码到UserDefault

    [[AppDefaultUtil sharedInstance] setDefaultUserName:AppDelegateInstance.userInfo.userName];// 保存用户昵称
    [[AppDefaultUtil sharedInstance] setDefaultAccount:_nameWindow.text];// 保存用户账号
//    [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_passWindow.text];// 保存用户密码（未加密）
    NSString *pwdStr = [NSString encrypt3DES:_passWindow.text key:DESkey];//用户密码3Des加密
    [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户密码（des加密）
    [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:AppDelegateInstance.userInfo.userImg];// 保存用户头像
    [[AppDefaultUtil sharedInstance] setdeviceType:AppDelegateInstance.userInfo.deviceType];// 保存设备型号
    
    DLOG(@"name is =======> %@",_nameWindow.text);
    
//    FristGestureLockViewController *controller = [[FristGestureLockViewController alloc] init];
    
//    [self.navigationController pushViewController:controller animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)registrationLogin:(NSString *)name pwd:(NSString *)pwd {
    
    _nameWindow.text = name;
    _passWindow.text = pwd;
    _typeNum = 1;
    
    // 账号：1  密码：1
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *password = [NSString encrypt3DES:pwd key:DESkey];
    [parameters setObject:@"1" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:password forKey:@"pwd"];
    if(AppDelegateInstance.userId !=nil && AppDelegateInstance.channelId != nil)
    {
        [parameters setObject:AppDelegateInstance.userId forKey:@"userId"];
        [parameters setObject:AppDelegateInstance.channelId forKey:@"channelId"];
        
    }else {
        
        
        [parameters setObject:@"" forKey:@"userId"];
        [parameters setObject:@"" forKey:@"channelId"];
        
    }
    [parameters setObject:@"2" forKey:@"deviceType"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
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
        __block int timeout = 30; //倒计时时间
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
