//
//  WithdrawalViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心 --》资金 ---》提现
#import "WithdrawalViewController.h"

#import "ColorTools.h"
#import "AJComboBox.h"

#import "WithdrawRecordsViewController.h"
#import "BankCard.h"
#import "SetNewDealPassWordViewController.h"
#import "MSKeyboardScrollView.h"
#import "AccuontSafeViewController.h"
#define fontsize 14.0f
@interface WithdrawalViewController ()<UITextFieldDelegate, AJComboBoxDelegate, UIScrollViewDelegate, UITextViewDelegate, HTTPClientDelegate>
{
    NSArray *titleArr;
    NSMutableArray *cardArr;
    NSMutableArray *cardNameArr;
    
    int isOPT;
    int curr;   // 记录当前银行卡状态
    BOOL payPasswordStatus;  // 交易密码状态
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

@property (nonatomic,strong)UILabel *userBank;     // 开户银行
@property (nonatomic,strong)UILabel *userAccount;  // 账号
@property (nonatomic,strong)UILabel *userName;     // 收款人
@property (nonatomic, strong)UIButton *dealBtn;     // 交易密码按钮

@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation WithdrawalViewController

//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    if (AppDelegateInstance.userInfo == nil) {
//          [ReLogin outTheTimeRelogin:self];
//        return;
//    }else {
//        
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    // 初始化视图
    [self initView];
    
    // 初始化数据
    [self initData];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
  
    
    DLOG(@"isTeleStatus -> %d", AppDelegateInstance.userInfo.isTeleStatus);
    
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

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    titleArr = @[@"账户总额:",@"其中可提现余额为:",@"提现金额"/*,@"选择提现银行卡",@"银行卡信息",@"交易密码"*/];
    cardArr = [[NSMutableArray alloc] init];
    
    //滚动视图
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
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
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    
    //文本
    for (int i=0; i<titleArr.count; i++) {
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.font = [UIFont boldSystemFontOfSize:fontsize];
        titlelabel.text = [titleArr objectAtIndex:i];
        
    
         if (i==0||i==1)
        {
           titlelabel.frame = CGRectMake(10, 5+i*25, 130, 30);
            
        }
         else if(i==2)
         {
           titlelabel.frame = CGRectMake(10, 75, 180, 30);
         
         }
//         else if(i==3)
//         {
//             titlelabel.frame = CGRectMake(20, 160, 180, 30);
//             
//         }
//         else if(i==4)
//         {
//             titlelabel.frame = CGRectMake(20, 225, 180, 30);
//             
//         }
//         else if(i==5)
//         {
//             titlelabel.frame = CGRectMake(20, 315, 180, 30);
//             
//         }
        
        [_scrollView addSubview:titlelabel];
        
    }
    
    //总额文本
    _rentallabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 120, 30)];
    _rentallabel.font = [UIFont systemFontOfSize:fontsize];
    _rentallabel.text = @"";
    _rentallabel.textColor = [UIColor redColor];
    [_scrollView addSubview:_rentallabel];

    //余额文本
     _balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 120, 30)];
    _balancelabel.font = [UIFont systemFontOfSize:fontsize];
    _balancelabel.text = @"";
    _balancelabel.textColor = [UIColor redColor];
   [_scrollView addSubview:_balancelabel];

    _yuanlabel1 = [[UILabel alloc] init];
    _yuanlabel1.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel1.text = @"元";
    [_scrollView addSubview:_yuanlabel1];

    _yuanlabel2 = [[UILabel alloc] init];
    _yuanlabel2.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel2.text = @"元";
    [_scrollView addSubview:_yuanlabel2];


    _Withdrawfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 105, MSWIDTH-40, 30)];
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
    
    
    _highLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, 280, 25)];
    _highLabel.font = [UIFont systemFontOfSize:13.0f];
    _highLabel.textColor = [UIColor darkGrayColor];
    [_scrollView addSubview:_highLabel];
    
//    _ComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(20, 190, MSWIDTH-40, 30)];
//    [_ComboBox setLabelText:@"  --  请选择"];
//    [_ComboBox setDelegate:self];
//    [_ComboBox setTag:1];
//    [_scrollView addSubview:_ComboBox];
    
//    _cardInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 250, MSWIDTH-40, 60)];
//    _cardInfoTextView.backgroundColor = [UIColor whiteColor];
//    _cardInfoTextView.textAlignment = NSTextAlignmentCenter;
//    _cardInfoTextView.layer.borderWidth =0.6f;
//    _cardInfoTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    _cardInfoTextView.layer.cornerRadius = 3.0f;
//    _cardInfoTextView.layer.masksToBounds = YES;
//    _cardInfoTextView.userInteractionEnabled = NO;
//    _cardInfoTextView.delegate = self;
//    [_scrollView addSubview:_cardInfoTextView];

//    _passwordield = [[UITextField alloc] initWithFrame:CGRectMake(20, 345, MSWIDTH-40, 30)];
//    _passwordield.borderStyle = UITextBorderStyleNone;
//    _passwordield.backgroundColor = [UIColor whiteColor];
//    _passwordield.placeholder = @"请输入交易密码";
//    _passwordield.layer.cornerRadius = 3.0f;
//    _passwordield.layer.borderWidth = 0.5f;
//    _passwordield.layer.masksToBounds = YES;
//    _passwordield.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    _passwordield.font = [UIFont systemFontOfSize:14.0f];
//    _passwordield.secureTextEntry = YES;
//    [_passwordield setTag:1];
//    _passwordield.delegate = self;
//    [_scrollView addSubview:_passwordield];
    
//    // 为设置交易密码 显示
//    _dealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _dealBtn.frame = CGRectMake(20, 345, MSWIDTH-40, 30);
//    [_dealBtn setTitle:@"请设置交易密码" forState:UIControlStateNormal];
//    [_dealBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_dealBtn addTarget:self action:@selector(dealClick) forControlEvents:UIControlEventTouchUpInside];
//    _dealBtn.layer.cornerRadius = 3.0f;
//    _dealBtn.backgroundColor = [UIColor whiteColor];
//    _dealBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
//    _dealBtn.alpha = 0;
//    [_scrollView addSubview:_dealBtn];
    
    // 选择提现银行卡，显示有关银行卡信息
    // 开户银行
//    _userBank = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _scrollView.frame.size.width - 10, 20)];
//    _userBank.font = [UIFont systemFontOfSize:12.0f];
//    _userBank.textColor = [UIColor blackColor];
//    [_cardInfoTextView addSubview:_userBank];
    
    // 账号
//    _userAccount = [[UILabel alloc] initWithFrame:CGRectMake(5, 16, _scrollView.frame.size.width - 10, 20)];
//    _userAccount.font = [UIFont systemFontOfSize:12.0f];
//    _userAccount.textColor = [UIColor blackColor];
//    [_cardInfoTextView addSubview:_userAccount];
    
//    // 收款人
//    _userName = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, _scrollView.frame.size.width - 10, 20)];
//    _userName.font = [UIFont systemFontOfSize:12.0f];
//    _userName.textColor = [UIColor blackColor];
//    [_cardInfoTextView addSubview:_userName];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sureBtn.frame = CGRectMake(10, 190, MSWIDTH-20, 50);
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _sureBtn.layer.cornerRadius = 3.0f;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.backgroundColor = GreenColor;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(SureClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sureBtn];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"提现";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
//    
//    // 导航条右边按钮
//    UIBarButtonItem *WithdrawItem=[[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStyleDone target:self action:@selector(WithdrawClick)];
//    WithdrawItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setRightBarButtonItem:WithdrawItem];
}

#pragma 设置交易密码
- (void)dealClick {
    
    if (AppDelegateInstance.userInfo.isMobileStatus) {
        SetNewDealPassWordViewController *setDealPass = [[SetNewDealPassWordViewController alloc] init];
        setDealPass.ispayPasswordStatus = payPasswordStatus;
        setDealPass.statuStr = @"正常设置";
        [self.navigationController pushViewController:setDealPass animated:YES];
    }else {
        
        [SVProgressHUD showErrorWithStatus:@"请先设置交易密码保障安全"];
        AccuontSafeViewController *AccuontSafeView = [[AccuontSafeViewController alloc] init];
        AccuontSafeView.backTypeNum = 1;
        [self.navigationController pushViewController:AccuontSafeView animated:YES];
    }
    
    
}

#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    if (comboBox.tag == 1) {
        DLOG(@"selectedIndex -> %ld", (long)selectedIndex);
        
        BankCard *bankCark = cardArr[selectedIndex];
        curr = (int)bankCark.bankCardId;
//        _userBank.text = [NSString stringWithFormat:@"开户银行: %@", bankCark.bankName];
        NSString *cardStr =  [NSString stringWithFormat:@"%@*****%@",[bankCark.account substringWithRange:NSMakeRange(0, 6)],[bankCark.account substringWithRange:NSMakeRange(bankCark.account.length-4, 4)]];
        
        _userAccount.text = [NSString stringWithFormat:@"账号: %@", cardStr];
//        _userName.text = [NSString stringWithFormat:@"收款人: %@", bankCark.accountName];
    }
}

#pragma mark 确定点击触发方法
- (void)SureClick
{
//    DLOG(@"cardNameArr - %@", @(cardNameArr.count));
//    DLOG(@"确定!!!");
//    DLOG(@"curr -> %d", curr);
//    DLOG(@"curr -> %@", _passwordield.text);
//
//    if (payPasswordStatus) {
//        if (AppDelegateInstance.userInfo == nil) {
//              [ReLogin outTheTimeRelogin:self];
//            return;
//        }
    
        _sureBtn.enabled = NO;
    
        isOPT = 2;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"144" forKey:@"OPT"]; // 提现接口144== ；汇付标准版(充值接口177
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];//-----20160122
        [parameters setObject:_Withdrawfield.text forKey:@"amount"];            // 申请金额
        [parameters setObject:[NSString stringWithFormat:@"%d", curr] forKey:@"bankId"];            // 银行卡id
        [parameters setObject:[NSString encrypt3DES:_passwordield.text key:DESkey] forKey:@"payPassword"];       // 交易密码
        [parameters setObject:@"1" forKey:@"type"];             // 类型（默认为1）
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
  
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
//    }else {
//        [SVProgressHUD showErrorWithStatus:@"请设置交易密码"];
//    }
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
//      [[NSNotificationCenter defaultCenter]  postNotificationName:@"update2" object:nil];
//      [self dismissViewControllerAnimated:YES completion:^(){}];
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


#pragma  mark UIScrollViewdellegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+20-scrollView.contentOffset.y, _ComboBox.frame.size.width, [cardNameArr count]*30);
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
     _sureBtn.enabled = YES;
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"成功 -> %@", [obj objectForKey:@"msg"]);
        
        if (isOPT == 1) {
            
            payPasswordStatus = [[obj objectForKey:@"payPasswordStatus"] boolValue];
            if (!payPasswordStatus) {
                _dealBtn.userInteractionEnabled = YES;
                _dealBtn.alpha = 1;
            }else {
                _dealBtn.userInteractionEnabled = NO;
                _dealBtn.alpha = 0;
            }
            
            _rentallabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"userBalance"] doubleValue]];
            _balancelabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"withdrawalAmount"] doubleValue]];
            _highLabel.text = [NSString stringWithFormat:@"本次最高提现金额为: %.2f 元", [[obj objectForKey:@"withdrawalAmount"] doubleValue]] ;
            
            cardNameArr = [[NSMutableArray alloc] init];
            NSArray *provinceArr = [dics objectForKey:@"bankList"];
            for (NSDictionary *item in provinceArr) {
                BankCard *bankCard = [[BankCard alloc] init];
                bankCard.bankCardId = [[item objectForKey:@"id"] intValue];
                bankCard.accountName = [item objectForKey:@"accountName"];
                bankCard.bankName = [item objectForKey:@"bankName"];
                bankCard.account = [item objectForKey:@"account"];
                
                [cardArr addObject:bankCard];
                DLOG(@"%@", [item objectForKey:@"bankName"]);
                [cardNameArr addObject:[item objectForKey:@"bankName"]];
            }
            
            [_ComboBox setArrayData:cardNameArr];
            _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+90, _ComboBox.frame.size.width, [cardNameArr count]*30);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont boldSystemFontOfSize:fontsize];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            
            CGSize rentallabelSiZe = [_rentallabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            CGSize balancelabelSiZe = [_balancelabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            _yuanlabel1.frame = CGRectMake(_rentallabel.frame.origin.x+rentallabelSiZe.width+5, 5, 30, 30);
            _yuanlabel2.frame = CGRectMake(_balancelabel.frame.origin.x+balancelabelSiZe.width+5, 30, 30, 30);
        }else if (isOPT == 2){
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            _userBank.text = @"";
            _userAccount.text = @"";
            _userName.text = @"";
            _passwordield.text = @"";
            _Withdrawfield.text = @"";
            [_ComboBox setLabelText:@"  --  请选择"];
            
            _rentallabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"userBalance"] floatValue]];
            _balancelabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"withdrawalAmount"] floatValue]];
            _highLabel.text = [NSString stringWithFormat:@"本次最高提现金额为: %.2f 元", [[obj objectForKey:@"withdrawalAmount"] floatValue]];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * 600000000ull)), dispatch_get_main_queue(), ^{
//            
//                [self.navigationController popViewControllerAnimated:NO];
//
//           });
        }
    
    
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
     _sureBtn.enabled = YES;
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
     _sureBtn.enabled = YES;
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
