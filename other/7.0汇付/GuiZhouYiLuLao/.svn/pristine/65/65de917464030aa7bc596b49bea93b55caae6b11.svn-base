//
//  SetSafeEMailViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 安全邮箱设置

#import "SetSafeEMailViewController.h"
#import "VerifySafeQuestionViewTwoController.h"
#import "ActivationViewController.h"

#import "SafeEmail.h"

#import "ColorTools.h"
@interface SetSafeEMailViewController ()<HTTPClientDelegate>
{

    BOOL _isLoading;
}

@property (nonatomic, strong) SafeEmail *safeEmail;

@property (nonatomic, strong) UILabel *emaillabel;

@property (nonatomic, strong) UILabel *statulabel;

@property (nonatomic, strong) UIButton *changeBtn;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SetSafeEMailViewController

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
    _safeEmail = [[SafeEmail alloc] init];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titlelabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 120, 30)];
    titlelabel1.text = @"安全邮箱:";
    titlelabel1.font = [UIFont boldSystemFontOfSize:16.0f];
    titlelabel1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titlelabel1];
    
    _emaillabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 200, 30)];
    _emaillabel.text = @"";
    _emaillabel.font = [UIFont systemFontOfSize:15.0f];
    _emaillabel.textAlignment = NSTextAlignmentLeft;
    _emaillabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:_emaillabel];
    
    
    _statulabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 170, 100, 30)];
    _statulabel.text = @"";
    _statulabel.textColor = [UIColor blueColor];
    _statulabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _statulabel.textAlignment = NSTextAlignmentLeft;
    _statulabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:_statulabel];
    
    
    //修改按钮
    _changeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _changeBtn.frame = CGRectMake(10, 280, self.view.frame.size.width-20, 45);
    [_changeBtn setTitle:@"修 改" forState:UIControlStateNormal];
    _changeBtn.layer.cornerRadius = 3.0f;
    _changeBtn.layer.masksToBounds = YES;
    _changeBtn.backgroundColor = BrownColor;
    [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _changeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeBtn];
    

}

-(void) setValue
{
    _emaillabel.text = _safeEmail.emailAddress;
    if (_safeEmail.status) {
        _statulabel.text = @"已激活";
        [_changeBtn setTitle:@"修 改" forState:UIControlStateNormal];
    }else {
        _statulabel.text = @"未激活";
        [_changeBtn setTitle:@"激 活" forState:UIControlStateNormal];
    }
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"安全邮箱设置";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - 修改按钮
- (void)changeBtnClick:(id)sender
{
    if(!_isLoading){
        //已激活邮箱
        if (_safeEmail.status == 1)
        {
            if (_isSafeQuestion) {
                
                // 如果设置了安全问题
                VerifySafeQuestionViewTwoController  *verifySafeQuestionViewTwo= [[VerifySafeQuestionViewTwoController alloc] init];
                [self.navigationController pushViewController:verifySafeQuestionViewTwo animated:YES];
            }else
            {
                // 未设置安全问题
                [SVProgressHUD showErrorWithStatus:@"亲，请先设置安全问题"];
            }
        }else{
            //未激活邮箱
            ActivationViewController *activatView = [[ActivationViewController alloc] init];
            [self.navigationController pushViewController:activatView animated:YES];
            
        }
    }
}


#pragma mark - 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"109" forKey:@"OPT"];// 客户端安全问题是否设置接口
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
    _isLoading = YES;
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    DLOG(@"===%@=======", dics);
    
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {

        _safeEmail = [[SafeEmail alloc] init];
        _safeEmail.emailAddress = [NSString stringWithFormat:@"%@",[dics objectForKey:@"emailaddress"]];
        _safeEmail.status = [[dics objectForKey:@"status"] intValue];
        AppDelegateInstance.userInfo.isEmailStatus = YES;
        
        [self setValue];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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
