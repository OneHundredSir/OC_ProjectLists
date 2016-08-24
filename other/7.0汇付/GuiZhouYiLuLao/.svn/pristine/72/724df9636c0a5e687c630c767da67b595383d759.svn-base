//
//  FinanceTransferViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  理财子账户 -> 收款中 -> 债权转让

#import "FinanceTransferViewController.h"
#import "ColorTools.h"
#import "AJComboBox.h"
#import <QuartzCore/QuartzCore.h>
#import "CollectionFinancialDetailsViewController.h"
#import "BorrowingDetailsViewController.h"
@interface FinanceTransferViewController ()<UIScrollViewDelegate,UITextFieldDelegate,AJComboBoxDelegate, HTTPClientDelegate>
{

    NSArray *selectedArr;
    
    int status;  // 转让方式 状态
    int _transferPeriods;  // 转让期限

}
@property (nonatomic,strong) AJComboBox *comboBox;
@property (nonatomic,strong) UILabel *NameLabel;
@property (nonatomic,strong) UITextField *NameTextField;
@property (nonatomic,strong) UILabel *infoLabel;
@property (nonatomic,strong) UITextView *infoTextView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *DateLabel;
@property (nonatomic,strong) AJComboBox *dateBox;
@property (nonatomic,strong) UILabel *reasonLabel;
@property (nonatomic,strong) UIButton *SureBtn;

@property (nonatomic,strong) UITextField *transferTitle;    // 转让标题
@property (nonatomic,strong) UITextField *transferBP;       // 转让底价
@property (nonatomic,strong) UITextView *transferReason;   // 转让理由

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation FinanceTransferViewController

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
    selectedArr = @[@[@"竞价转让",@"定向转让"],
                    @[@"1天",@"2天",@"3天",@"4天",@"5天"]
                    ];
    status = 0;
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 800)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 900);
    [self.view addSubview:_scrollView];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:viewControl];
    
    UILabel *titleTextlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
    titleTextlabel.text = @"转让标题";
    titleTextlabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scrollView addSubview:titleTextlabel];
    
    
    _transferTitle = [[UITextField alloc] init];
    _transferTitle.frame = CGRectMake(85, 10, 180, 28);
    _transferTitle.borderStyle = UITextBorderStyleRoundedRect ;
    _transferTitle.delegate = self;
    [_scrollView addSubview:_transferTitle];
    
    
    UILabel *titleTextlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 120, 30)];
    titleTextlabel2.text = @"代收本金转让底价";
    titleTextlabel2.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scrollView addSubview:titleTextlabel2];
    
    _transferBP = [[UITextField alloc] init];
    _transferBP.frame = CGRectMake(135, 53, 120, 28);
    _transferBP.borderStyle = UITextBorderStyleRoundedRect ;
    _transferBP.delegate = self;
    [_scrollView addSubview:_transferBP];
    
    UILabel *unitTextlabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 55, 120, 30)];
    unitTextlabel.text = @"元";
    unitTextlabel.textColor = [UIColor grayColor];
    unitTextlabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    [_scrollView addSubview:unitTextlabel];
    
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 82, 150, 30)];
    textlabel.text = [NSString stringWithFormat:@"注:代收本金为%@元", _bidAmount];
    textlabel.textColor = [UIColor grayColor];
    textlabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
    [_scrollView addSubview:textlabel];
    
    UILabel *titleTextlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 120, 30)];
    titleTextlabel3.text = @"转让方式";
    titleTextlabel3.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scrollView addSubview:titleTextlabel3];
    
    
    //dfasdfasd
    _comboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(80, 108, 80, 28)];
    [_comboBox setLabelText:@"- 请选择 -"];
    [_comboBox setDelegate:self];
    [_comboBox setTag:0];
    [_comboBox setArrayData:[selectedArr objectAtIndex:0]];
    [_scrollView addSubview:_comboBox];
    
    _DateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 120, 30)];
    _DateLabel.text = @"转让期限";
    _DateLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scrollView addSubview:_DateLabel];
    
    _dateBox = [[AJComboBox alloc] initWithFrame:CGRectMake(80, 143, 80, 28)];
    [_dateBox setLabelText:@"- 请选择 -"];
    [_dateBox setDelegate:self];
    [_dateBox setTag:1];
    [_dateBox setArrayData:[selectedArr objectAtIndex:1]];
    [_scrollView addSubview:_dateBox];
    
    _reasonLabel = [[UILabel alloc] init];
    _reasonLabel.frame = CGRectMake(10, 170, 120, 30);
    _reasonLabel.text = @"转让原因";
    _reasonLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scrollView addSubview:_reasonLabel];
    
    _transferReason  = [[UITextView alloc] init];
    _transferReason.frame = CGRectMake(10, 200, 300, 70);
    _transferReason.layer.borderWidth = 0.3f;
    _transferReason.layer.borderColor = [[UIColor grayColor] CGColor];
    _transferReason.layer.cornerRadius = 4.0f;
    _transferReason.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scrollView addSubview:_transferReason];
    
    
    _SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SureBtn.frame = CGRectMake(self.view.frame.size.width*0.5-50, 285,100, 25);
    _SureBtn.backgroundColor = BrownColor;
    [_SureBtn setTitle:@"确认申请" forState:UIControlStateNormal];
    [_SureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _SureBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [_SureBtn.layer setMasksToBounds:YES];
    [_SureBtn.layer setCornerRadius:3.0];
    [_SureBtn addTarget:self action:@selector(SureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_SureBtn];
    
    
    _NameLabel = [[UILabel alloc] init];
    _NameLabel.frame = CGRectMake(1000, 140, 150, 30);
    _NameLabel.text = @"请输入受让会员用户名";
    _NameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_scrollView addSubview:_NameLabel];
    
    
    _NameTextField = [[UITextField alloc] init];
    _NameTextField.frame = CGRectMake(1000, 143, 100, 30);
    _NameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _NameTextField.delegate = self;
    [_scrollView addSubview:_NameTextField];
    
//    _infoLabel = [[UILabel alloc] init];
//    _infoLabel.frame = CGRectMake(10000, 175, 120, 30);
//    _infoLabel.text = @"受让会员信息";
//    _infoLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
//    [_ScrollView addSubview:_infoLabel];
//    
//    _infoTextView  = [[UITextView alloc] init];
//    _infoTextView.frame = CGRectMake(1000, 205, 300, 70);
//    _infoTextView.layer.borderWidth = 0.3f;
//    _infoTextView.layer.borderColor = [[UIColor grayColor] CGColor];
//    _infoTextView.layer.cornerRadius = 4.0f;
//    _infoTextView.text = @"真实姓名:熊二默";
//    _infoTextView.font = [UIFont systemFontOfSize:14.0f];
//    _infoTextView.textColor = [UIColor grayColor];
//    [_ScrollView addSubview:_infoTextView];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"债权转让";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    UIBarButtonItem *detailItem=[[UIBarButtonItem alloc] initWithTitle:@"借款详情" style:UIBarButtonItemStyleDone target:self action:@selector(DetailClick)];
    detailItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:detailItem];
    
    
}
#pragma mark 确认按钮

- (void)SureBtnClick
{
    DLOG(@"确认按钮");
    _SureBtn.userInteractionEnabled = NO;
    DLOG(@" _transferReason -> %@", _transferReason.text);
    DLOG(@"_transferPeriods -> %d", _transferPeriods);
    
    if ([_transferTitle.text isEqual: @""]) {
        DLOG(@" 标题不能为空！ ");
        [SVProgressHUD showErrorWithStatus:@"输入内容有误"];
        
        return;
    }else {
        
        DLOG(@"_investId -> %d", _investId);
        
        if (status == 0) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:@"43" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%d", _investId] forKey:@"invest_id"];
            [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
            [parameters setObject:_transferTitle.text forKey:@"transferTitle"];
            [parameters setObject:_transferBP.text forKey:@"transferBP"];
            [parameters setObject:[NSString stringWithFormat:@"%d", status] forKey:@"transferWay"];
            [parameters setObject:_transferReason.text forKey:@"transferReason"];
            [parameters setObject:[NSString stringWithFormat:@"%d", _transferPeriods] forKey:@"transferPeriods"];
            
            if (_requestClient == nil) {
                _requestClient = [[NetWorkClient alloc] init];
                _requestClient.delegate = self;
            }
            [_requestClient requestGet:@"app/services" withParameters:parameters];
            
            DLOG(@" _transferReason -> %@", _transferReason.text);
            
        }else {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:@"43" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%d", _investId] forKey:@"invest_id"];
            [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
            [parameters setObject:_transferTitle.text forKey:@"transferTitle"];
            [parameters setObject:_transferBP.text forKey:@"transferBP"];
            [parameters setObject:[NSString stringWithFormat:@"%ld", (long)status] forKey:@"transferWay"];
            [parameters setObject:_transferReason.text forKey:@"transferReason"];
            [parameters setObject:[NSString stringWithFormat:@"%d", _transferPeriods] forKey:@"transferPeriods"];
            [parameters setObject:_NameTextField.text forKey:@"assigneeName"];
//            [parameters setObject:_infoTextView.text forKey:@"assigneeInfo"];
            
            
            if (_requestClient == nil) {
                _requestClient = [[NetWorkClient alloc] init];
                _requestClient.delegate = self;
            }
            [_requestClient requestGet:@"app/services" withParameters:parameters];
        }
    }
}

#pragma mark -
#pragma mark AJComboBoxDelegate

-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    switch (comboBox.tag) {
        case 0:
        {
            switch (selectedIndex) {
                case 0:
                {
                    status = 2;
                    
                    _DateLabel.frame = CGRectMake(10, 140, 120, 30);
                    _dateBox.frame = CGRectMake(80, 143, 80, 28);
                    _reasonLabel.frame = CGRectMake(10, 170, 120, 30);
                    _transferReason.frame = CGRectMake(10, 200, 300, 70);
                    _SureBtn.frame = CGRectMake(self.view.frame.size.width*0.5-50, 285,100, 25);
                    _NameLabel.frame = CGRectMake(1000, 140, 150, 30);
                    _NameTextField.frame = CGRectMake(1000, 143, 100, 30);
                    _infoLabel.frame = CGRectMake(1000, 175, 120, 30);
                    _infoTextView.frame = CGRectMake(10000, 205, 300, 70);
                }
                    break;
                    
                case 1:
                {
                    status = 1;
                    
                    _NameLabel.frame = CGRectMake(10, 140, 150, 30);
                    _NameTextField.frame = CGRectMake(165, 143, 100, 30);
                    _infoLabel.frame = CGRectMake(10, 175, 120, 30);
                    _infoTextView.frame = CGRectMake(10, 205, 300, 70);
                    
                    _DateLabel.frame = CGRectMake(10, 175, 120, 30);
                    _dateBox.frame = CGRectMake(80, 178, 80, 28);
                    _reasonLabel.frame = CGRectMake(10, 205, 120, 30);
                    _transferReason.frame = CGRectMake(10, 235, 300, 70);
                    _SureBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 50, 320,100, 25);
                }
                    break;
            }
        }
            break;
        case 1:
        {
            _transferPeriods = (int)selectedIndex + 1;
            
            DLOG(@"_transferPeriods -> %d", _transferPeriods);
            DLOG(@"selectedIndex -> %ld", (long)selectedIndex);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
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


#pragma 输入框代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma 借款详情按钮触发方法
- (void)DetailClick
{
    BorrowingDetailsViewController *borrowingDetailview = [[BorrowingDetailsViewController alloc] init];
    borrowingDetailview.stateNum = 5;
    borrowingDetailview.borrowID = _borrowID;
    [self.navigationController pushViewController:borrowingDetailview animated:YES];
    
}

#pragma  mark UIScrollViewdellegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _comboBox.table.frame= CGRectMake(_comboBox.frame.origin.x, _comboBox.frame.origin.y+20-scrollView.contentOffset.y, _comboBox.frame.size.width, [[selectedArr objectAtIndex:0] count]*30);
    
    _dateBox.table.frame= CGRectMake(_dateBox.frame.origin.x, _dateBox.frame.origin.y+20-scrollView.contentOffset.y, _dateBox.frame.size.width, [[selectedArr objectAtIndex:1] count]*30);

}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    _SureBtn.userInteractionEnabled = YES;
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinanceSuccess" object:self];
        });
        
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
