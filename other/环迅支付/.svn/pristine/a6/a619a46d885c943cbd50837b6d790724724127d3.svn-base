//
//  WriteMailViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "WriteMailViewController.h"

#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

#define fontsize 18.0f  //字体大小
@interface WriteMailViewController ()<UITextFieldDelegate,UITextViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *titleArr;
    
}
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UITextField *titleField;
@property (nonatomic,strong) UITextView  *contentView;

@end

@implementation WriteMailViewController

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
    titleArr = [NSMutableArray arrayWithObjects:@"发给：",@"标题：", @"内容：",  nil];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    self.view.backgroundColor = KblackgroundColor;
    
    // 添加收回键盘触发事件
    // 监听屏幕，释放键盘
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
    
    for (int i=0; i<3; i++) {
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80+i*70, 60, 30)];
        titlelabel.textAlignment = NSTextAlignmentRight;
        titlelabel.font = [UIFont systemFontOfSize:fontsize];
        titlelabel.text = [titleArr objectAtIndex:i];
        [self.view addSubview:titlelabel];
        
    }
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(15, 110, MSWIDTH-30, 35)];
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _nameField.layer.borderWidth = 0.4f;
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.delegate = self;
    _nameField.text = @"";
    [self.view addSubview:_nameField];
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(15, 180, MSWIDTH-30, 35)];
    _titleField.borderStyle = UITextBorderStyleNone;
    _titleField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _titleField.layer.borderWidth = 0.4f;
    _titleField.backgroundColor = [UIColor whiteColor];
    _titleField.delegate = self;
    _titleField.text = @"";
    [self.view addSubview:_titleField];
    
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, 250, MSWIDTH-30, 100) ];
    _contentView.textColor = [UIColor blackColor];
    _contentView.font = [UIFont systemFontOfSize:16.0f];
    _contentView.delegate = self;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    _contentView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _contentView.scrollEnabled = YES;//是否可以拖动
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    _contentView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _contentView.layer.borderWidth = 0.4f;
    _contentView.text = @"";
    [self.view addSubview:_contentView];
    
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"确  定" forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake((MSWIDTH - 100) * 0.5, CGRectGetMaxY(_contentView.frame)+20, 100, 35);
    [sendBtn.layer setMasksToBounds:YES];
    [sendBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    sendBtn.backgroundColor = GreenColor;
    [sendBtn addTarget:self action:@selector(SendmailClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"发站内信";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tag = 1;
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 发送按钮
- (void)SendmailClick
{
    DLOG(@"Click success");
    [self requestData];
}


#pragma    mark - 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"80" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:_nameField.text forKey:@"receiverName"];
        [parameters setObject:_titleField.text forKey:@"title"];
        [parameters setObject:_contentView.text forKey:@"content"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
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
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        
        [self cleanData];
        
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

- (void)cleanData{
    _nameField.text = @"";
    _titleField.text = @"";
    _contentView.text = @"";
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self cleanData];
    
}



@end
