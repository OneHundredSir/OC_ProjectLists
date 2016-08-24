
//
//  WithdrawRecordsViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-20.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  提现 -> 提现记录

#import "WithdrawRecordsViewController.h"

#import "ColorTools.h"
#import "AJComboBox.h"
#import "UIFolderTableView.h"
#import "WithdrawRecordsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WithdrawRecords.h"
#import "NSString+Date.h"

@interface WithdrawRecordsViewController ()<AJComboBoxDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSArray *dataArr;
    
    NSMutableArray *_collectionArrays;
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
    
    int _keyType;
    NSString *startTime;
    NSString *endTime;
    
    int currValue;
    int isTime;             // 记录是否更改时间选择器
}
@property (nonatomic,strong) UIFolderTableView *listView;
@property (nonatomic,strong)AJComboBox *ComboBox;

@property (nonatomic,strong)UILabel *bankName;      // 提现银行
@property (nonatomic,strong)UILabel *cardNum;       // 提现账号
@property (nonatomic,strong)UILabel *auditTime;     // 申请时间
@property (nonatomic,strong)UILabel *payTime;       // 付款时间

@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *timeView;  // 时间选择器背景View
@property (nonatomic,strong)UITextField *startTimeText;    // 开始时间
@property (nonatomic,strong)UITextField *endTimeText;    // 结束时间

@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation WithdrawRecordsViewController

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
    _collectionArrays =[[NSMutableArray alloc] init];
    dataArr = @[@"全部",@"已成功",@"审核中",@"付款中",@"未通过"];
    
    _currPage = 0;
    _keyType = 0;
    startTime = endTime = @"";
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    //
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backView];
    
    
    //选择框
    _ComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(5, 10, 90, 20)];
    [_ComboBox setLabelText:@"全部"];
    [_ComboBox setDelegate:self];
    [_ComboBox setTag:1];
    [_ComboBox setArrayData:dataArr];
     _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+84, _ComboBox.frame.size.width, [dataArr count]*30);
    [backView insertSubview:_ComboBox aboveSubview:backView];
    //输入框
    
    // 开始时间
    _startTimeText = [[UITextField alloc] initWithFrame:CGRectMake(105, 8, 90, 23)];
    _startTimeText.borderStyle = UITextBorderStyleNone;
    _startTimeText.layer.borderWidth = 0.5f;
    _startTimeText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _startTimeText.layer.cornerRadius = 3.0f;
    _startTimeText.layer.masksToBounds = YES;
    _startTimeText.delegate = self;
    _startTimeText.font = [UIFont systemFontOfSize:12.0f];
    _startTimeText.backgroundColor = [UIColor whiteColor];
    _startTimeText.tag = 1000;
    _startTimeText.textAlignment = NSTextAlignmentCenter;
    [backView insertSubview:_startTimeText aboveSubview:backView];
    
    // 结束时间
    _endTimeText = [[UITextField alloc] initWithFrame:CGRectMake(225, 8, 90, 23)];
    _endTimeText.borderStyle = UITextBorderStyleNone;
    _endTimeText.layer.borderWidth = 0.5f;
    _endTimeText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _endTimeText.layer.cornerRadius = 3.0f;
    _endTimeText.layer.masksToBounds = YES;
    _endTimeText.delegate = self;
    _endTimeText.font = [UIFont systemFontOfSize:12.0f];
    _endTimeText.backgroundColor = [UIColor whiteColor];
    _endTimeText.tag = 1001;
    _endTimeText.textAlignment = NSTextAlignmentCenter;
    [backView insertSubview:_endTimeText aboveSubview:backView];
    
    UILabel *henlabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 50, 5)];
    henlabel.text = @"---";
    [backView insertSubview:henlabel aboveSubview:backView];
    
    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];
    [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    _backView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [self.view addSubview:_backView];
    
    // 时间选择器背景View
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, MSWIDTH, 260)];
    _timeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_timeView];
    
    //时间选择器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *currentTime  = [NSDate date];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 260)];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    // 设置当前显示
    [_datePicker setDate:currentTime animated:YES];
    // 设置显示最大时间（
    //[datePicker setMaximumDate:currentTime];
    // 显示模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    _datePicker.locale = locale;
    // 回调的方法由于UIDatePicker 是UIControl的子类 ,可以在UIControl类的通知结构中挂接一个委托
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [_timeView addSubview:_datePicker];
    
    // 时间选择器 -> 确定按钮
    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yesBtn.frame = CGRectMake(20 , 5, 80, 30);
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    yesBtn.backgroundColor = GreenColor;
    [yesBtn.layer setMasksToBounds:YES];
    yesBtn.tag = 1;
    [yesBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [yesBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:yesBtn];
    
    // 时间选择器 -> 确定按钮
    UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noBtn.frame = CGRectMake(self.view.frame.size.width - 100 , 5, 80, 30);
    noBtn.backgroundColor = GreenColor;
    [noBtn.layer setMasksToBounds:YES];
    [noBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    noBtn.tag = 2;
    [noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [noBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:noBtn];
    
    for (UIView *view in self.view.subviews) {
        CGRect frame = view.frame;
        frame.origin.y -= 64.f;
        view.frame = frame;
    }
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"提现记录";
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

#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    if (comboBox.tag == 1) {
        switch (selectedIndex) {
            case 0:
                DLOG(@"选中第一个选项");
                break;
            case 1:
                DLOG(@"选中第二个选项");
                break;
            default:
                break;
        }
    }
    
    _keyType = (int)selectedIndex;
    
    [_collectionArrays removeAllObjects];// 清空全部数据
    [self requestData];
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _collectionArrays.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 2.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"WithdrawRecordsCell";
    WithdrawRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[WithdrawRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WithdrawRecords *withdrawMode = _collectionArrays[indexPath.section];
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥ %@", withdrawMode.withdrawMoney];
    // 0 审核中 1 付款中 2 已成功 -1 未通过
    switch (withdrawMode.withdrawStatus) {
        case -1:
            cell.stateLabel.text = @"未通过";
            break;
        case 0:
            cell.stateLabel.text = @"审核中";
            break;
        case 1:
            cell.stateLabel.text = @"付款中";
            break;
        case 2:
            cell.stateLabel.text = @"已成功";
            break;
            
        default:
            break;
    }
    cell.timeLabel.text = withdrawMode.withdrawTime;
    
  
//    [cell.moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
//    [cell.moreBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateHighlighted];
    [cell.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreBtn.tag = indexPath.section;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WithdrawRecordsCell *cell1 = (WithdrawRecordsCell *)[_listView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)cell1.moreBtn;
    [self moreBtnClick:btn];
    
//    if (btn.selected) {
//        btn.selected = 0;
//    }
//    
//    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
//
//    WithdrawRecords *WithdrawMode = _collectionArrays[btn.tag];
//    
//    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
//    dropView.backgroundColor = [UIColor whiteColor];
//    _bankName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, dropView.frame.size.width, 20)];
//    _bankName.text = [NSString stringWithFormat:@"提现银行: %@", WithdrawMode.bankName];
//    _bankName.font = [UIFont boldSystemFontOfSize:12.0f];
//    _bankName.textColor = [UIColor grayColor];
//    [dropView addSubview:_bankName];
//    
//    _cardNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, dropView.frame.size.width, 20)];
//    _cardNum.text = [NSString stringWithFormat:@"提现账号: %@", WithdrawMode.cardNum];
//    _cardNum.font = [UIFont boldSystemFontOfSize:12.0f];
//    _cardNum.textColor = [UIColor grayColor];
//    [dropView addSubview:_cardNum];
//    
//    _auditTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 37, dropView.frame.size.width, 20)];
//    _auditTime.text = [NSString stringWithFormat:@"申请时间: %@", WithdrawMode.auditTime];
//    _auditTime.font = [UIFont boldSystemFontOfSize:12.0f];
//    _auditTime.textColor = [UIColor grayColor];
//    [dropView addSubview:_auditTime];
//    
//    _payTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, dropView.frame.size.width, 20)];
//    _payTime.text = [NSString stringWithFormat:@"付款时间: %@", WithdrawMode.payTime];
//    _payTime.font = [UIFont boldSystemFontOfSize:12.0f];
//    _payTime.textColor = [UIColor grayColor];
//    [dropView addSubview:_payTime];
//    
//    _listView.scrollEnabled = NO;
//     [btn setTransform:CGAffineTransformMakeRotation(M_PI)];
//    [folderTableView openFolderAtIndexPath:indexPath WithContentView:dropView
//                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
//                                     // opening actions
//                                    
//                                     
//                                 }
//                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
//                                    // closing actions
//                                    //[self CloseAndOpenACtion:indexPath];
//                                    //[cell changeArrowWithUp:NO];
//                                }
//                           completionBlock:^{
//                               // completed actions
//                               _listView.scrollEnabled = YES;
//                                 [btn setTransform:CGAffineTransformMakeRotation(M_PI*2)];
//                           }];



}
#pragma 更多按钮触发方法
- (void)moreBtnClick:(UIButton *)btn
{
    UITableViewCell *cell;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {
        
        cell = (UITableViewCell *)[btn superview];
    }else {
        cell = (UITableViewCell *)[[btn superview]  superview];
    }
    
    NSIndexPath *index1 = [_listView indexPathForCell:cell];
    DLOG(@"index1.setion is %ld",(long)index1.section);
    UIFolderTableView *folderTableView = (UIFolderTableView *)_listView;
    
    WithdrawRecords *WithdrawMode = _collectionArrays[btn.tag];
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    dropView.backgroundColor = [UIColor whiteColor];
    _bankName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, dropView.frame.size.width, 20)];
    _bankName.text = [NSString stringWithFormat:@"提现银行: %@", WithdrawMode.bankName];
    _bankName.font = [UIFont boldSystemFontOfSize:12.0f];
    _bankName.textColor = [UIColor grayColor];
    [dropView addSubview:_bankName];
    
    _cardNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, dropView.frame.size.width, 20)];
    _cardNum.text = [NSString stringWithFormat:@"提现账号: %@", WithdrawMode.cardNum];
    _cardNum.font = [UIFont boldSystemFontOfSize:12.0f];
    _cardNum.textColor = [UIColor grayColor];
    [dropView addSubview:_cardNum];
    
    _auditTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 37, dropView.frame.size.width, 20)];
    _auditTime.text = [NSString stringWithFormat:@"申请时间: %@", WithdrawMode.auditTime];
    _auditTime.font = [UIFont boldSystemFontOfSize:12.0f];
    _auditTime.textColor = [UIColor grayColor];
    [dropView addSubview:_auditTime];
    
    _payTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, dropView.frame.size.width, 20)];
    _payTime.text = [NSString stringWithFormat:@"付款时间: %@", WithdrawMode.payTime];
    _payTime.font = [UIFont boldSystemFontOfSize:12.0f];
    _payTime.textColor = [UIColor grayColor];
    [dropView addSubview:_payTime];
    
    _listView.scrollEnabled = NO;
    [btn setTransform:CGAffineTransformMakeRotation(M_PI)];
    [folderTableView openFolderAtIndexPath:index1 WithContentView:dropView
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                     //[self CloseAndOpenACtion:indexPath];
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                    //[self CloseAndOpenACtion:indexPath];
                                    //[cell changeArrowWithUp:NO];
                                }
                           completionBlock:^{
                               // completed actions
                               _listView.scrollEnabled = YES;
                               [btn setTransform:CGAffineTransformMakeRotation(M_PI*2)];
                           }];
    
}


#pragma mark - UITextField 代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    // 根据tag识别文本(1000 开始时间输入框   1001 结束时间输入款)
    if (textField.tag == 1000) {
        currValue = 0;
        
    }else {
        currValue = 1;
        
    }
    
    [self ViewAnimation:_timeView willHidden:NO];
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 1) {
        
        if (isTime == 1) {
            if (currValue == 0) {
                _startTimeText.text = startTime;
            }else {
                _endTimeText.text = endTime;
            }
        }else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *nowDate = [NSDate date];
            NSString *nowString = [dateFormatter stringFromDate:nowDate];
            
            DLOG(@"nowString -> %@", nowString);
            
            if (currValue == 0) {//选择的时间与当前系统时间做比较
                
                startTime = nowString;
                _startTimeText.text = startTime;
                
            }else {
                
                endTime = nowString;
                _endTimeText.text = endTime;
            }
        }
        
        [_collectionArrays removeAllObjects];// 清空全部数据
        [self requestData];
    }
    
    [self ViewAnimation:_timeView willHidden:YES];
}

// 弹出时间选择器动画效果
- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            _backView.alpha = 0;
            _listView.scrollEnabled = YES;
            view.frame = CGRectMake(0, self.view.frame.size.height, MSWIDTH, 260);
        } else {
            _backView.alpha = .5;
            _listView.scrollEnabled = NO;
            [view setHidden:hidden];
            view.frame = CGRectMake(0, self.view.frame.size.height - 220, MSWIDTH, 260);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)requestData {
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"146" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _keyType] forKey:@"type"];
        [parameters setObject:startTime forKey:@"beginTime"];
        [parameters setObject:endTime forKey:@"endTime"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}
// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self hiddenRefreshView];
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"成功 -> %@", [obj objectForKey:@"msg"]);
        
        // 清空全部数据
        if (_total == 1) {
            [_collectionArrays removeAllObjects];
        }
        
        _total = [[obj objectForKey:@"totalNum"] integerValue];
        NSArray *collections = [[obj objectForKey:@"records"] objectForKey:@"page"];
        for (NSDictionary *item in collections) {
            DLOG(@"sdfadfadf -- %@", [item objectForKey:@"account"]);
            
            WithdrawRecords *withdrawMode = [[WithdrawRecords alloc] init];
            
            withdrawMode.withdrawMoney = [item objectForKey:@"amount"];
            withdrawMode.withdrawStatus = [[item objectForKey:@"status"] intValue];
            
            if ([item objectForKey:@"time"] != nil && ![[item objectForKey:@"time"] isEqual:[NSNull null]]) {
                withdrawMode.withdrawTime =[NSString converDate:[[item objectForKey:@"time"] objectForKey:@"time"] withFormat:@"MM-dd"];
            }else {
                withdrawMode.withdrawTime = @"";
            }
            
            if ([item objectForKey:@"pay_time"] != nil && ![[item objectForKey:@"pay_time"] isEqual:[NSNull null]]) {
                withdrawMode.payTime =[NSString converDate:[[item objectForKey:@"pay_time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd hh:mm:ss"];
            }else {
                withdrawMode.payTime = @"";
            }
            
            if ([item objectForKey:@"time"] != nil && ![[item objectForKey:@"time"] isEqual:[NSNull null]]) {
                withdrawMode.auditTime =[NSString converDate:[[item objectForKey:@"time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd hh:mm:ss"];
            }else {
                withdrawMode.auditTime = @"";
            }
            
            withdrawMode.bankName = [item objectForKey:@"bank_name"];
            withdrawMode.cardNum = [item objectForKey:@"account"];
            
            [_collectionArrays addObject:withdrawMode];
        }
        
        // 刷新表格
        [_listView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"失败 -> %@", [obj objectForKey:@"msg"]]];
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

#pragma mark - 开始进入刷新状态
- (void)headerRereshing
{
    _currPage = 1;
    _total = 1;
    
    [self requestData];
}


- (void)footerRereshing
{
    _currPage++;
    
    [self requestData];
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_listView.isHeaderHidden) {
        [_listView headerEndRefreshing];
    }
    
    if (!_listView.isFooterHidden) {
        [_listView footerEndRefreshing];
    }
}

// 取出时间选择器的时间
-(void)datePickerValueChanged:(id)sender
{
    isTime = 1;
    DLOG(@"isTime -> %d", isTime);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *selectDate = [_datePicker date];
    NSString *selectString = [dateFormatter stringFromDate:selectDate];
    
    if (currValue == 0) {//选择的时间与当前系统时间做比较
        
        startTime = selectString;
        
    }else {
        
        endTime = selectString;
    }
    
}



@end
