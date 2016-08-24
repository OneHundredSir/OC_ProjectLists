//
//  NetvaluecalculatorViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  净值计算器

#import "NetvaluecalculatorViewController.h"
#import "ColorTools.h"

@interface NetvaluecalculatorViewController ()<UITextFieldDelegate,HTTPClientDelegate>
{
    NSMutableArray *titleArr;

}
@property (nonatomic,strong)UITextField  *textField;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *label3;
@property (nonatomic,strong)UITextField *balance;       // 可用金额
@property (nonatomic,strong)UITextField *receive;       // 待收金额
@property (nonatomic,strong)UITextField *pay;           // 待付金额
@property (nonatomic,strong)UIView *topView;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation NetvaluecalculatorViewController

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
    titleArr = [NSMutableArray arrayWithObjects:@"可用余额",@"待收金额",@"待还金额",@"元",@"元",@"元",nil];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
     self.view.backgroundColor = KblackgroundColor;
    
  
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 74, MSWIDTH-20, 320)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_topView.layer setMasksToBounds:YES];
    [_topView.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [self.view addSubview:_topView];

    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:viewControl];
    
    
    for (int i = 0; i <= 2; i++) {
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 25 + i * 50, 70, 30)];
        titlelabel.text = [titleArr objectAtIndex:i];
        titlelabel.font = [UIFont systemFontOfSize:15.0f];
        [_topView addSubview:titlelabel];
        
        UILabel *titlelabel2 = [[UILabel alloc] initWithFrame:CGRectMake(235, 25 + i * 50, 20, 30)];
        titlelabel2.text = [titleArr objectAtIndex:i+3];
        titlelabel2.font = [UIFont systemFontOfSize:15.0f];
        [_topView addSubview:titlelabel2];
    }
    
    // 可用金额 输入框
    _balance  = [[UITextField alloc] initWithFrame:CGRectMake(110, 25, 120, 30)];
    _balance.borderStyle = UITextBorderStyleRoundedRect;
    _balance.delegate = self;
    _balance.placeholder = @"请输入可用金额";
    _balance.keyboardType = UIKeyboardTypeDecimalPad;
    _balance.font = [UIFont systemFontOfSize:13.0f];
    [_topView addSubview:_balance];
    
    // 待收金额 输入框
    _receive  = [[UITextField alloc] initWithFrame:CGRectMake(110, 75, 120, 30)];
    _receive.borderStyle = UITextBorderStyleRoundedRect;
    _receive.delegate = self;
    _receive.placeholder = @"请输入待收金额";
    _receive.keyboardType = UIKeyboardTypeDecimalPad;
    _receive.font = [UIFont systemFontOfSize:13.0f];
    [_topView addSubview:_receive];
    
    // 待付金额 输入框
    _pay  = [[UITextField alloc] initWithFrame:CGRectMake(110, 125, 120, 30)];
    _pay.borderStyle = UITextBorderStyleRoundedRect;
    _pay.delegate = self;
    _pay.placeholder = @"请输入待还金额";
    _pay.font = [UIFont systemFontOfSize:13.0f];
    _pay.keyboardType = UIKeyboardTypeDecimalPad;
    [_topView addSubview:_pay];
    
    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [calculateBtn setFrame:CGRectMake(_topView.frame.size.width * 0.5 - 40, 180, 80, 30)];
    [calculateBtn setTitle:@"计算" forState:UIControlStateNormal];
    [calculateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calculateBtn.layer setCornerRadius:3.0f];
    calculateBtn.backgroundColor = GreenColor;
    [calculateBtn addTarget:self action:@selector(calculateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:calculateBtn];
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label1.font = [UIFont systemFontOfSize:14.0f];
    [_topView addSubview:_label1];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label2.font = [UIFont systemFontOfSize:15.0f];
    _label2.textColor = [UIColor redColor];
    [_topView addSubview:_label2];
    
    _label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label3.font = [UIFont systemFontOfSize:14.0f];
    [_topView addSubview:_label3];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"净值计算器";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark 返回按钮
- (void)backClick
{
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 计算按钮点击触发方法
- (void)calculateBtnClick:(UIButton *)btn
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
        return;
    }else {
        
        if ([_balance.text isEqual: @""]||[_receive.text isEqual:@""]||[_pay.text isEqual: @""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确值"];
        }else {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:@"139" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
            [parameters setObject:_balance.text forKey:@"balance"];
            [parameters setObject:_receive.text forKey:@"receive"];
            [parameters setObject:_pay.text forKey:@"pay"];
            
            if (_requestClient == nil) {
                _requestClient = [[NetWorkClient alloc] init];
                _requestClient.delegate = self;
            }
            [_requestClient requestGet:@"app/services" withParameters:parameters];
        }
    }
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    for (UITextField *textField in [_topView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
    
}

#pragma UItextField协议代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
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
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        UIFont *font = [UIFont fontWithName:@"Arial" size:14];
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        _label1.text = @"您最多可以借";
        _label2.text = [NSString stringWithFormat:@"%@", [obj objectForKey:@"amount"]];
        _label3.text = @"元的借款";
        
        CGSize _label1Sz = [_label1.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize _label2Sz = [_label2.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGSize _label3Sz = [_label3.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        _label1.frame = CGRectMake(20, 240, _label1Sz.width, 30);
        _label2.frame = CGRectMake(_label1.frame.origin.x + _label1.frame.size.width + 5, 240, _label2Sz.width + 5, 30);
        _label3.frame = CGRectMake(_label2.frame.origin.x + _label2.frame.size.width + 5, 240, _label3Sz.width, 30);
        
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
    
//    if (_requestClient != nil) {
//        [_requestClient cancel];
//    }
}

@end
