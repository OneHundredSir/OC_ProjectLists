//
//  RetrieveThreeViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "RetrieveThreeViewController.h"

#import "ColorTools.h"
#import "LoginWindowTextField.h"
#import "LoginViewController.h"

#define kWidthWin self.view.frame.size.width - 40

@interface RetrieveThreeViewController ()<HTTPClientDelegate>

@property (nonatomic, strong) LoginWindowTextField *passWindow;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation RetrieveThreeViewController

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
 初始化数据
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
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"输入新密码";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tag = 1;
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
    
    UIButton *signBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn2.frame = CGRectMake(20, 80, kWidthWin, 35);
    signBtn2.backgroundColor = [UIColor whiteColor];
    [signBtn2.layer setMasksToBounds:YES];
    [signBtn2.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn2.layer setBorderWidth:1.0];   //边框宽度
    [signBtn2.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn2];
    // 密码 输入框
    _passWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 80, kWidthWin, 35)];
    _passWindow.secureTextEntry = YES;
    [_passWindow textWithleftImage:@"login_lock" rightImage:nil placeName:@"输入新密码"];
    
    [self.view addSubview:_passWindow];
    
    UISwitch *_rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kWidthWin - 40, 82, 30, 24)];
    [_rightSwitch setOn:YES];
    [_rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_rightSwitch];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, kWidthWin, 30)];
    label1.text = @"1.为了您的账户安全，新旧密码必须不同";
    label1.font = [UIFont fontWithName:@"Arial" size:13.0];
    label1.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 145, kWidthWin, 50)];
    label2.text = @"2.6-16位字符（字母 数字 符号），不能只使用一个字符，区分大小写";
    label2.numberOfLines = 0;
    label2.font = [UIFont fontWithName:@"Arial" size:14.0];
    label2.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label2];
       
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(20, 200, kWidthWin, 35);
    signBtn.backgroundColor = GreenColor;
    [signBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signBtn];
}

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

// 点击 登录 按钮
- (void)signClick
{
    if ((_passWindow.text.length < 6)||(_passWindow.text.length > 16)) {
        DLOG(@"密码格式有误，请重新输入！");
        
        [SVProgressHUD showErrorWithStatus:@"密码格式有误，请重新输入！"];
    }else {
        DLOG(@"提交成功");
        
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSString *phone = [userD objectForKey:@"phone"];
        
        DLOG(@"phone -> %@", phone);
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
         NSString *password = [NSString encrypt3DES:_passWindow.text key:DESkey];
        [parameters setObject:@"6" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:phone forKey:@"cellPhone"];
        [parameters setObject:password forKey:@"newpwd"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
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
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置成功" message:@"恭喜你的密码重置成功！" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        
        [alertView show];
       // [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
        [[AppDefaultUtil sharedInstance] setDefaultUserName:@""];// 清除用户昵称
        [[AppDefaultUtil sharedInstance] setDefaultAccount:@""];// 清除用户账号
        [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
        [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:@""];// 清除用户头像
               
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            LoginViewController *loginView = [[LoginViewController alloc] init];
            
            [self.navigationController pushViewController:loginView animated:YES];
        });
        
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
