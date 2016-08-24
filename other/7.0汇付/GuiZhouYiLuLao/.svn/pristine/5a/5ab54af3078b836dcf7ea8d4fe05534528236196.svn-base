//
//  SendMessageViewController.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  发站内信=======================================


#import "SendMessageViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

@interface SendMessageViewController ()<UITextViewDelegate,HTTPClientDelegate,UITextFieldDelegate>


@property (nonatomic ,strong) UILabel *titleLabel1;
@property (nonatomic ,strong) UILabel *titleLabel2;
@property (nonatomic ,strong) UITextView *contentView;
@property (nonatomic ,strong) UITextField *titleField;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SendMessageViewController

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
    
    // 监听屏幕，释放键盘
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    _titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width, 30)];
    _titleLabel1.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel1.text = [NSString stringWithFormat:@"发给: %@***", [_borrowName substringWithRange:NSMakeRange(0, 1)]];
//    _titleLabel1.text = [NSString stringWithFormat:@"发给: %@",self.borrowName];
    _titleLabel1.textColor = [UIColor darkGrayColor];
    _titleLabel1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel1];
    
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"标题:";
    titleLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:titleLabel];
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-60, 30)];
    _titleField.borderStyle = UITextBorderStyleNone;
    _titleField.layer.borderWidth = 0.5f;
    _titleField.backgroundColor = [UIColor whiteColor];
    _titleField.layer.cornerRadius = 5.0f;
    _titleField.delegate = self;
    _titleField.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [self.view addSubview:_titleField];
    
    UILabel  *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width-30, 30)];
    titleLabel2.font = [UIFont systemFontOfSize:13.0f];
    titleLabel2.textAlignment = NSTextAlignmentLeft;
    titleLabel2.text = @"内容:";
    titleLabel2.textColor = [UIColor darkGrayColor];
    [self.view addSubview:titleLabel2];
    
    _contentView  = [[UITextView alloc]  initWithFrame:CGRectMake(10, 155, self.view.frame.size.width-20, 80)];
    _contentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _contentView.layer.cornerRadius = 5.0f;
    _contentView.layer.borderWidth = 0.5f;
    _contentView .delegate = self;
    [self.view addSubview:_contentView];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(self.view.frame.size.width*0.5-70, 250,140, 40);
    reportBtn.backgroundColor = BrownColor;
    [reportBtn setTitle:@"提交" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    reportBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [reportBtn.layer setMasksToBounds:YES];
    [reportBtn.layer setCornerRadius:3.0];
    [reportBtn addTarget:self action:@selector(SendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:reportBtn];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"发送站内信";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}


- (void)SendBtnClick
{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //发送站内信  80
    [parameters setObject:@"80" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowName] forKey:@"receiverName"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    [parameters setObject:_titleField.text forKey:@"title"];
    [parameters setObject:_contentView.text forKey:@"content"];
    
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
    
    DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
     
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        
        DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
    }else {
        if ([textView.text length] < 150) {//判断字符个数
            return YES;
        }
    }
    return NO;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];

    return YES;

}

#pragma mark 点击空白处收回键盘
- (void)controlAction
{
    
    for (UITextField *textField in [self.view subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
    
    for (UITextView *textView in [self.view subviews])
    {
        if ([textView isKindOfClass: [UITextView class]]) {
            
            [textView  resignFirstResponder];
        }
    }
}

@end
