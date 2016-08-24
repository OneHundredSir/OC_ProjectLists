//
//  OverdueLoginViewController.m
//  SP2P_7
//
//  Created by kiu on 15/3/3.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//
//  过期重新登录页面

#import "OverdueLoginViewController.h"

#import "ColorTools.h"
#import "RegistrationViewController.h"
#import "RetrievePasswordViewController.h"
#import "FristGestureLockViewController.h"
#import "LoginWindowTextField.h"
#import "UserInfo.h"
#import "QCheckBox.h"
#import "AppDelegate.h"

#define kWidthWin self.view.frame.size.width - 40

@interface OverdueLoginViewController ()<HTTPClientDelegate, QCheckBoxDelegate, UITextFieldDelegate,LoginWindowDelegate>
{
    BOOL _isLoading;
    int curr;
}

@property (nonatomic, strong) UITextField *loginView;
// 只用于 密码 输入框的又控件
@property (nonatomic, strong) UISwitch *rightSwitch;
// 密码框
@property (nonatomic, strong) LoginWindowTextField *passWindow;
// 用户名框
@property (nonatomic, strong) LoginWindowTextField *nameWindow;

@property (nonatomic,strong) QCheckBox *check;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property(nonatomic,strong) NSArray *NameListArr;

@end

@implementation OverdueLoginViewController

- (void)viewDidLoad {
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
    curr = 0;
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
    self.title = @"登录";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
    backItem.tag = 1;
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
    // 导航条 右边 设置按钮
    UIBarButtonItem *settingItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
    settingItem.tag = 2;
    settingItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:settingItem];
    
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    UIControl *viewControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    // 用户名的边框
    UIButton *signBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn1.frame = CGRectMake(20, 80, kWidthWin, 38);
    signBtn1.backgroundColor = [UIColor whiteColor];
    [signBtn1.layer setMasksToBounds:YES];
    [signBtn1.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn1.layer setBorderWidth:1.0];   //边框宽度
    [signBtn1.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn1];
    
    // 用户名 输入框
    _nameWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(signBtn1.frame), kWidthWin, 38)];
    _nameWindow.text = [[AppDefaultUtil sharedInstance] getDefaultUserName];
    [_nameWindow addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventEditingChanged];
    [_nameWindow textWithleftImage:@"login_icon" rightImage:@"login_arrow_down" placeName:@"手机号/邮箱账号/用户名"];
    _nameWindow.loginWindowDelegate=self;
    _NameListArr = [[AppDefaultUtil sharedInstance] getDefaultNameList];
    _nameWindow.userLists= _NameListArr;
    
    // 密码的边框
    UIButton *signBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn2.frame = CGRectMake(20, CGRectGetMaxY(_nameWindow.frame) + 16, kWidthWin, 38);
    signBtn2.backgroundColor = [UIColor whiteColor];
    [signBtn2.layer setMasksToBounds:YES];
    [signBtn2.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn2.layer setBorderWidth:1.0];   //边框宽度
    [signBtn2.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn2];
    
    // 密码 输入框
    _passWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_nameWindow.frame) + 16, kWidthWin, 38)];
    _passWindow.secureTextEntry = YES;
//    _passWindow.text = [[AppDefaultUtil sharedInstance] getDefaultUserNoPassword];
    if ([[AppDefaultUtil sharedInstance] getDefaultUserPassword] != nil) {
        
        _passWindow.text = [NSString decrypt3DES:[[AppDefaultUtil sharedInstance] getDefaultUserPassword] key:DESkey];
    }
    [_passWindow textWithleftImage:@"login_lock" rightImage:nil placeName:@"密码"];
    
    [self.view addSubview:_nameWindow];
    [self.view addSubview:_passWindow];
    
    _rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kWidthWin - 40, CGRectGetMidY(_passWindow.frame) - 16, 30, 32)];
    [_rightSwitch setOn:YES];
    [_rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_rightSwitch];
    
    UIButton *getBackbutton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_passWindow.frame) - 70, CGRectGetMaxY(_passWindow.frame) + 12, 70, 30)];
    [getBackbutton setTitle:@"找回密码？" forState:UIControlStateNormal];
    [getBackbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    getBackbutton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    [getBackbutton addTarget:self action:@selector(getBackPassword) forControlEvents:UIControlEventTouchUpInside];
    
    _check = [[QCheckBox alloc] initWithDelegate:self];
    [_check setImage:[UIImage imageNamed:@"checkbox3_unchecked"] forState:UIControlStateNormal];
    [_check setImage:[UIImage imageNamed:@"checkbox3_checked"] forState:UIControlStateSelected];
    _check.frame = CGRectMake(20, CGRectGetMaxY(_passWindow.frame) + 12, 150, 30);
    [_check setTitle:@"记住密码" forState:UIControlStateNormal];
    [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _check.checked = [[AppDefaultUtil sharedInstance] isRemeberUser];
    [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.view addSubview:_check];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(20, CGRectGetMaxY(_check.frame) + 16, kWidthWin, 35);
    signBtn.backgroundColor = GreenColor;
    [signBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signBtn];
    
    [self.view addSubview:getBackbutton];
}

#pragma mark LoginWindowDelegate
- (void)shiftAccount:(NSString *)userName
{
    if(userName)
        _nameWindow.text=userName;
}



/**
 * 导航条两侧按钮点击事件
 * 根据Button的tag值区分
 */
- (void)butClick:(UIButton *)but
{
    switch (but.tag) {
        case 1:
            [self dismissViewControllerAnimated:YES completion:^(){}];
            
            break;
        case 2:
        {
            RegistrationViewController *regView = [[RegistrationViewController alloc] init];
            
            [self.navigationController pushViewController:regView animated:YES];
        }
            break;
    }
}

#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    DLOG(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
    [[AppDefaultUtil sharedInstance]  setRemeberUser:checked];
}

#pragma ===============

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

#pragma mark 点击登录按钮
- (void)signClick
{
    [self ControlAction];// 关闭键盘
    
    if ([_nameWindow.text isEqualToString:@""]) {
        return;
    }
    if ([_passWindow.text isEqualToString:@""]) {
        return;
    }
    
    if (!_isLoading) {
        // 不在加载
        // 账号：1  密码：1
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *name = _nameWindow.text;
        NSString *password = [NSString encrypt3DES:_passWindow.text key:DESkey];
        [parameters setObject:@"1" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:name forKey:@"name"];
        [parameters setObject:password forKey:@"pwd"];
        if(AppDelegateInstance.userId !=nil && AppDelegateInstance.channelId != nil)
        {
            [parameters setObject:AppDelegateInstance.userId forKey:@"userId"];
            [parameters setObject:AppDelegateInstance.channelId forKey:@"channelId"];
            
        }else{
            
            
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
}

#pragma mark 点击 找回密码 按钮
- (void)getBackPassword
{
    RetrievePasswordViewController *retrievePassword = [[RetrievePasswordViewController alloc] init];
    
    [self.navigationController pushViewController:retrievePassword animated:YES];
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
    _isLoading = YES;
    //    [[ProgressHUD sharedInstance] showLoading:self.view withString:[NSString stringWithFormat:@"Loading"]];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
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
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:@""];// 清除用户密码
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    _isLoading  = NO;
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    _isLoading  = NO;
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
    _isLoading  = NO;
}

-(void) loginSuccess
{
    
    // 登录成功，如果是需要记住密码.
    // 1、且如果该账号从未在设备中设置过手势密码，则需要设置该账号的手势密码
    // 2、且如果该账号曾经在该设备中设置过手势密码，则直接结束当前操作
    NSMutableArray *nameList = [_NameListArr mutableCopy];
    if (nameList.count)
    {
        
        if ([nameList indexOfObject:_nameWindow.text] == NSNotFound) {
            
            [nameList addObject:_nameWindow.text];
            NSLog(@"用户名类别数据222222222222%@",nameList);
        }
        
    }else{
        
        [nameList addObject:_nameWindow.text];
        
    }
    NSArray *nameArr = [nameList copy];
    [[AppDefaultUtil sharedInstance] setDefaultNameList:nameArr];// 保存用户名数组数据
    NSLog(@"用户名类别数据%@",[[AppDefaultUtil sharedInstance] getDefaultNameList]);
    
    if (_check.checked) {
        
        
        // 需要记住密码
        // 保存账号密码到UserDefault
        [[AppDefaultUtil sharedInstance] setDefaultUserName:AppDelegateInstance.userInfo.userName];// 保存用户昵称
        [[AppDefaultUtil sharedInstance] setDefaultAccount:_nameWindow.text];// 保存用户账号
//        [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:_passWindow.text];// 保存用户密码（未加密）
        NSString *pwdStr = [NSString encrypt3DES:_passWindow.text key:DESkey];//用户密码3Des加密
        [[AppDefaultUtil sharedInstance] setDefaultUserPassword:pwdStr];// 保存用户密码（des加密）
        [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:AppDelegateInstance.userInfo.userImg];// 保存用户头像
        [[AppDefaultUtil sharedInstance] setdeviceType:AppDelegateInstance.userInfo.deviceType];// 保存设备型号
        
        DLOG(@"name is =======> %@",_nameWindow.text);
//        
//        FristGestureLockViewController *controller = [[FristGestureLockViewController alloc] init];
//        
//        [self.navigationController pushViewController:controller animated:YES];
        [self dismissViewControllerAnimated:YES completion:^(){}];
        
        
    } else {
        
        [[AppDefaultUtil sharedInstance] removeGesturesPasswordWithAccount:_nameWindow.text];// 移除该账号的手势密码
        
        [[AppDefaultUtil sharedInstance] setDefaultUserName:@""];// 清除用户昵称
        [[AppDefaultUtil sharedInstance] setDefaultAccount:@""];// 清除用户账号
        [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
        [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:@""];// 清除用户头像
        [[AppDefaultUtil sharedInstance] setDefaultUserNoPassword:@""];// 清除用户昵称
        
        [self dismissViewControllerAnimated:YES completion:^(){}];
    }
    
}

#pragma mark 退出页面，释放网络请求
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

#pragma mark UITextField代理
-(void)changeValue {
    _passWindow.text = @"";
}

@end
