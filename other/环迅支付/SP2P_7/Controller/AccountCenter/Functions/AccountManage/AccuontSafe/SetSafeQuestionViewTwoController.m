//
//  SetSafeQuestionView2Controller.m
//  SP2P_7
//
//  Created by Jerry on 14-6-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "SetSafeQuestionViewTwoController.h"
#import "ColorTools.h"
#import "SetSafeQuestionViewTwoController.h"
#import "VerifySafeQuestionViewController.h"

#import "SetSafeQuestionViewController.h"

#import "SafeQuestion.h"

// 账户管理 - 账户安全 - 设置安全问题

@interface SetSafeQuestionViewTwoController ()<HTTPClientDelegate>
{
    
}

@property (nonatomic, strong) SafeQuestion *safeQuestion;

@property (nonatomic, strong) UILabel *answerlabel1;
@property (nonatomic, strong) UILabel *answerlabel2;
@property (nonatomic, strong) UILabel *answerlabel3;
@property (nonatomic, strong) UILabel *questionlabel1;
@property (nonatomic, strong) UILabel *questionlabel2;
@property (nonatomic, strong) UILabel *questionlabel3;

@property (nonatomic, strong) UIButton *modifyBtn;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SetSafeQuestionViewTwoController

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
    
    
    [self requestData];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    _safeQuestion = [[SafeQuestion alloc]  init];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<3; i++) {
        
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80+80*i, 150, 30)];
        textlabel.text = [NSString stringWithFormat:@"安全问题%d:",i+1];
        textlabel.font = [UIFont boldSystemFontOfSize:15.0f];
        textlabel.textColor = [UIColor darkGrayColor];
        [self.view addSubview:textlabel];
        
        
        UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 120+80*i, 200, 30)];
        textlabel2.text = @"答案:************************";
        textlabel2.font = [UIFont systemFontOfSize:15.0f];
        textlabel2.textColor = [UIColor darkGrayColor];
        [self.view addSubview:textlabel2];
        
    }
    
    _questionlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(95, 80, 230, 30)];
    
    _questionlabel1.textAlignment = NSTextAlignmentLeft;
    _questionlabel1.font = [UIFont boldSystemFontOfSize:15.0f];
    _questionlabel1.textColor = [UIColor grayColor];
    [self.view addSubview:_questionlabel1];
    
    _questionlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(95, 160, 230, 30)];
    
    _questionlabel2.textAlignment = NSTextAlignmentLeft;
    _questionlabel2.font = [UIFont systemFontOfSize:15.0f];
    _questionlabel2.textColor = [UIColor grayColor];
    [self.view addSubview:_questionlabel2];
    
    _questionlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(95, 240, 230, 30)];
    
    _questionlabel3.textAlignment = NSTextAlignmentLeft;
    _questionlabel3.font = [UIFont systemFontOfSize:15.0f];
    _questionlabel3.textColor = [UIColor grayColor];
    [self.view addSubview:_questionlabel3];
    
    
    //修改安全问题按钮
    _modifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _modifyBtn.frame = CGRectMake(10, 380, self.view.frame.size.width-20, 45);
    [_modifyBtn setTitle:@"修改安全问题" forState:UIControlStateNormal];
    [_modifyBtn setTitle:@"修改安全问题" forState:UIControlStateHighlighted];
    _modifyBtn.layer.cornerRadius = 3.0f;
    _modifyBtn.layer.masksToBounds = YES;
    _modifyBtn.backgroundColor = GreenColor;
    [_modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _modifyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_modifyBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_modifyBtn];
    
    
}



/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"安全问题设置";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

-(void) setValue
{
    
    if ([_safeQuestion.question1 isEqual:[NSNull null]] && [_safeQuestion.question2 isEqual:[NSNull null]] && [_safeQuestion.question3 isEqual:[NSNull null]]) {
        [_modifyBtn setTitle:@"设置安全问题" forState:UIControlStateNormal];
        [_modifyBtn setTitle:@"设置安全问题" forState:UIControlStateHighlighted];
    }
    
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


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 修改安全问题按钮
- (void)changeBtnClick
{
    if ([_safeQuestion.question1 isEqual:[NSNull null]] && [_safeQuestion.question2 isEqual:[NSNull null]] && [_safeQuestion.question3 isEqual:[NSNull null]]) {
        DLOG(@"确定按钮");
        // 未设置，初始设置安全问题
        SetSafeQuestionViewController *VerifySafeQuestionView = [[SetSafeQuestionViewController alloc] init];
        [self.navigationController pushViewController:VerifySafeQuestionView animated:YES];
    }else if(![_safeQuestion.question1 isEqual:[NSNull null]] && ![_safeQuestion.question2 isEqual:[NSNull null]] && ![_safeQuestion.question3 isEqual:[NSNull null]]){
        // 验证提示问题 ,修改安全问题
        
        VerifySafeQuestionViewController *verifySafeQuestionView = [[VerifySafeQuestionViewController alloc] init];
        verifySafeQuestionView.safeQuestion = _safeQuestion;
        [self.navigationController pushViewController:verifySafeQuestionView animated:YES];
    }
    
}



#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
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
        
        _safeQuestion = [[SafeQuestion alloc] init];
        
        _safeQuestion.question1 = [dics objectForKey:@"question1"];
        _safeQuestion.question2 = [dics objectForKey:@"question2"];
        _safeQuestion.question3 = [dics objectForKey:@"question3"];
        
        [self setValue];
        
    } else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
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
