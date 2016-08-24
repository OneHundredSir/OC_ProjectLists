//
//  RetrievePasswordViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  忘记密码

#import "RetrievePasswordViewController.h"

#import "ColorTools.h"
#import "LoginWindowTextField.h"
#import "RetrieveThreeViewController.h"

#import "NSString+Shove.h"

#define kWidthWin self.view.frame.size.width - 40

@interface RetrievePasswordViewController ()<UITextFieldDelegate, HTTPClientDelegate> {
    BOOL _isPhone;
    BOOL _isSuccess;
}

@property (nonatomic, strong) LoginWindowTextField *phoneWindow;
@property (nonatomic, strong) LoginWindowTextField *verificationWindow;
@property (nonatomic, strong) UIButton *verificationBtn;
// 验证码提示文本
@property (nonatomic, strong) UILabel *textf;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation RetrievePasswordViewController

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
    self.title = @"手机验证";
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
    
    // 手机号 输入框
    _phoneWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 84, kWidthWin, 35)];
    [_phoneWindow textWithleftImage:@"login_phone" rightImage:nil placeName:@"请输入绑定的手机号码"];
    _phoneWindow.keyboardType = UIKeyboardTypePhonePad;
    _phoneWindow.delegate = self;
    _phoneWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_phoneWindow];
    
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 160, 30)];
//    label3.text = @"输入短信中的验证码";
//    label3.textColor = [UIColor darkGrayColor];
//    label3.font = [UIFont fontWithName:@"Arial" size:14.0];
//    [self.view addSubview:label3];
    // 验证码 输入框
    _verificationWindow = [[LoginWindowTextField alloc] initWithFrame:CGRectMake(20, 130, self.view.frame.size.width - 170, 35)];
    [_verificationWindow textWithleftImage:nil rightImage:nil placeName:@"请输入验证码"];
    _verificationWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_verificationWindow];
    
    _verificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verificationBtn.frame = CGRectMake(self.view.frame.size.width - 140, 130, 120, 35);
    _verificationBtn.backgroundColor = BrownColor;
    [_verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verificationBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_verificationBtn.layer setMasksToBounds:YES];
    [_verificationBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_verificationBtn addTarget:self action:@selector(verificationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verificationBtn];
    
   
    
//    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(20, 205, kWidthWin, 30)];
//    label5.text = @"点击下一步，验证成功即可重置密码";
//    label5.textColor = [UIColor darkGrayColor];
//    label5.font = [UIFont fontWithName:@"Arial" size:14.0];
//    [self.view addSubview:label5];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(20, 180, kWidthWin, 35);
    signBtn.backgroundColor = BrownColor;
    [signBtn setTitle:@"下一步" forState:UIControlStateNormal];
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

- (void)signClick
{
    DLOG(@"下一步");
    if (_verificationWindow.text == nil)
    {
        [SVProgressHUD showImage:nil status:@"验证码为空"];
        return;
    }
    if(!_isPhone){
        
         [SVProgressHUD showImage:nil status:@"手机号码格式不正确"];
        return;
    }
        _isSuccess = YES;
    
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"5" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_phoneWindow.text forKey:@"cellPhone"];
        [parameters setObject:_verificationWindow.text forKey:@"randomCode"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
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

#pragma mark 调用文本代理
- (void)textFieldDidEndEditing:(UITextField *)textField {
    DLOG(@"textField -> %@", textField.text);
    
    if ([_phoneWindow.text isPhone]) {
        DLOG(@"phone is right");
        
        _isPhone = YES;
    }else {
        DLOG(@"phone is wrong");
        _isPhone = FALSE;
        
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
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        if (_isSuccess) {
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            [userD setObject:_phoneWindow.text forKey:@"phone"];
            
            RetrieveThreeViewController *second = [[RetrieveThreeViewController alloc] init];
            [self.navigationController pushViewController:second animated:YES];
            
            _verificationWindow.text = @"";
            _phoneWindow.text = @"";
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus1:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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

#pragma mark 点击获取验证码按钮
- (void)verificationClick {
    
    DLOG(@"_phoneWindow ->%@", _phoneWindow.text);
    if ([_phoneWindow.text isEqualToString:@""]) {
        
        [SVProgressHUD showImage:nil status:@"手机号码为空"];
        
    }else {
        _isSuccess = FALSE;
        
        __block int timeout = 30; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    
                    [_verificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                    _verificationBtn.userInteractionEnabled = YES;
                    [_verificationBtn setAlpha:1];
                });
            }else{
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    
                    [_verificationBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    _verificationBtn.userInteractionEnabled = NO;
                    [_verificationBtn setAlpha:0.4];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
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
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
