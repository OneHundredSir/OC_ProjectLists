//
//  JoinVipViewController.m
//  SP2P_7
//
//  Created by kiu on 14/10/22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  申请VIP

#import "JoinVipViewController.h"
#import "QCheckBox.h"
#import "MemberProtocolViewController.h"
#define NUMBERS @"0123456789\n"

@interface JoinVipViewController ()<QCheckBoxDelegate, HTTPClientDelegate, UITextFieldDelegate> {
    int vipFee;
    int isOPT;
    int vipTimeType;  // 0: 年  1: 月
    NSInteger vipMinTimeLength; // VIP最少开通时间
    int vipMinTimeType;  // VIP最少开通时间类型  0: 年  1: 月
    
    int isData;     // 记录金额是否变化（0：没变    1：改变）
}

@property (nonatomic, strong) UILabel *vipName;         // 开通对象
@property (nonatomic, strong) UITextField *openTime;    // 开通时间
@property (nonatomic, strong) UILabel *moneyLabel;      // 开通金额
@property (nonatomic, strong) UILabel *vipTimeTypeLabel;

@property (nonatomic, strong) QCheckBox *agreeProtocol;         // 同意协议
@property (nonatomic, strong) UIButton *confirmationBtn;        // 确认按钮
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation JoinVipViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    isOPT = 151;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"151" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.// 初始化数据
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
    self.title = @"申请VIP";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    // 监听屏幕，释放键盘
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    // 开通对象
    UILabel *objectLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 85, 100, 30)];
    objectLabel.text = @"开通对象:";
    objectLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:objectLabel];
    
    // 会员名
    _vipName = [[UILabel alloc] initWithFrame:CGRectMake(95, 85, 200, 30)];
    _vipName.text = AppDelegateInstance.userInfo.userName;
    _vipName.textColor = [UIColor redColor];
    [self.view addSubview:_vipName];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 125, 100, 30)];
    timeLabel.text = @"开通时间:";
    timeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:timeLabel];
    
    UIView * leftview = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];//只有宽度起到了作用
    leftview.backgroundColor = [UIColor clearColor];     // 要设置左视图模式
    
    // 开通时间 输入框
    _openTime = [[UITextField alloc] initWithFrame:CGRectMake(95, 125, 180, 30)];
    _openTime.textColor = [UIColor redColor];
    _openTime.backgroundColor = [UIColor whiteColor];
    _openTime.layer.borderWidth = 1;
    _openTime.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _openTime.delegate = self;
    _openTime.font = [UIFont boldSystemFontOfSize:14.0f];
    _openTime.keyboardType = UIKeyboardTypeNumberPad;
    [_openTime addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_openTime];
    
    _openTime.leftView = leftview;
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 165, 60, 30)];
    _moneyLabel.textColor = [UIColor redColor];
    _moneyLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _openTime.leftViewMode = UITextFieldViewModeAlways;
    
    _vipTimeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 125, 15, 30)];
    _vipTimeTypeLabel.text = @"";
    _vipTimeTypeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_vipTimeTypeLabel];
    
    UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 165, 100, 30)];
    mLabel.text = @"应付金额:";
    mLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:mLabel];
    
    // 金额
    _moneyLabel.text = @"0";
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 165, 15, 30)];
    label.text = @"元";
    label.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:label];
    
    _agreeProtocol = [[QCheckBox alloc] initWithDelegate:self];
    [_agreeProtocol setImage:[UIImage imageNamed:@"checkbox3_unchecked.png"] forState:UIControlStateNormal];
    [_agreeProtocol setImage:[UIImage imageNamed:@"checkbox3_checked.png"] forState:UIControlStateSelected];
    _agreeProtocol.frame = CGRectMake(80, 205, 100, 30);
    [_agreeProtocol setTitle:@"接受条款" forState:UIControlStateNormal];
    [_agreeProtocol setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_agreeProtocol.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.view addSubview:_agreeProtocol];
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.frame = CGRectMake(160, 205, 100, 30);
    [protocolBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [protocolBtn setTitle:@"会员服务条款" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolBtn];
    
    _confirmationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmationBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 75, 250, 150, 35);
    _confirmationBtn.backgroundColor = PinkColor;
    [_confirmationBtn setTitle:@"确 定" forState:UIControlStateNormal];
    _confirmationBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [_confirmationBtn.layer setMasksToBounds:YES];
    [_confirmationBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [_confirmationBtn addTarget:self action:@selector(_confirmationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmationBtn];
}

#pragma mark - 单选框 代理
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    
    
}

#pragma 会员服务协议
- (void)protocolClick {
    MemberProtocolViewController *member = [[MemberProtocolViewController alloc] init];
    member.opt = @"27";
    [self.navigationController pushViewController:member animated:YES];
}

#pragma 确认按钮
- (void)_confirmationClick {
    if (_agreeProtocol.checked) {
        
        isOPT = 26;
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"26" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        
        // vipMinTimeType (0: 年   1: 月)
        // 年 的话就转换成 月
        if (vipTimeType == 1) {
            
            [parameters setObject:_openTime.text forKey:@"openTime"];
            
        }else {
            
            [parameters setObject:[NSString stringWithFormat:@"%d", [_openTime.text intValue] * 12] forKey:@"openTime"];
            
        }
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"请先同意协议"];
    }
}

// 返回
- (void)butClick:(UIButton *)but
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
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
        
        if (isOPT == 151) {
            DLOG(@"%@", obj);
            
            vipFee = (int)[[obj objectForKey:@"vipFee"] integerValue];
            vipMinTimeLength = [[obj objectForKey:@"vipMinTimeLength"] integerValue];
            vipMinTimeType = (int)[[obj objectForKey:@"vipMinTimeType"] integerValue];
            vipTimeType = (int)[[obj objectForKey:@"vipTimeType"] integerValue];
            
            [self setValue];
            
        }else {
            [SVProgressHUD showSuccessWithStatus:@"申请成功"];
            
            // 申请会员成功，金额发生变化
            isData = 1;
            
            // 发送通知，更改左视图数据
            AppDelegateInstance.userInfo.isVipStatus = @"1";
            //通知检测对象
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:^{}];
                
                // 判断金额是否发生变化，变化了就发送通知更改左视图数据
                if (isData) {
                    [[NSNotificationCenter defaultCenter]  postNotificationName:@"update2" object:nil];
                }
                
            });
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

// 取消网络请求
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
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

- (void)setValue {
    if (vipTimeType == 1) {
        _vipTimeTypeLabel.text = @"月";
    }else {
        _vipTimeTypeLabel.text = @"年";
    }
    
    if (vipMinTimeType == 1) {
        _openTime.placeholder = [NSString stringWithFormat:@"至少开通%ld个月", (long)vipMinTimeLength];
    }else {
        _openTime.placeholder = [NSString stringWithFormat:@"至少开通%ld年", (long)vipMinTimeLength];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    _moneyLabel.text = [NSString stringWithFormat:@"%.f", [_openTime.text floatValue] * vipFee];
    
}

- (void)valueChange
{
    _moneyLabel.text = [NSString stringWithFormat:@"%.f", [_openTime.text floatValue] * vipFee];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == _openTime)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            return NO;
        }
    }
    //其他的类型不需要检测，直接写入
    return YES;
}
@end
