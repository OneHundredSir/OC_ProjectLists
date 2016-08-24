//
//  VerifyPasswordViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "VerifyPasswordViewController.h"

#import "ColorTools.h"
#import "RegistrationViewController.h"
#import "RetrievePasswordViewController.h"
#import "ChangeGesturesPasswordViewController.h"

#import "LoginWindowTextField.h"

#define kWidthWin self.view.frame.size.width - 40

@interface VerifyPasswordViewController ()

@property (nonatomic, strong) UITextField *loginView;
// 只用于 密码 输入框的又控件
@property (nonatomic, strong) UISwitch *rightSwitch;
// 密码框
@property (nonatomic, strong) LoginWindowTextField *passWindow;
// 用户名框
@property (nonatomic, strong) LoginWindowTextField *nameWindow;

@end

@implementation VerifyPasswordViewController

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
    self.title = @"验证密码";
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
    
    
    // 用户名 输入框
    _nameWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 80, kWidthWin, 35)];
    [_nameWindow textWithleftImage:@"login_icon" rightImage:@"login_arrow_down" placeName:@"手机号/邮箱账号/用户名"];
    
    UIButton *signBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn2.frame = CGRectMake(20, 130, kWidthWin, 35);
    signBtn2.backgroundColor = [UIColor whiteColor];
    [signBtn2.layer setMasksToBounds:YES];
    [signBtn2.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn2.layer setBorderWidth:1.0];   //边框宽度
    [signBtn2.layer setBorderColor:KlayerBorder.CGColor];//边框颜色
    [self.view addSubview:signBtn2];
    // 密码 输入框
    _passWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 130, kWidthWin, 35)];
    _passWindow.secureTextEntry = YES;
    [_passWindow textWithleftImage:@"login_lock" rightImage:@"" placeName:@"密码"];
    
    [self.view addSubview:_nameWindow];
    [self.view addSubview:_passWindow];
    
    _rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kWidthWin - 40, 132, 30, 24)];
    [_rightSwitch setOn:YES];
    [_rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_rightSwitch];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(20, 180, kWidthWin, 35);
    signBtn.backgroundColor = GreenColor;
    [signBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signBtn];
    
    UIButton *getBackbutton = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, 80, 30)];
    [getBackbutton setTitle:@"找回密码？" forState:UIControlStateNormal];
    [getBackbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    getBackbutton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    [getBackbutton addTarget:self action:@selector(getBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:getBackbutton];
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
    
    DLOG(@"yonghumin wei %@",[[AppDefaultUtil sharedInstance] getDefaultUserName]);
    if ([_nameWindow.text isEqualToString:[[AppDefaultUtil sharedInstance] getDefaultUserName]]&&[_passWindow.text isEqualToString:[[AppDefaultUtil sharedInstance] getDefaultUserPassword]]) {
        
        ChangeGesturesPasswordViewController *ChangeGesturesPasswordView = [[ChangeGesturesPasswordViewController alloc] init];
        [self.navigationController pushViewController:ChangeGesturesPasswordView animated:YES];
    }else{

       [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];

    }
  
}

// 点击 找回密码 按钮
- (void)getBackClick
{
    RetrievePasswordViewController *retrievePassword = [[RetrievePasswordViewController alloc] init];
    
    [self.navigationController pushViewController:retrievePassword animated:YES];
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


@end
