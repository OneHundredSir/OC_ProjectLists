//
//  FundRecordViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》资金记录

#import "FundRecordViewController.h"

#import "ColorTools.h"
#import "AJComboBox.h"
#import "UIFolderTableView.h"
#import "FundRecordTableViewCell.h"

#import "FundRecord.h"

#import "NSString+Date.h"

//1收入2支出3冻结4解冻
#define FundRecord_State_Income 1
#define FundRecord_State_Spending 2
#define FundRecord_State_Freeze 3
#define FundRecord_State_Thaw 4

@interface FundRecordViewController ()<AJComboBoxDelegate,UIFolderTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, HTTPClientDelegate>
{
    NSArray *_dataArr;
    
    NSMutableArray *_dataArrays;
    
    NSInteger _total;
    
    NSInteger _currPage;
    
    NSInteger _searchType;// 0不查询 1充值 2提现 3服务费 4账单还款 5账单收入 6其他
    NSString *startTime;    // 开始时间
    NSString *endTime;      // 结束时间
    
    int currValue;
    int isTime;     // 记录是否更改时间选择器
}

@property (nonatomic,strong) UIFolderTableView *listView;
@property (nonatomic,strong) AJComboBox *ComboBox;
@property (nonatomic,strong) UITextField *textfield;
@property (nonatomic,strong) NetWorkClient *requestClient;

@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *timeView;  // 时间选择器背景View
@property (nonatomic, strong)UITextField *startTimeText;    // 开始时间
@property (nonatomic, strong)UITextField *endTimeText;    // 结束时间

@end

@implementation FundRecordViewController

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
    _dataArrays = [[NSMutableArray alloc] init];
    
    _currPage = 0;
    startTime = @"";
    endTime = @"";
    _searchType = 0;
    _dataArr = @[@"全部", @"充值", @"提现", @"服务费", @"账单还款", @"账单收入", @"其他"];
    // 0不查询 1充值 2提现 3服务费 4账单还款 5账单收入 6其他
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
    _ComboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(5, 8, (MSWIDTH-50)/3, 23)];
    _ComboBox.table.frame= CGRectMake(_ComboBox.frame.origin.x, _ComboBox.frame.origin.y+86, _ComboBox.frame.size.width, [_dataArr count]*30);
    [_ComboBox setLabelText:@"全部"];
    [_ComboBox setDelegate:self];
    [_ComboBox setTag:1];
    [_ComboBox setArrayData:_dataArr];
    [backView insertSubview:_ComboBox aboveSubview:backView];
    
    // 开始时间
    _startTimeText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ComboBox.frame)+5, 8, CGRectGetWidth(_ComboBox.frame), 23)];
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
    
    UILabel *henlabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_startTimeText.frame)+5, 15, 25, 5)];
    henlabel.text = @"---";
    [backView insertSubview:henlabel aboveSubview:backView];
    
    // 结束时间
    _endTimeText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(henlabel.frame)+5, 8, CGRectGetWidth(_startTimeText.frame), 23)];
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

    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [_listView headerBeginRefreshing];
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
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    
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
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"资金记录";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}
#pragma mark 单选框代理方法
-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    _ComboBox.labelText = _dataArr[selectedIndex];
    _searchType = selectedIndex;
    
    [_dataArrays removeAllObjects];// 清空全部数据
    [self requestData];
}


#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _dataArrays.count;
    
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
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.section];
    FundRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[FundRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FundRecord *bean = _dataArrays[indexPath.section];
   
    switch (bean.type) {
        case FundRecord_State_Income:
            cell.moneyLabel.text = [NSString stringWithFormat:@"+￥ %.2f", bean.amount];
            break;
        case FundRecord_State_Spending:
            cell.moneyLabel.text = [NSString stringWithFormat:@"-￥ %.2f", bean.amount];
            break;
        case FundRecord_State_Freeze:
            cell.moneyLabel.text = [NSString stringWithFormat:@"￥ %.2f", bean.amount];
            break;
        case FundRecord_State_Thaw:
            cell.moneyLabel.text = [NSString stringWithFormat:@"￥ %.2f", bean.amount];
            break;
        default:
            break;
    }
    
    cell.wayLabel.text = bean.name;
    
    cell.timeLabel.text = bean.time;
    
    [cell.moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
    [cell.moreBtn  setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateSelected];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self moreBtnClick:indexPath];
}

#pragma 更多按钮触发方法
- (void)moreBtnClick:(NSIndexPath *)indexPath
{
    FundRecord *bean = _dataArrays[indexPath.section];
    
    int margin_TB = 12;
    int margin_LF = 12;
    int spacing = 12;
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 7*20 + 6*spacing + 2*margin_TB)];
    dropView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [ColorTools colorWithHexString:@"#ececec"];
    [dropView addSubview:line];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin_LF, margin_TB, dropView.frame.size.width, 20)];
    moneyLabel.text = [NSString stringWithFormat:@"交易金额：￥%.2f", bean.amount];
    moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel];
    
    
    UILabel *moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(margin_LF, CGRectGetMaxY(moneyLabel.frame) + spacing, dropView.frame.size.width, 20)];
    switch (bean.type) {
        case FundRecord_State_Income:
            moneyLabel2.text = @"交易类型：收入";
            break;
        case FundRecord_State_Spending:
            moneyLabel2.text = @"交易类型：支出";
            break;
        case FundRecord_State_Freeze:
            moneyLabel2.text = @"交易类型：冻结";
            break;
        case FundRecord_State_Thaw:
            moneyLabel2.text = @"交易类型：解冻";
            break;
        default:
            break;
    }
    moneyLabel2.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel2.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel2];
    
    UILabel *moneyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(margin_LF, CGRectGetMaxY(moneyLabel2.frame) + spacing, dropView.frame.size.width, 20)];
    moneyLabel3.text = [NSString stringWithFormat:@"账户总额：￥%.2f", bean.userBalance];
    moneyLabel3.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel3.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel3];
    
    UILabel *moneyLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(margin_LF, CGRectGetMaxY(moneyLabel3.frame) + spacing, dropView.frame.size.width, 20)];
    moneyLabel4.text = [NSString stringWithFormat:@"可用总额：￥%.2f", bean.balance];
    moneyLabel4.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel4.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel4];
    
    UILabel *moneyLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(margin_LF, CGRectGetMaxY(moneyLabel4.frame) + spacing, dropView.frame.size.width, 20)];
    moneyLabel5.text = [NSString stringWithFormat:@"冻结金额：￥%.2f", bean.freeze];
    moneyLabel5.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel5.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel5];
    
    UILabel *moneyLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(margin_LF, CGRectGetMaxY(moneyLabel5.frame) + spacing, dropView.frame.size.width, 20)];
    moneyLabel6.text = [NSString stringWithFormat:@"待收金额：￥%.2f", bean.recieveAmount];
    moneyLabel6.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel6.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel6];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin_LF, CGRectGetMaxY(moneyLabel6.frame) + spacing, dropView.frame.size.width, 20)];
    stateLabel.text = [NSString stringWithFormat:@"操作时间：%@", bean.time];
    stateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    stateLabel.textColor = [UIColor grayColor];
    [dropView addSubview:stateLabel];
    
    _listView.scrollEnabled = NO;
    [_listView openFolderAtIndexPath:indexPath WithContentView:dropView
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
                           }];
    
}

#pragma mark - UITextField 代理
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
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
            dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
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
        
        [_dataArrays removeAllObjects];// 清空全部数据
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
   
      [self dismissViewControllerAnimated:YES completion:^(){}];
}


#pragma mark 开始进入刷新状态
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

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"97" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];// 必填
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_searchType] forKey:@"purpose"];
    [parameters setObject:startTime forKey:@"startTime"];
    [parameters setObject:endTime forKey:@"lastTime"];
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
    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
        if (_total == 1) {
            [_dataArrays removeAllObjects];// 清空全部数据
        }
        
        NSDictionary *roots = [dics objectForKey:@"page"];
        
        if (![[dics objectForKey:@"page"] isEqual:[NSNull null]]) {
            NSArray *results = [roots objectForKey:@"page"];
            
            _total = [[roots objectForKey:@"totalCount"] intValue];
            
            for (NSDictionary *item in results) {
                FundRecord *bean = [[FundRecord alloc] init];
                bean.amount = [[item objectForKey:@"amount"] floatValue];
                if (![[item objectForKey:@"time"] isEqual:[NSNull null]]) {
                    bean.time = [NSString converDate:[[item objectForKey:@"time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd"];
                }
                bean.name = [item objectForKey:@"name"];
                bean.type = [[item objectForKey:@"type"] intValue];
                bean.balance = [[item objectForKey:@"balance"] floatValue];
                bean.userBalance = [[item objectForKey:@"user_balance"] floatValue];
                bean.freeze = [[item objectForKey:@"freeze"] floatValue];
                bean.recieveAmount = [[item objectForKey:@"recieve_amount"] floatValue];
                
                [_dataArrays addObject:bean];
            }
        }
    
        [_listView reloadData];
        
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


#pragma Hidden View

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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
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
