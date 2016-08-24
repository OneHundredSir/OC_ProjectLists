//
//  FindDealPassword2ViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FindDealPasswordTwoViewController.h"

#import "ColorTools.h"
#import "SetNewDealPassWordViewController.h"
#import "SafeQuestion.h"
#import "MSKeyboardScrollView.h"
@interface FindDealPasswordTwoViewController ()<UITextFieldDelegate, HTTPClientDelegate>
{
    NSInteger _requestType; // 0代表获取安全问题，1代表提交验证
}

@property (nonatomic, strong) UILabel *questionlabel1;
@property (nonatomic, strong) UILabel *questionlabel2;
@property (nonatomic, strong) UILabel *questionlabel3;

@property (nonatomic, strong) UITextField *answerlabel1;
@property (nonatomic, strong) UITextField *answerlabel2;
@property (nonatomic, strong) UITextField *answerlabel3;
@property (nonatomic, strong) MSKeyboardScrollView *scrollView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation FindDealPasswordTwoViewController

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
    
    // 获取安全问题
    _requestType = 0;
    
    [self requestData];
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
    
    _scrollView = [[MSKeyboardScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = KblackgroundColor;
    [self.view addSubview:_scrollView];
    
    /*UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];*/
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 78, 25, 25)];
    [imgView setImage:[UIImage imageNamed:@"dealpassword_safe"]];
    [_scrollView addSubview:imgView];
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 70, 300, 40)];
    textlabel.text = @"请回答安全问题来验证身份";
    textlabel.font = [UIFont boldSystemFontOfSize:18.0f];
    textlabel.textColor = [UIColor darkGrayColor];
    [_scrollView addSubview:textlabel];
    
    for (int i = 0; i<3; i++) {
        
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 120+80*i, 110, 30)];
        textlabel.text = [NSString stringWithFormat:@"安全问题%d:",i+1];
        textlabel.font = [UIFont boldSystemFontOfSize:15.0f];
        textlabel.tag = 10 + i;
        [_scrollView addSubview:textlabel];
        
        UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 160+80*i, 100, 30)];
        textlabel2.text = @"输入答案:";
        textlabel2.tag = 100 + i;
        textlabel2.font = [UIFont boldSystemFontOfSize:15.0f];
        [_scrollView addSubview:textlabel2];

    }
    
//    answerlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 120, 230, 30)];
//    answerlabel1.text = @"你妈妈的生日？";
//    answerlabel1.textAlignment = NSTextAlignmentLeft;
//    answerlabel1.font = [UIFont boldSystemFontOfSize:15.0f];
//    answerlabel1.textColor = [UIColor darkGrayColor];
//    [_scrollView addSubview:answerlabel1];
//    
//    answerlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 200, 230, 30)];
//    answerlabel2.text = @"你就读的小学名称？";
//    answerlabel2.textAlignment = NSTextAlignmentLeft;
//    answerlabel2.font = [UIFont boldSystemFontOfSize:15.0f];
//    answerlabel2.textColor = [UIColor darkGrayColor];
//    [_scrollView addSubview:answerlabel2];
//    
//    answerlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(90, 280, 230, 30)];
//    answerlabel3.text = @"你大学宿舍的门牌号？";
//    answerlabel3.textAlignment = NSTextAlignmentLeft;
//    answerlabel3.font = [UIFont boldSystemFontOfSize:15.0f];
//    answerlabel3.textColor = [UIColor darkGrayColor];
//    [_scrollView addSubview:answerlabel3];
    
    //输入框1
    _answerlabel1 = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMidY([self.view viewWithTag:100].frame) - 18, MSWIDTH-130, 36)];
    _answerlabel1.borderStyle = UITextBorderStyleNone;
    _answerlabel1.backgroundColor = [UIColor whiteColor];
    _answerlabel1.layer.borderWidth = 0.5f;
    _answerlabel1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _answerlabel1.delegate = self;
    [_scrollView addSubview:_answerlabel1];
    
    //输入框2
    _answerlabel2 = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMidY([self.view viewWithTag:101].frame) - 18, MSWIDTH-130, 36)];
    _answerlabel2.borderStyle = UITextBorderStyleNone;
    _answerlabel2.backgroundColor = [UIColor whiteColor];
    _answerlabel2.layer.borderWidth = 0.5f;
    _answerlabel2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _answerlabel2.delegate = self;
    [_scrollView addSubview:_answerlabel2];
    
    //输入框3
    _answerlabel3 = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMidY([self.view viewWithTag:102].frame) - 18, MSWIDTH-130, 35)];
    _answerlabel3.borderStyle = UITextBorderStyleNone;
    _answerlabel3.backgroundColor = [UIColor whiteColor];
    _answerlabel3.layer.borderWidth = 0.5f;
    _answerlabel3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _answerlabel3.delegate = self;
    [_scrollView addSubview:_answerlabel3];
    
    _questionlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(95, 120, 230, 30)];
    _questionlabel1.text = _safeQuestion.question1;
    _questionlabel1.textAlignment = NSTextAlignmentLeft;
    _questionlabel1.font = [UIFont systemFontOfSize:15.0f];
    _questionlabel1.textColor = [UIColor grayColor];
    [_scrollView addSubview:_questionlabel1];
    
    _questionlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(95, 200, 230, 30)];
    _questionlabel2.text = _safeQuestion.question2;
    _questionlabel2.textAlignment = NSTextAlignmentLeft;
    _questionlabel2.font = [UIFont systemFontOfSize:15.0f];
    _questionlabel2.textColor = [UIColor grayColor];
    [_scrollView addSubview:_questionlabel2];
    
    _questionlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(95, 280, 230, 30)];
    _questionlabel3.text = _safeQuestion.question3;
    _questionlabel3.textAlignment = NSTextAlignmentLeft;
    _questionlabel3.font = [UIFont systemFontOfSize:15.0f];
    _questionlabel3.textColor = [UIColor grayColor];
    [_scrollView addSubview:_questionlabel3];
    
    //下一步按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = CGRectMake(10, 400, self.view.frame.size.width-20, 45);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 3.0f;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.backgroundColor = GreenColor;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:nextBtn];
    
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 448, self.view.frame.size.width, 15)];
    warnLabel.textColor = [UIColor grayColor];
    warnLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    warnLabel.text = @"温馨提示:忘记安全问题,请登录PC端找回。";
    [_scrollView addSubview:warnLabel];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"找回交易密码";
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
    
    for (UITextField *textField in [self.scrollView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }
    
}
#pragma mark 确定按钮
- (void)nextBtnClick
{

    [self ControlAction];
    
    DLOG(@"提交确定按钮");
    if ([_answerlabel1.text isEqualToString:@""] ) {
        DLOG(@"未填写问题一");
        
        
       [SVProgressHUD showErrorWithStatus:@"未填写问题一"];
        
        return;
    }
    
    if ([_answerlabel2.text isEqualToString:@""] ) {
        DLOG(@"未填写问题二");
        
        [SVProgressHUD showErrorWithStatus:@"未填写问题二"];
        
        return;
    }
    
    if ([_answerlabel3.text isEqualToString:@""] ) {
        DLOG(@"未填写问题三");
        
       [SVProgressHUD showErrorWithStatus:@"未填写问题三"];
        return;
    }
    
    _requestType = 1;
    [self requestSubmitData];
    
}


-(void) verifySuccess
{
    SetNewDealPassWordViewController *setDealPad = [[SetNewDealPassWordViewController alloc] init];
    setDealPad.ispayPasswordStatus = NO;
    setDealPad.statuStr = @"正常设置";
    [self.navigationController pushViewController:setDealPad animated:YES];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma  submit请求数据
-(void) requestSubmitData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"102" forKey:@"OPT"];// 客户端安全问题内容接口
    [parameters setObject:@"" forKey:@"body"];
    
    if (_answerlabel1.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_answerlabel1.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer1"];
    }else{
        [parameters setObject:@"" forKey:@"answer1"];
        
    }
    if (_answerlabel2.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_answerlabel2.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer2"];
    }else{
        [parameters setObject:@"" forKey:@"answer2"];
        
    }
    if (_answerlabel3.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_answerlabel3.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer3"];
    }else{
        
        [parameters setObject:@"" forKey:@"answer3"];
        
    }
//    [parameters setObject:_answerlabel1.text forKey:@"answer1"];
//    [parameters setObject:_answerlabel2.text forKey:@"answer2"];
//    [parameters setObject:_answerlabel3.text forKey:@"answer3"];
    
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
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    // 账号：1  密码：1
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"101" forKey:@"OPT"];// 客户端获取安全问题内容接口
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
    
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (_requestType == 0) {
            _safeQuestion = [[SafeQuestion alloc] init];
            
            _safeQuestion.question1 = [dics objectForKey:@"question1"];
            _safeQuestion.question2 = [dics objectForKey:@"question2"];
            _safeQuestion.question3 = [dics objectForKey:@"question3"];
            
            [self setValue];
        } else if (_requestType == 1){
            [self verifySuccess];// 验证成功
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

#pragma 设置视图

-(void) setValue
{
    
    if (![_safeQuestion.question1 isEqual:[NSNull null]]) {
        _questionlabel1.text = _safeQuestion.question1;
    }
    
    if (![_safeQuestion.question2 isEqual:[NSNull null]]) {
        _questionlabel2.text = _safeQuestion.question2;
    }
    
    if (![_safeQuestion.question3 isEqual:[NSNull null]]) {
        _questionlabel3.text = _safeQuestion.question3;
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
