//
//  SetSafePhoneNumTwoViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 设置安全手机号码

#import "SetSafePhoneNumTwoViewController.h"
#import "ColorTools.h"

@interface SetSafePhoneNumTwoViewController ()<UITextFieldDelegate,UIAlertViewDelegate, HTTPClientDelegate>
{
    BOOL _isLoading;
    
    NSInteger _requestType;
}

@property (nonatomic,strong)UITextField *SafePhoneNumtextfield;
@property (nonatomic,strong)UITextField *Verifytextfield;
@property (nonatomic,strong)UIButton *verifyBtn;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SetSafePhoneNumTwoViewController

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
    
    
    UILabel *titlelabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 120, 30)];
    titlelabel1.text = @"安全手机";
    titlelabel1.font = [UIFont boldSystemFontOfSize:16.0f];
    titlelabel1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titlelabel1];

    // 手机号码输入框
    _SafePhoneNumtextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, self.view.frame.size.width - 40, 40)];
    _SafePhoneNumtextfield.borderStyle = UITextBorderStyleNone;
    _SafePhoneNumtextfield.layer.borderWidth = 0.5;
    _SafePhoneNumtextfield.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _SafePhoneNumtextfield.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_SafePhoneNumtextfield];
    
    // 验证码输入框
    _Verifytextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 170, self.view.frame.size.width - 170, 35)];
    _Verifytextfield.borderStyle = UITextBorderStyleNone;
    _Verifytextfield.backgroundColor = [UIColor whiteColor];
    _Verifytextfield.layer.borderWidth = 0.5f;
    _Verifytextfield.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:_Verifytextfield];
    
    // 验证按钮
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.frame = CGRectMake(self.view.frame.size.width - 140, 170, 120, 35);
    _verifyBtn.backgroundColor = GreenColor;
    [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verifyBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_verifyBtn.layer setMasksToBounds:YES];
    [_verifyBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_verifyBtn addTarget:self action:@selector(VerifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verifyBtn];
    
    //保存并激活按钮
    UIButton *ChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ChangeBtn.frame = CGRectMake(10, 280, self.view.frame.size.width-20, 45);
    [ChangeBtn setTitle:@"保 存" forState:UIControlStateNormal];
    ChangeBtn.layer.cornerRadius = 3.0f;
    ChangeBtn.layer.masksToBounds = YES;
    ChangeBtn.backgroundColor = GreenColor;
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
    self.title = @"安全手机设置";
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


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark 验证按钮
- (void)VerifyBtnClick
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
                
                [_verifyBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                _verifyBtn.userInteractionEnabled = NO;
                [_verifyBtn setAlpha:0.4];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    DLOG(@"获取验证码");
    if([_SafePhoneNumtextfield.text isEqualToString:@""]){
        DLOG(@"请填写您的安全手机号码");
        return;
    }
    _requestType = 0;
    
    [self getVerification:nil];
}

#pragma mark 保存并激活按钮
- (void)ChangeBtnClick
{
    if([_SafePhoneNumtextfield.text isEqualToString:@""]){
        DLOG(@"请填写您的安全手机号码");
        return;
    }
    
    if([_Verifytextfield.text isEqualToString:@""]){
        DLOG(@"请输入您收到的验证码");
        return;
    }
    _requestType = 1;
    [self requestData];
}


-(void) setSuccess
{
    DLOG(@"保存并激活按钮");
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertview show];
}

#pragma mark UIalertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}



#pragma 请求数据

//  获取验证码
-(void) getVerification:(UIButton *)sender
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_SafePhoneNumtextfield.text forKey:@"cellPhone"];

    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];

}


-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"7" forKey:@"OPT"];// 绑定手机号码
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_SafePhoneNumtextfield.text forKey:@"cellPhone"];
    [parameters setObject:_Verifytextfield.text forKey:@"randomCode"];
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
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if(_requestType == 0){
            // 成功发送验证码
            DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
            
        }else if(_requestType == 1){
            //  设置成功
            [self setSuccess];
            AppDelegateInstance.userInfo.isMobileStatus = YES;
            // 通知全局广播 LeftMenuController 修改UI操作
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"updatelist" object:@"1"];
        }
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus1:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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
