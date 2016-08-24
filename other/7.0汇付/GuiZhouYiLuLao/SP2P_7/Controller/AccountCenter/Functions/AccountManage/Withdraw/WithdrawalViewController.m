//
//  WithdrawalViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心 --》账户管理 ---》提现
#import "WithdrawalViewController.h"

#import "ColorTools.h"
#import "AJComboBox.h"

#import "WithdrawRecordsViewController.h"
#import "BankCard.h"
#import "SetNewDealPassWordViewController.h"
#import "MSKeyboardScrollView.h"
#import "AccuontSafeViewController.h"
#import "OpenAccountViewController.h"
#import "MyWebViewController.h"

#define fontsize 14.0f
@interface WithdrawalViewController ()<UITextFieldDelegate, AJComboBoxDelegate, UIScrollViewDelegate, UITextViewDelegate, HTTPClientDelegate,UIAlertViewDelegate>
{
    NSArray *titleArr;
    NSMutableArray *cardArr;
    NSMutableArray *cardNameArr;
    
    int isOPT;
    int curr;   // 记录当前银行卡状态
}
@property (nonatomic,strong)UITextField *Withdrawfield;
@property (nonatomic,strong)UITextField *passwordield;
@property (nonatomic,strong)UILabel *rentallabel;
@property (nonatomic,strong)UILabel *balancelabel;
@property (nonatomic,strong)UILabel *yuanlabel1;
@property (nonatomic,strong)UILabel *yuanlabel2;
@property (nonatomic,strong)UILabel *balancelabel2;
@property (nonatomic,strong)AJComboBox *ComboBox;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UILabel *highLabel;
@property (nonatomic,strong)UITextView *cardInfoTextView;
@property (nonatomic,strong)UIButton *sureBtn;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation WithdrawalViewController

- (void)viewWillAppear:(BOOL)animated
{
    _sureBtn.userInteractionEnabled = YES;
    
    [self initData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化视图
    [self initView];
}

#pragma mark -- 初始化数据
- (void)initData
{
    isOPT = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"145" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}


#pragma mark -- 初始化视图
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    titleArr = @[@"账户总额:",@"其中可提现余额为:",@"提现金额"];
    cardArr = [[NSMutableArray alloc] init];
    
    //滚动视图
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    [self.view addSubview:_scrollView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    backView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView];
    
    //    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    //    [_scrollView addSubview:viewControl];
    
    
    //文本
    for (int i=0; i < titleArr.count; i++) {
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.font = [UIFont boldSystemFontOfSize:fontsize];
        titlelabel.text = [titleArr objectAtIndex:i];
        titlelabel.frame = CGRectMake(10, 5+i*25, 130, 30);
        if(i==2)
        {
            titlelabel.frame = CGRectMake(10, 75, 180, 30);
        }
        
        [_scrollView addSubview:titlelabel];
    }
    
    //总额文本
    _rentallabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 120, 30)];
    _rentallabel.font = [UIFont systemFontOfSize:fontsize];
    _rentallabel.text = @"0.00";
    _rentallabel.textColor = [UIColor redColor];
    [_scrollView addSubview:_rentallabel];
    
    //余额文本
    _balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 120, 30)];
    _balancelabel.font = [UIFont systemFontOfSize:fontsize];
    _balancelabel.text = @"0.00";
    _balancelabel.textColor = [UIColor redColor];
    [_scrollView addSubview:_balancelabel];
    
    _yuanlabel1 = [[UILabel alloc] init];
    _yuanlabel1.frame = CGRectMake(_rentallabel.frame.origin.x+35, 5, 30, 30);
    _yuanlabel1.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel1.text = @"元";
    [_scrollView addSubview:_yuanlabel1];
    
    _yuanlabel2 = [[UILabel alloc] init];
    _yuanlabel2.frame = CGRectMake(_balancelabel.frame.origin.x+35, 30, 30, 30);
    _yuanlabel2.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel2.text = @"元";
    [_scrollView addSubview:_yuanlabel2];
    
    
    _Withdrawfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 105, MSWIDTH-20, 30)];
    _Withdrawfield.borderStyle = UITextBorderStyleNone;
    _Withdrawfield.backgroundColor = [UIColor whiteColor];
    _Withdrawfield.layer.borderWidth = 0.8f;
    _Withdrawfield.layer.cornerRadius =3.0f;
    _Withdrawfield.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _Withdrawfield.layer.masksToBounds = YES;
    _Withdrawfield.placeholder = @"请输入提现金额";
    _Withdrawfield.font = [UIFont systemFontOfSize:15.0f];
    [_Withdrawfield setTag:1];
    _Withdrawfield.delegate = self;
    _Withdrawfield.keyboardType = UIKeyboardTypeDecimalPad;
    [_scrollView addSubview:_Withdrawfield];
    
    
    _highLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 135, MSWIDTH-20, 25)];
    _highLabel.font = [UIFont systemFontOfSize:13.0f];
    _highLabel.textColor = [UIColor darkGrayColor];
    [_scrollView addSubview:_highLabel];
    
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sureBtn.frame = CGRectMake(10, CGRectGetMaxY(_highLabel.frame)+30, MSWIDTH-20, 40);
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17.0];
    _sureBtn.layer.cornerRadius = 3.0f;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.backgroundColor = BrownColor;
    [_sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(SureClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sureBtn];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"提现";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条右边按钮
    UIBarButtonItem *WithdrawItem=[[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStyleDone target:self action:@selector(WithdrawClick)];
    WithdrawItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:WithdrawItem];
}



#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    if (comboBox.tag == 1) {
        DLOG(@"selectedIndex -> %ld", (long)selectedIndex);
        
        BankCard *bankCark = cardArr[selectedIndex];
        curr = (int)bankCark.bankCardId;
        [comboBox setLabelText:bankCark.bankName];
    }
}

#pragma mark 确定点击触发方法
- (void)SureClick
{
    DLOG(@"cardNameArr - %@", @(cardNameArr.count));
    
    
    if (_Withdrawfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额"];
        return;
    }
    if (_Withdrawfield.text.floatValue <= 0) {
        [SVProgressHUD showErrorWithStatus:@"提现金额需大于0"];
        return;
    }
    
    if (_balancelabel.text.floatValue < _Withdrawfield.text.floatValue) {
        [SVProgressHUD showErrorWithStatus:@"可提现余额不足！"];
        return;
    }
    
    _sureBtn.userInteractionEnabled = NO;
    
    isOPT = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"144" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:_Withdrawfield.text forKey:@"amount"];            // 申请金额
    [parameters setObject:@"1" forKey:@"type"];             // 类型（默认为1）
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
    
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    // 收回文本键盘
    for (UITextField *textField in [_scrollView subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
    
    for (UITextView *textView in [_scrollView subviews])
    {
        if ([textView isKindOfClass: [UITextView class]]) {
            
            [textView  resignFirstResponder];
        }
    }
}
#pragma mark 提现记录
- (void)WithdrawClick
{
    WithdrawRecordsViewController *WithdrawRecordsView = [[WithdrawRecordsViewController alloc] init];
    [self.navigationController pushViewController:WithdrawRecordsView animated:YES];
}


#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:NO];
    
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


#pragma mark UIScrollViewdellegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+20-scrollView.contentOffset.y, _ComboBox.frame.size.width, [cardNameArr count]*30);
}

#pragma mark -- HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSLog(@"提现返回 -> %@",obj);
    NSLog(@"msg -> %@", [obj objectForKey:@"msg"]);
    
    NSDictionary *dics = obj;
    
    NSString *error = [NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]];
    NSString *msg = [NSString stringWithFormat:@"%@",[dics objectForKey:@"msg"]];
    
    if (isOPT == 1)
    {
        if ([error isEqualToString:@"-1"])//提现初始化
        {
            _rentallabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"userBalance"] doubleValue]];
            _balancelabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"withdrawalAmount"] doubleValue]];
            _highLabel.text = [NSString stringWithFormat:@"本次最高提现金额为: %.2f 元", [[obj objectForKey:@"withdrawalAmount"] doubleValue]] ;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont boldSystemFontOfSize:fontsize];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            
            CGSize rentallabelSiZe = [_rentallabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            CGSize balancelabelSiZe = [_balancelabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            _yuanlabel1.frame = CGRectMake(_rentallabel.frame.origin.x+rentallabelSiZe.width+5, 5, 30, 30);
            _yuanlabel2.frame = CGRectMake(_balancelabel.frame.origin.x+balancelabelSiZe.width+5, 30, 30, 30);
            
        }
        else if ([error isEqualToString:@"-31"])
        {
            [SVProgressHUD showImage:nil status:msg];
        }
        else if ([error isEqualToString:@"-2"]) {
            
            [ReLogin outTheTimeRelogin:self];
        }
        else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        
    }else if (isOPT == 2)
    {//提现
        
        if ([error isEqualToString:@"-1"]) {
            
            if (![[obj objectForKey:@"htmlParam"]isEqual:[NSNull null]]&& [obj objectForKey:@"htmlParam"] != nil)
            {
                NSString *htmlParam = [NSString stringWithFormat:@"%@",[dics objectForKey:@"htmlParam"]];
                MyWebViewController *web = [[MyWebViewController alloc]init];
                web.html = htmlParam;
                web.type = @"4";
                [self.navigationController pushViewController:web animated:YES];
                
                _Withdrawfield.text = @"";
                
            }else{
                [SVProgressHUD showImage:nil status:msg];
                _sureBtn.userInteractionEnabled = YES;
            }
        }
        else if ([error isEqualToString:@"-31"])//-31 未开户
        {
            _sureBtn.userInteractionEnabled = YES;
            [SVProgressHUD showImage:nil status:msg];
            OpenAccountViewController *openAccount = [[OpenAccountViewController alloc] init];
            [self.navigationController pushViewController:openAccount animated:YES];
            
        }else if ([error isEqualToString:@"-2"]&&
                  [msg rangeOfString:@"登录"].location != NSNotFound) {
            _sureBtn.userInteractionEnabled = YES;
            [ReLogin outTheTimeRelogin:self];
        }
        else {
            _sureBtn.userInteractionEnabled = YES;
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:msg];
        }
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
    
    [_Withdrawfield resignFirstResponder];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}



@end
