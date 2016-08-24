//
//  SetNewDealPassWordViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  设置交易密码 / 修改交易密码

#import "SetNewDealPassWordViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

#import "QCheckBox.h"
#import "SafePhone.h"

@interface SetNewDealPassWordViewController ()<UITextFieldDelegate, UIAlertViewDelegate, HTTPClientDelegate, QCheckBoxDelegate> {
    
    NSInteger isOPT;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *oldPass;                 // 旧密码框
@property (nonatomic, strong) UITextField *nPassWord;               // 新密码框
@property (nonatomic, strong) UITextField *verificationPassword;    // 验证新密码
@property (nonatomic, strong) UILabel *phoneLabel;              // 安全手机
@property (nonatomic, strong) UITextField *verificationPCode;       // 验证码
@property (nonatomic, strong) UIButton *verifyBtn;                  // 获取验证码按钮
@property (nonatomic, strong) UIButton *submitBtn;                  // 确定按钮
@property (nonatomic,strong) QCheckBox *check;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) SafePhone *safePhone;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SetNewDealPassWordViewController

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
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64)];
     _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    // 密码输入框
    _oldPass = [[UITextField alloc] initWithFrame:CGRectZero];
    _oldPass.secureTextEntry = YES;
    _oldPass.font = [UIFont boldSystemFontOfSize:15.0f];
    _oldPass.backgroundColor = [UIColor whiteColor];
//    _oldPass.placeholder = @"请输入当前密码";
//    [_scrollView addSubview:_oldPass];
    
    // 密码输入框
    _nPassWord = [[UITextField alloc] initWithFrame:CGRectZero];
    _nPassWord.secureTextEntry = YES;
    _nPassWord.backgroundColor = [UIColor whiteColor];
    _nPassWord.font = [UIFont boldSystemFontOfSize:15.0f];
//    _nPassWord.placeholder = @"请输入新密码";
//    [_scrollView addSubview:_nPassWord];
    
    // 验证新密码输入框
    _verificationPassword = [[UITextField alloc] initWithFrame:CGRectZero];
    _verificationPassword.secureTextEntry = YES;
    _verificationPassword.backgroundColor = [UIColor whiteColor];
    _verificationPassword.font = [UIFont boldSystemFontOfSize:15.0f];
    _verificationPassword.delegate = self;
    _verificationPassword.tag = 111;
//    _verificationPassword.placeholder = @"请验证新密码";
//    [_scrollView addSubview:_verificationPassword];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.text = @"请输入6—16位字母和数字组成的密码";
    _promptLabel.font = [UIFont systemFontOfSize:13.0f];
    _promptLabel.textColor = [UIColor lightGrayColor];
    _promptLabel.lineBreakMode =   NSLineBreakByCharWrapping;
    _promptLabel.numberOfLines = 0;
    [_scrollView addSubview:_promptLabel];
    
    _check = [[QCheckBox alloc] initWithDelegate:self];
    [_check setImage:[UIImage imageNamed:@"checkbox3_unchecked.png"] forState:UIControlStateNormal];
    [_check setImage:[UIImage imageNamed:@"checkbox3_checked.png"] forState:UIControlStateSelected];
    _check.frame = CGRectZero;
    [_check setTitle:@"显示密码" forState:UIControlStateNormal];
    [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_scrollView addSubview:_check];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _phoneLabel.text = @"已验证安全手机: ";
    _phoneLabel.font = [UIFont systemFontOfSize:13.0f];
    _phoneLabel.textColor = [UIColor blackColor];
    [_scrollView addSubview:_phoneLabel];
    
    // 验证码输入框
    _verificationPCode = [[UITextField alloc] initWithFrame:CGRectZero];
    _verificationPCode.borderStyle = UITextBorderStyleNone;
    _verificationPCode.backgroundColor = [UIColor whiteColor];
    _verificationPCode.layer.borderWidth = 1;
    _verificationPCode.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_verificationPCode.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
     _verificationPCode.keyboardType =UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_verificationPCode];
    
    // 验证按钮
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectZero;
    _verifyBtn.backgroundColor = GreenColor;
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    _verifyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_verifyBtn.layer setMasksToBounds:YES];
    [_verifyBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_verifyBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_verifyBtn];
    
    //确定按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _submitBtn.frame = CGRectZero;
    [_submitBtn setTitle:@"确 定" forState:UIControlStateNormal];
    _submitBtn.layer.cornerRadius = 3.0f;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.backgroundColor = GreenColor;
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_submitBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_submitBtn];
    
    // TRUE 修改交易密码 （OPT = 104）
    // FALSE 设置交易密码（OPT = 103）
    if (_ispayPasswordStatus) {
        self.title = @"重置交易密码";
        
        for (int i = 0; i < 3; i++) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 75 + i * 50, self.view.frame.size.width - 40, 40)];
            [backView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            backView.backgroundColor = [UIColor whiteColor];
            
            [_scrollView addSubview:backView];
            
            UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 75, 36)];
            placeholderLabel.textColor = [UIColor lightGrayColor];
            placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
            placeholderLabel.textAlignment = NSTextAlignmentCenter;
            
            [backView addSubview:placeholderLabel];
            
            if (i == 0) {
                placeholderLabel.text = @"旧密码  |";
            }else if (i == 1) {
                placeholderLabel.text = @"新密码  |";
            }else {
                placeholderLabel.text = @"确认新密码 |";
                placeholderLabel.frame = CGRectMake(2, 2, 80, 36);
            }
        }
        
        // 密码输入框
        _oldPass.frame = CGRectMake(90, 81, self.view.frame.size.width - 120, 30);
        [_scrollView addSubview:_oldPass];
        
        // 密码输入框
        _nPassWord.frame = CGRectMake(90, 131, self.view.frame.size.width - 120, 30);
        [_scrollView addSubview:_nPassWord];
        
        // 验证新密码输入框
        _verificationPassword.frame = CGRectMake(105, 181, self.view.frame.size.width - 130, 30);
        [_scrollView addSubview:_verificationPassword];
        
        _promptLabel.frame = CGRectMake(20, 218, MSWIDTH-40, 15);
        _check.frame = CGRectMake(20, 235, 85, 30);
        
        // 安全手机Label
        _phoneLabel.frame = CGRectMake(20, 265, self.view.frame.size.width - 40, 30);
        
        // 验证码输入框
        _verificationPCode.frame = CGRectMake(20, 305, self.view.frame.size.width - 170, 35);
        
        // 验证按钮
        _verifyBtn.frame = CGRectMake(self.view.frame.size.width - 130, 305, 110, 35);
        
        //下一步按钮
        _submitBtn.frame = CGRectMake(20, 365, self.view.frame.size.width - 40, 45);
        
    }else {
        self.title = @"设置交易密码";
        
        for (int i = 0; i < 2; i++) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 75 + i * 50, self.view.frame.size.width - 40, 40)];
            [backView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            backView.backgroundColor = [UIColor whiteColor];
            
            [_scrollView addSubview:backView];
            
            UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 70, 36)];
            placeholderLabel.textColor = [UIColor lightGrayColor];
            placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
            placeholderLabel.textAlignment = NSTextAlignmentCenter;
            
            [backView addSubview:placeholderLabel];
            
            if (i == 0) {
                placeholderLabel.text = @"新密码  |";
            }else {
                placeholderLabel.text = @"验证密码 |";
            }
        }
        
        // 密码输入框
        _oldPass.frame = CGRectMake(90, 81, self.view.frame.size.width - 120, 30);
        [_scrollView addSubview:_oldPass];
        
        // 密码输入框
        _nPassWord.frame = CGRectMake(92, 131, self.view.frame.size.width - 120, 30);
        [_scrollView addSubview:_nPassWord];
        
        _promptLabel.frame = CGRectMake(20, 168, 300, 15);
        _check.frame = CGRectMake(20, 185, 85, 30);
        _phoneLabel.frame = CGRectMake(20, 215, self.view.frame.size.width - 40, 30);
        _verificationPCode.frame = CGRectMake(20, 255, self.view.frame.size.width - 170, 35);
        _verifyBtn.frame = CGRectMake(self.view.frame.size.width - 130, 255, 110, 35);
        _submitBtn.frame = CGRectMake(20, 310, self.view.frame.size.width - 40, 45);
    }
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
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
    for (UITextField *textField in [_scrollView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
}

#pragma mark 确定保存按钮
- (void)sureBtnClick:(UIButton *)btn
{
    DLOG(@"确定保存按钮");
    
    DLOG(@"isOPT ->%ld", (long)isOPT);
    [self requestData];
}

// 调用文本代理,判断输入的新密码是否一致。
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 111) {
        if (![_verificationPassword.text isEqualToString:_nPassWord.text]) {
           [SVProgressHUD showErrorWithStatus:@"输入的新密码不一致!"];
        }
    }
}

#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    DLOG(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
    
    if (checkbox.checked) {
        _oldPass.secureTextEntry = NO;
        _nPassWord.secureTextEntry = NO;
        _verificationPassword.secureTextEntry = NO;
    }else {
        _oldPass.secureTextEntry = YES;
        _nPassWord.secureTextEntry = YES;
        _verificationPassword.secureTextEntry = YES;
    }
}

#pragma mark 验证按钮
- (void)verifyBtnClick
{
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
    if ([_statuStr isEqualToString:@"竞拍设置"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


//  验证验证码
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    if (_ispayPasswordStatus) {
        isOPT = 104;
    }else {
        isOPT = 103;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)isOPT] forKey:@"OPT"];// 客户端设置交易密码接口
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    [parameters setObject:[NSString encrypt3DES:_nPassWord.text key:DESkey] forKey:@"newdealpwd"];
    [parameters setObject:_safePhone.phone forKey:@"cellPhone"];
    [parameters setObject:_verificationPCode.text forKey:@"randomCode"];
    
    if (isOPT == 104) {
        [parameters setObject:[NSString encrypt3DES:_oldPass.text key:DESkey] forKey:@"currentdealpwd"];
    }
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

#pragma 请求数据
-(void) requestSafePhoneData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    isOPT = 111;
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
        
        if (isOPT == 103 || isOPT == 104) {
            // 通知全局广播 LeftMenuController 修改UI操作
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"updatelist" object:@"1"];
            
              [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
            
        }else if(isOPT == 111) {
            
            _safePhone = [[SafePhone alloc] init];
            _safePhone.phone = [dics objectForKey:@"phoneNum"];
            _safePhone.status = [[dics objectForKey:@"status"] intValue];
            
            DLOG(@"安全手机: %@", _safePhone.phone);
            _phoneLabel.text = [NSString stringWithFormat:@"已验证安全手机: %@", _safePhone.phone];
            
        }else if(isOPT == 4){
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
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
