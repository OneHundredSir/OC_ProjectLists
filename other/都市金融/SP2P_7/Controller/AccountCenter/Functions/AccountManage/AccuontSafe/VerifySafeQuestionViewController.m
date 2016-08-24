//
//  VerifySafeQuestionViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 安全问题校验界面

#import "VerifySafeQuestionViewController.h"
#import "SetSafeQuestionViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "ColorTools.h"
@interface VerifySafeQuestionViewController ()<UITextFieldDelegate,UIAlertViewDelegate, HTTPClientDelegate>
{
    BOOL _isLoading;
}

@property (nonatomic, strong) UILabel *answerlabel1;
@property (nonatomic, strong) UILabel *answerlabel2;
@property (nonatomic, strong) UILabel *answerlabel3;

@property (nonatomic, strong) UITextField *textfield1;
@property (nonatomic, strong) UITextField *textfield2;
@property (nonatomic, strong) UITextField *textfield3;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation VerifySafeQuestionViewController

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
{}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    CGFloat selfW = self.tableView.frame.size.width;
    self.tableView.backgroundColor = KblackgroundColor;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIView *header = [[UIView alloc]initWithFrame:self.tableView.bounds];
    self.tableView.tableHeaderView = header;
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, selfW - 10*2, 60)];
    textlabel.text = @"您正在进行修改操作，系统需要校验您的安全问题。";
    textlabel.lineBreakMode =   NSLineBreakByCharWrapping;
    textlabel.font = [UIFont boldSystemFontOfSize:16.0f];
    textlabel.numberOfLines = 0;
    [header addSubview:textlabel];
    
    CGFloat textlabelY = 120 - 64;
    CGFloat textlabel2Y = 160 - 64;
    for (int i = 0; i<3; i++) {
        
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, textlabelY+80*i, 150, 30)];
        textlabel.text = [NSString stringWithFormat:@"安全问题%d:",i+1];
        textlabel.font = [UIFont boldSystemFontOfSize:15.0f];
        textlabel.tag = 10 + i;
        textlabel.textColor = [UIColor darkGrayColor];
        [header addSubview:textlabel];
        
        UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, textlabel2Y+80*i, 100, 30)];
        textlabel2.text = @"输入答案:";
        textlabel2.tag = 100 + i;
        textlabel2.font = [UIFont boldSystemFontOfSize:15.0f];
        textlabel2.textColor = [UIColor darkGrayColor];
        [header addSubview:textlabel2];
    }
    
    //输入框1
    _textfield1 = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMidY([header viewWithTag:100].frame) - 18, 200, 36)];
    _textfield1.borderStyle = UITextBorderStyleNone;
    _textfield1.backgroundColor = [UIColor whiteColor];
    _textfield1.layer.borderWidth = 0.5f;
    _textfield1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textfield1.delegate = self;
    [header addSubview:_textfield1];
    
    //输入框2
    _textfield2 = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMidY([header viewWithTag:101].frame) - 18, 200, 36)];
    _textfield2.borderStyle = UITextBorderStyleNone;
    _textfield2.backgroundColor = [UIColor whiteColor];
    _textfield2.layer.borderWidth = 0.5f;
    _textfield2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textfield2.delegate = self;
    [header addSubview:_textfield2];
    
    //输入框3
    _textfield3 = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMidY([header viewWithTag:102].frame) - 18, 200, 35)];
    _textfield3.borderStyle = UITextBorderStyleNone;
    _textfield3.backgroundColor = [UIColor whiteColor];
    _textfield3.layer.borderWidth = 0.5f;
    _textfield3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _textfield3.delegate = self;
    _textfield1.returnKeyType = _textfield2.returnKeyType = UIReturnKeyNext;
    _textfield3.returnKeyType = UIReturnKeyDone;
    _textfield3.enablesReturnKeyAutomatically = _textfield2.enablesReturnKeyAutomatically = _textfield1.enablesReturnKeyAutomatically = YES;
    [header addSubview:_textfield3];
    
    CGFloat _answerlabel1Y = 120.f - 64;
    _answerlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(95, _answerlabel1Y, 230, 30)];
    _answerlabel1.text = _safeQuestion.question1;
    _answerlabel1.textAlignment = NSTextAlignmentLeft;
    _answerlabel1.font = [UIFont systemFontOfSize:15.0f];
    _answerlabel1.textColor = [UIColor grayColor];
    [header addSubview:_answerlabel1];
    
    _answerlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(95, _answerlabel1Y + 80, 230, 30)];
    _answerlabel2.text = _safeQuestion.question2;
    _answerlabel2.textAlignment = NSTextAlignmentLeft;
    _answerlabel2.font = [UIFont systemFontOfSize:15.0f];
    _answerlabel2.textColor = [UIColor grayColor];
    [header addSubview:_answerlabel2];
    
    _answerlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(95, _answerlabel1Y + 80*2, 230, 30)];
    _answerlabel3.text = _safeQuestion.question3;
    _answerlabel3.textAlignment = NSTextAlignmentLeft;
    _answerlabel3.font = [UIFont systemFontOfSize:15.0f];
    _answerlabel3.textColor = [UIColor grayColor];
    [header addSubview:_answerlabel3];
    
    //确定按钮
    UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SureBtn.frame = CGRectMake(10, 390 - 64, header.frame.size.width-20, 45);
    [SureBtn setTitle:@"确定" forState:UIControlStateNormal];
    SureBtn.layer.cornerRadius = 3.0f;
    SureBtn.layer.masksToBounds = YES;
    SureBtn.backgroundColor = GreenColor;
    [SureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [SureBtn addTarget:self action:@selector(SureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:SureBtn];
    
    
    //邮箱重置按钮
    UIButton *mailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mailBtn.frame = CGRectMake(10, 450-64, 100, 15);
    [mailBtn setTitle:@"忘记问题密码?" forState:UIControlStateNormal];
    [mailBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [mailBtn addTarget:self action:@selector(mailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:mailBtn];
    
}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"安全问题校验";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark UItextfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfield1) {
        [textField resignFirstResponder];
        [self.textfield2 becomeFirstResponder];
    }else if (textField == self.textfield2){
        [textField resignFirstResponder];
        [self.textfield3 becomeFirstResponder];
    }else if (textField == self.textfield3){
        [textField resignFirstResponder];
    }
    return YES;
    
}

//#pragma mark 点击空白处收回键盘
//- (void)ControlAction
//{
//    
//    for (UITextField *textField in [header subviews])
//    {
//        if ([textField isKindOfClass: [UITextField class]]) {
//            
//            [textField  resignFirstResponder];
//        }
//        
//    }
//    
//}

#pragma mark 确定按钮
- (void)SureBtnClick
{
    DLOG(@"提交确定按钮");
    if ([_textfield1.text isEqualToString:@""] ) {
        DLOG(@"未填写问题一");
        return;
    }
    
    if ([_textfield2.text isEqualToString:@""] ) {
        DLOG(@"未填写问题二");
        return;
    }
    
    if ([_textfield3.text isEqualToString:@""] ) {
        DLOG(@"未填写问题三");
        return;
    }
    
    [self requestSubmitData];
    
}

-(void) verifySuccess
{
    SetSafeQuestionViewController *SetSafeQuestionView = [[SetSafeQuestionViewController alloc] init];
    [self.navigationController pushViewController:SetSafeQuestionView animated:YES];
}

#pragma mark UIalertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark 确认按钮
- (void)mailBtnClick
{
    DLOG(@"邮箱重置按钮");
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"重置安全问题" message:@"尊敬的用户，安全问题是您账户的重要安全保障，如果遗忘，请通过以下方法重置！重置安全问题点击下面按钮，系统将向您的安全邮箱发送安全问题重置邮件。" delegate:self cancelButtonTitle:@"邮箱重置" otherButtonTitles:nil, nil];
    [alertview show];

}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
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
        
        [self verifySuccess];// 验证成功
        
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



#pragma  submit请求数据
-(void) requestSubmitData
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"102" forKey:@"OPT"];// 客户端安全问题内容接口
    [parameters setObject:@"" forKey:@"body"];

    if (_textfield1.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_textfield1.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer1"];
    }else{
        [parameters setObject:@"" forKey:@"answer1"];
        
    }
    if (_textfield2.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_textfield2.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer2"];
    }else{
        [parameters setObject:@"" forKey:@"answer2"];
        
    }
    if (_textfield3.text) {
        NSString *aswerStr1 = [NSString encrypt3DES:_textfield3.text key:DESkey];
        [parameters setObject:aswerStr1 forKey:@"answer3"];
    }else{
        
        [parameters setObject:@"" forKey:@"answer3"];
        
    }
    


    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
#pragma  mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
