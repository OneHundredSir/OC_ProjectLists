//
//  ChangeLoginPasswordViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  修改登陆密码

#import "ChangeLoginPasswordViewController.h"

#import "ColorTools.h"
#import "QCheckBox.h"
#import "SafePhone.h"
#import "LoginViewController.h"

@interface ChangeLoginPasswordViewController ()<QCheckBoxDelegate,UITextFieldDelegate, HTTPClientDelegate, UIAlertViewDelegate>
{
    NSInteger _requestType; // 0获取是否有安全手机 ，1提交修改密码
}

@property (nonatomic, strong) SafePhone *safePhone; // 安全手机

@property (nonatomic, strong) UITextField *oldPass;                 // 旧密码框
@property (nonatomic, strong) UITextField *nPassWord;               // 新密码框
@property (nonatomic, strong) UITextField *verificationPassword;    // 验证新密码
@property (nonatomic, strong) UILabel *phoneLabel;              // 安全手机
@property (nonatomic, strong) UITextField *verificationPCode;       // 验证码
@property (nonatomic, strong) UIButton *verifyBtn;                  // 获取验证码按钮
@property (nonatomic, strong) UIButton *submitBtn;                  // 确定按钮

@property (nonatomic,strong) QCheckBox *check;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation ChangeLoginPasswordViewController

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
{}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    self.view.backgroundColor = KblackgroundColor;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIView *header = [[UIView alloc]initWithFrame:self.view.bounds];
    self.tableView.tableHeaderView = header;
    
    CGFloat backViewY = 75.f-64;
    for (int i = 0; i < 3; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, backViewY + i * 50, self.view.frame.size.width - 40, 40)];
        [backView.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        backView.backgroundColor = [UIColor whiteColor];
        
        [header addSubview:backView];
        
        UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 70, 36)];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
        placeholderLabel.textAlignment = NSTextAlignmentCenter;
        
        [backView addSubview:placeholderLabel];
        
        if (i == 0) {
            placeholderLabel.text = @"旧密码  |";
        }else if (i == 1) {
            placeholderLabel.text = @"新密码  |";
        }else {
            placeholderLabel.text = @"验证密码 |";
        }
    }
    
    // 密码输入框
    _oldPass = [[UITextField alloc] initWithFrame:CGRectMake(90, 82 - 64, self.view.frame.size.width - 120, 30)];
    _oldPass.secureTextEntry = YES;
    _oldPass.font = [UIFont boldSystemFontOfSize:14.0f];
    _oldPass.backgroundColor = [UIColor whiteColor];
    [header addSubview:_oldPass];
    
    // 密码输入框
    _nPassWord = [[UITextField alloc] initWithFrame:CGRectMake(90, 132 - 64, self.view.frame.size.width - 120, 30)];
    _nPassWord.secureTextEntry = YES;
    _nPassWord.backgroundColor = [UIColor whiteColor];
    _nPassWord.font = [UIFont boldSystemFontOfSize:14.0f];
    [header addSubview:_nPassWord];
    
    // 验证新密码输入框
    _verificationPassword = [[UITextField alloc] initWithFrame:CGRectMake(95, 182 - 64, self.view.frame.size.width - 120, 30)];
    _verificationPassword.secureTextEntry = YES;
    _verificationPassword.backgroundColor = [UIColor whiteColor];
    _verificationPassword.font = [UIFont boldSystemFontOfSize:14.0f];
    _verificationPassword.delegate = self;
    _verificationPassword.tag = 111;
    [header addSubview:_verificationPassword];
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 215 - 64, 300, 15)];
    textlabel.text = @"请输入6—16位字母和数字组成的密码";
    textlabel.font = [UIFont systemFontOfSize:13.0f];
    textlabel.textColor = [UIColor lightGrayColor];
    textlabel.lineBreakMode =   NSLineBreakByCharWrapping;
    textlabel.numberOfLines = 0;
    [header addSubview:textlabel];
    
    _check = [[QCheckBox alloc] initWithDelegate:self];
    [_check setImage:[UIImage imageNamed:@"checkbox3_unchecked.png"] forState:UIControlStateNormal];
    [_check setImage:[UIImage imageNamed:@"checkbox3_checked.png"] forState:UIControlStateSelected];
    _check.frame = CGRectMake(20, 225, 150, 50);
    [_check setTitle:@"显示密码" forState:UIControlStateNormal];
    [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [header addSubview:_check];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 265 - 64, self.view.frame.size.width - 40, 30)];
    _phoneLabel.font = [UIFont systemFontOfSize:14.0f];
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.text = @"已验证安全手机: ";
    [header addSubview:_phoneLabel];
    
    // 验证码输入框
    _verificationPCode = [[UITextField alloc] initWithFrame:CGRectMake(20, 305 - 64, self.view.frame.size.width - 170, 35)];
    _verificationPCode.borderStyle = UITextBorderStyleNone;
    _verificationPCode.backgroundColor = [UIColor whiteColor];
    _verificationPCode.placeholder = @"请输入验证码";
    _verificationPCode.layer.borderWidth = 1;
    _verificationPCode.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _verificationPCode.keyboardType = UIKeyboardTypeDecimalPad;
    [_verificationPCode.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [header addSubview:_verificationPCode];
    
    // 验证按钮
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(self.view.frame.size.width - 130, 305 -64 , 110, 35);
    _verifyBtn.backgroundColor = GreenColor;
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_verifyBtn.layer setMasksToBounds:YES];
    [_verifyBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_verifyBtn addTarget:self action:@selector(VerifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:_verifyBtn];
    
    //下一步按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _submitBtn.frame = CGRectMake(10, 365 - 64, self.view.frame.size.width - 20, 45);
    [_submitBtn setTitle:@"完 成" forState:UIControlStateNormal];
    _submitBtn.layer.cornerRadius = 3.0f;
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.backgroundColor = GreenColor;
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_submitBtn addTarget:self action:@selector(NextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:_submitBtn];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    if ([_viewType isEqualToString:@"tradePwd"]) {
        self.title = @"修改交易密码";
    }else {
        self.title = @"修改登录密码";
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
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
- (void)VerifyBtnClick
{
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
    
    DLOG(@"_safePhone.phone ->%@", _safePhone.phone);
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    _requestType = 2;
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

//#pragma mark 点击空白处收回键盘
//- (void)ControlAction
//{
//    [self.view endEditing:YES];
//}

#pragma mark 确定保存按钮
- (void)NextBtnClick
{
    if ([_oldPass.text isEqualToString:@""]) {
        DLOG(@"请输入当前密码");
         [SVProgressHUD showErrorWithStatus:@"请输入旧密码！"];
        return;
    }
    
    if([_nPassWord.text isEqualToString:@""]){
        DLOG(@"请输入新密码");
         [SVProgressHUD showErrorWithStatus:@"请输入新密码！"];
        return;
    }
    
    if(![_nPassWord.text isEqualToString:_verificationPassword.text]){
        DLOG(@"新密码输入不一致！");
        DLOG(@"新密码输入不一致！ %@", _nPassWord.text);
        [SVProgressHUD showErrorWithStatus:@"新密码输入不一致！"];
        return;
    }
   
    [self requestData];
}

-(void) setSuccess
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[AppDefaultUtil sharedInstance] removeGesturesPasswordWithAccount:[[AppDefaultUtil sharedInstance] getDefaultUserName]];// 移除该账号的手势密码
    
    [[AppDefaultUtil sharedInstance] setDefaultUserName:@""];// 清除用户昵称
    [[AppDefaultUtil sharedInstance] setDefaultAccount:@""];// 清除用户账号
    [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
    [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:@""];// 清除用户头像
    
    // 重新登录
    LoginViewController *loginView = [[LoginViewController alloc] init];
    loginView.isShow_leftBtn = 1;
    [self.navigationController pushViewController:loginView animated:YES];
}

#pragma mark UIalertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //  确定按钮，退出当前界面
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 请求数据
-(void) requestSafePhoneData
{
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    _requestType = 0;
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


#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    _requestType = 1;
    // 账号：1  密码：1
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([_viewType isEqualToString:@"tradePwd"]) {
        [parameters setObject:@"104" forKey:@"OPT"];// 客户端修改交易密码接口
        if (_oldPass.text) {
            NSString *oldPwd = [NSString encrypt3DES:_oldPass.text key:DESkey];
            [parameters setObject:oldPwd forKey:@"currentdealpwd"];
        }else
            [parameters setObject:@"" forKey:@"currentdealpwd"];
        
        if (_nPassWord.text) {
            NSString *newPwd = [NSString encrypt3DES:_nPassWord.text key:DESkey];
            [parameters setObject:newPwd forKey:@"newdealpwd"];
        }else
            [parameters setObject:@"" forKey:@"newdealpwd"];
        
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        if(_safePhone.phone != nil && ![_safePhone.phone isEqual:[NSNull null]]){
            
            [parameters setObject:_safePhone.phone forKey:@"cellPhone"];
        }else
            [parameters setObject:@"" forKey:@"cellPhone"];
        
        [parameters setObject:_verificationPCode.text forKey:@"randomCode"];
    }else {
        [parameters setObject:@"105" forKey:@"OPT"];// 客户端修改登录密码接口
        if (_oldPass.text) {
            NSString *oldPwd = [NSString encrypt3DES:_oldPass.text key:DESkey];
            [parameters setObject:oldPwd forKey:@"oldloginpwd"];
        }else
            [parameters setObject:@"" forKey:@"oldloginpwd"];
        
        if (_nPassWord.text) {
            NSString *newPwd = [NSString encrypt3DES:_nPassWord.text key:DESkey];
            [parameters setObject:newPwd forKey:@"newloginpwd"];
        }else
            [parameters setObject:@"" forKey:@"newloginpwd"];
        
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        if(_safePhone.phone != nil && ![_safePhone.phone isEqual:[NSNull null]]){
            
            [parameters setObject:_safePhone.phone forKey:@"cellPhone"];
        }else
            [parameters setObject:@"" forKey:@"cellPhone"];
        
        [parameters setObject:_verificationPCode.text forKey:@"randomCode"];
    }
    
    [parameters setObject:@"" forKey:@"body"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    DLOG(@"===%@=======", dics);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if(_requestType == 0){
            DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
            
            _safePhone = [[SafePhone alloc] init];
            _safePhone.phone = [dics objectForKey:@"phoneNum"];
            _safePhone.status = [[dics objectForKey:@"status"] intValue];
            
            _phoneLabel.text = [NSString stringWithFormat:@"已验证安全手机: %@", _safePhone.phone];

        }else if(_requestType == 1){
            DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
            
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            
//            2. 1.5秒后重新登录
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self setSuccess];
                
            });
        }else if (_requestType == 2){
            DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
        }
    } else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        // 服务器返回数据异常
         [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"失败 -> %@", [obj objectForKey:@"msg"]]];
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
#pragma  mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
