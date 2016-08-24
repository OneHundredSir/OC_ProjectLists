//
//  AddBankVCardViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AddBankVCardViewController.h"

#import "ColorTools.h"
#import "BankCardInfo.h"
#import "SendValuedelegate.h"


#define NUMBERS @"0123456789\n"

@interface AddBankVCardViewController ()<UITextFieldDelegate, HTTPClientDelegate >
{
    
    NSMutableArray *dataArr;
    
}

@property (nonatomic, strong) UITextField *banknameField;

@property (nonatomic, strong) UITextField *idField;

@property (nonatomic, strong) UITextField *nameField;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property(nonatomic ,strong) UIScrollView *scrollView;
@end

@implementation AddBankVCardViewController

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
    if (_bankCard == nil) {
        _bankCard = [[BankCard alloc] init];
    }
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    dataArr = [[NSMutableArray alloc] init];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64)];
    _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    UILabel *banknamelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 70, 30)];
    banknamelabel.text = @"银行名称";
    banknamelabel.textColor = [UIColor darkGrayColor];
    banknamelabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_scrollView addSubview:banknamelabel];
    
    //银行名称输入框
    _banknameField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(banknamelabel.frame) + 2, self.view.frame.size.width-20, 36)];
    _banknameField.borderStyle = UITextBorderStyleNone;
    _banknameField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _banknameField.layer.borderWidth = 0.5f;
    _banknameField.backgroundColor = [UIColor whiteColor];
    _banknameField.font = [UIFont systemFontOfSize:15.0f];
    _banknameField.delegate = self;
    _banknameField.placeholder = @"请输入银行名称";
    _banknameField.text = _bankCard.bankName;
    
    [_scrollView addSubview:_banknameField];
    
    UILabel *bankidlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_banknameField.frame) + 6, 70, 30)];
    bankidlabel.text = @"账号";
    bankidlabel.textColor = [UIColor darkGrayColor];
    bankidlabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_scrollView addSubview:bankidlabel];
    
    //账号输入框
    _idField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(bankidlabel.frame) + 2, self.view.frame.size.width-20, 36)];
    _idField.borderStyle = UITextBorderStyleNone;
    _idField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _idField.layer.borderWidth = 0.5f;
    _idField.backgroundColor = [UIColor whiteColor];
    _idField.font = [UIFont systemFontOfSize:15.0f];
    _idField.text = _bankCard.account;
    _idField.keyboardType = UIKeyboardTypeNumberPad;
    _idField.delegate = self;
//    _idField.tag = 1000;
    _idField.placeholder = @"请输入账号";
    [_scrollView addSubview:_idField];
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_idField.frame) + 6, 70, 30)];
    namelabel.text = @"收款人";
    namelabel.textColor = [UIColor darkGrayColor];
    namelabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_scrollView addSubview:namelabel];
    
    //输入框
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(namelabel.frame) + 2, self.view.frame.size.width-20, 36)];
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _nameField.layer.borderWidth = 0.5f;
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.font = [UIFont systemFontOfSize:15.0f];
    _nameField.delegate = self;
    _nameField.text = _bankCard.accountName;
    _nameField.placeholder = @"请输入收款人名称";
    [_scrollView addSubview:_nameField];
    
    UIButton *surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    surebtn.frame = CGRectMake(10, CGRectGetMaxY(_nameField.frame) + 16, self.view.frame.size.width-20, 45);
    [surebtn setTitle:@"确 定" forState:UIControlStateNormal];
    surebtn.layer.cornerRadius = 3.0f;
    surebtn.layer.masksToBounds = YES;
    surebtn.backgroundColor = GreenColor;
    [surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surebtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [surebtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:surebtn];
    
}

#pragma mark 
- (void)sureBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
      [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    if ([_banknameField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行名称"];
    }
    
    if ([_idField.text isEqualToString:@""]) {
         [SVProgressHUD showErrorWithStatus:@"请输入账号"];
    }
    
    if ([_nameField.text isEqualToString:@""]) {
         [SVProgressHUD showErrorWithStatus:@"请输入收款人"];
    }
    
    [self requestData];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    if(_editType == BankCardEditModify)
    {
        self.title = @"编辑银行卡";
    }
    else
    {
        self.title = @"添加银行卡";
    }
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
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

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 请求数据
-(void) requestData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_idField.text forKey:@"bankCardNum"];
    [parameters setObject:_nameField.text forKey:@"cardUserName"];
    [parameters setObject:_banknameField.text forKey:@"bankName"];

    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    DLOG(@"_bankCard.bankCardId ->%ld", (long)_bankCard.bankCardId);
    if (_editType == BankCardEditModify) {
        [parameters setObject:[NSString stringWithFormat:@"%ld" , (long)_bankCard.bankCardId] forKey:@"bankId"];
        [parameters setObject:[NSString stringWithFormat:@"%d", 100] forKey:@"OPT"];
    } else {
        [parameters setObject:@"99" forKey:@"OPT"];
    }
    
    
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
    
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:AddBankCardSuccess object:self];
            
        });
        
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
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    
}

#pragma JGProgressHUDDelegate



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

#pragma 限制只能输入数字和.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange = YES;
    
    if (textField.tag == 1000) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
        
       
    }
     return canChange;
}

@end
