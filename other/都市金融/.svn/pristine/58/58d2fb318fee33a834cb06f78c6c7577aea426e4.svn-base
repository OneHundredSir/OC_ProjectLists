//
//  FundRecordViewController.m
//  SP2P_7
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
#import "TabViewController.h"

//1收入2支出3冻结4解冻
#define FundRecord_State_Income 1
#define FundRecord_State_Spending 2
#define FundRecord_State_Freeze 3
#define FundRecord_State_Thaw 4

@interface FundRecordViewController ()<AJComboBoxDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, HTTPClientDelegate>
{
//    NSArray *_dataArr;
    NSMutableArray *_dataArrays;
    NSMutableArray *_listArr;
    NSMutableDictionary *_listDic;
    
    NSInteger _total;
    
    NSInteger _currPage;
    
    NSInteger _searchType;// 0不查询 1充值 2提现 3服务费 4账单还款 5账单收入 6其他
    NSString *startTime;    // 开始时间
    NSString *endTime;      // 结束时间
    
    int currValue;
    int isTime;     // 记录是否更改时间选择器
}

@property (nonatomic,strong) UITableView *listView;
@property (nonatomic,strong)AJComboBox *ComboBox;
@property (nonatomic,strong)UITextField *textfield;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *timeView;  // 时间选择器背景View
@property (nonatomic,strong)UITextField *startTimeText;    // 开始时间
@property (nonatomic,strong)UITextField *endTimeText;    // 结束时间

@end

@implementation FundRecordViewController

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
    _listArr = [[NSMutableArray alloc] init];
    _listDic = [[NSMutableDictionary alloc] init];
    
    _currPage = 0;
    startTime = @"";
    endTime = @"";
    _searchType = 0;
//    _dataArr = @[@"全部", @"充值", @"提现", @"服务费", @"账单还款", @"账单收入", @"其他"];
    // 0不查询 1充值 2提现 3服务费 4账单还款 5账单收入 6其他
}

/**
 初始化数据
 */
- (void)initView
{
    
//    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];
    if ([self.purposeStr isEqualToString:@"6"]) {// 收入
        if (AppDelegateInstance.userInfo != nil) {
            
            [self headerRereshing];
        }else{
            [ReLogin outTheTimeRelogin:self];
        }

    }else if([self.purposeStr isEqualToString:@"7"]){// 支出
        if (AppDelegateInstance.userInfo != nil) {
            
            [self headerRereshing];
        }
    }
       // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
    

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
//    _ComboBox.labelText = _dataArr[selectedIndex];
//    _searchType = selectedIndex;
//    
//    [_dataArrays removeAllObjects];// 清空全部数据
//    [self requestData];
}


#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
     return _listArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取分组
    NSString *key = [_listArr objectAtIndex:section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    return [array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.section];
    FundRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[FundRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *key = [_listArr objectAtIndex:indexPath.section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    // 有数据后启用
    FundRecord *bean = array[indexPath.row];
   
    switch (bean.type) {
        case FundRecord_State_Income:
            cell.moneyLabel.text = [NSString stringWithFormat:@"+ %.2f元", bean.amount];
            break;
        case FundRecord_State_Spending:
            cell.moneyLabel.text = [NSString stringWithFormat:@"- %.2f元", bean.amount];
            break;
        case FundRecord_State_Freeze:
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", bean.amount];
            break;
        case FundRecord_State_Thaw:
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", bean.amount];
            break;
        default:
            break;
    }
    
    cell.wayLabel.text = bean.name;
    
    cell.timeLabel.text = bean.time;

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *key = [_listArr objectAtIndex:section];
    return key;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
            view.frame = CGRectMake(0, self.view.frame.size.height, 320, 260);
        } else {
            _backView.alpha = .5;
            _listView.scrollEnabled = NO;
            [view setHidden:hidden];
            view.frame = CGRectMake(0, self.view.frame.size.height - 220, 320, 260);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

#pragma 返回按钮触发方法
- (void)backClick
{
   
//      [self dismissViewControllerAnimated:YES completion:^(){}];
//    TabViewController *tabViewController = [[TabViewController alloc] init];
     TabViewController *tabViewController = [TabViewController shareTableView];
    self.frostedViewController.contentViewController = tabViewController;
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
    _total = 2;
    [self requestData];
    
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"97" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];// 必填
    [parameters setObject:_purposeStr forKey:@"purpose"];
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
        
         [_listDic removeAllObjects];
        
        if (_total == 1) {
            [_dataArrays removeAllObjects];// 清空全部数据
             [_listArr removeAllObjects];
        }
        
        NSDictionary *roots = [dics objectForKey:@"page"];
         NSMutableArray *dataArr = [NSMutableArray array];
        
        if (![[dics objectForKey:@"page"] isEqual:[NSNull null]]) {
            NSArray *results = [roots objectForKey:@"page"];
            
            _total = [[roots objectForKey:@"totalCount"] intValue];
            
            
            for (NSDictionary *item in results) {
                FundRecord *bean = [[FundRecord alloc] init];
                bean.amount = [[item objectForKey:@"amount"] floatValue];
                if (![[item objectForKey:@"time"] isEqual:[NSNull null]]) {
                    bean.time = [NSString converDate:[[item objectForKey:@"time"] objectForKey:@"time"] withFormat:@"MM-dd hh:mm:ss"];
                    
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
                    [dateFormat2 setDateFormat:@"yyyy年MM月"];
                    bean.time1 = [dateFormat2 stringFromDate:date];
                    [dataArr addObject:bean.time1];
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
        
        //去重
        for (unsigned i = 0 ; i< [dataArr count]; i ++) {
            if ( [_listArr containsObject:dataArr[i]]==NO) {
                [_listArr addObject:dataArr[i]];
            }
        }
        
        for (int i = 0; i < [_dataArrays count]; i++)
        {
            FundRecord *bean = [_dataArrays objectAtIndex:i];
            
            NSMutableArray *arrData = [_listDic objectForKey:bean.time1];
            if (arrData == nil)
            {
                arrData = [[NSMutableArray alloc] initWithCapacity:1];
                [arrData addObject:bean];
            }else
                [arrData addObject:bean];
            [_listDic setObject:arrData forKey:bean.time1];
        }
    
        [_listView reloadData];
        
    } else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
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
