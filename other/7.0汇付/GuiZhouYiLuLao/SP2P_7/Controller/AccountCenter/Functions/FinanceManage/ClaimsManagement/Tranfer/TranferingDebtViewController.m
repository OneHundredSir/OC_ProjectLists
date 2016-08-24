//
//  TranferingDebtViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(转让债权管理) -> 转让中状态(opt = 47)

#import "TranferingDebtViewController.h"
#import "ColorTools.h"
#import "CreditorRightTransferDetailsViewController.h"
#import "TransferloanStandardDetailsViewController.h"
#import "AuctionRecordTwoViewController.h"

@interface TranferingDebtViewController ()<UITableViewDelegate,UITableViewDataSource, HTTPClientDelegate>
{
    
    NSArray *titlyArr;
    NSArray *dataArr;
    
    BOOL dealStatu;     // 成交状态
    int optStatus;     // 解析状态
}

@property (nonatomic, strong) UILabel *bidRemainTime;       // 竞拍剩余时间
@property (nonatomic, strong) UILabel *hightestBid;         // 目前最高竞价
@property (nonatomic, strong) UIButton *dealBtn;            // 成交按钮
@property (nonatomic)NSTimeInterval time;//相差时间

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TranferingDebtViewController

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
    
    [self requestData];
}

/**
 * 初始化数据
 */
- (void)initData
{
    titlyArr = @[@"竞拍剩余时间: ",@"目前最高竞价: "];
    dataArr = @[@"竞拍记录",@"债权转让详情",@"转让的借款标详情"];
    
    dealStatu = YES;
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    for (int i = 0; i<[titlyArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(20, 105+i*30, 120, 30);
        titleLabel.text = [titlyArr objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.view addSubview:titleLabel];
        
    }
    _bidRemainTime = [[UILabel alloc] initWithFrame:CGRectMake(118, 105, 200, 30)];
    _bidRemainTime.text = @"";
    _bidRemainTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _bidRemainTime.textColor = PinkColor;
    [self.view addSubview:_bidRemainTime];
    
    _hightestBid = [[UILabel alloc] initWithFrame:CGRectMake(118, 135, 200, 30)];
    _hightestBid.text = @"";
    _hightestBid.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _hightestBid.textColor = PinkColor;
    [self.view addSubview:_hightestBid];
    
    //成交
    _dealBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_dealBtn setTitle:@"成交" forState:UIControlStateNormal];
    [_dealBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _dealBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _dealBtn.frame = CGRectMake(self.view.frame.size.width*0.5-60, 200, 120, 30);
    _dealBtn.layer.cornerRadius = 3.0f;
    _dealBtn.layer.masksToBounds = YES;
    _dealBtn.backgroundColor = BrownColor;
    [_dealBtn addTarget:self action:@selector(dealBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dealBtn];
    
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-115, self.view.frame.size.width, 110) style:UITableViewStyleGrouped];
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.separatorColor = [UIColor grayColor];
    listView.delegate = self;
    listView.scrollEnabled = NO;
    listView.dataSource = self;
    [self.view  addSubview:listView];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [dataArr count];
    
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
    return 30.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            
            AuctionRecordTwoViewController *auctionRecordTwoView = [[AuctionRecordTwoViewController alloc] init];
            auctionRecordTwoView.creditorId = _sign;
            [self.navigationController pushViewController:auctionRecordTwoView animated:YES];
            
        }
            break;
        case 1:
        {
            CreditorRightTransferDetailsViewController *creditorRightTransferDetailsView =[[CreditorRightTransferDetailsViewController alloc] init];
            creditorRightTransferDetailsView.sign = _sign;
            [self.navigationController pushViewController:creditorRightTransferDetailsView animated:YES];
        }
            break;
            
        case 2:
        {
            TransferloanStandardDetailsViewController *transferloanStandardDetailsView =[[TransferloanStandardDetailsViewController alloc]init];
            transferloanStandardDetailsView.sign = _sign;
            [self.navigationController pushViewController:transferloanStandardDetailsView animated:YES];
            
        }
            break;
    }
}


#pragma 成交按钮
- (void)dealBtnClick:(UIButton *)btn
{
    DLOG(@"成交按钮！");
    if ([_hightestBid.text intValue] == 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"对不起！该债权暂时没有用户参与竞拍，暂时不能成交"]];
        
        return;
    }
        
    if (dealStatu) {
        
//        NSString *str = [NSString stringWithFormat:@"您确定以 %@ 的竞价将 %@ 元的债权转让给用户%@吗？", _hightestBid.text, _receivedAmount, _bidName];
        NSString *str = [NSString stringWithFormat:@"您是否确定以 %@ 转让此债权？", _hightestBid.text];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认成交" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }else {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"该债权已经成交"]];
    }
}

#pragma mark - UIAlertView 代理
// 确认成交
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLOG(@"buttonIndex: %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 1:
        {
            DLOG(@"确认成交");
            optStatus = 51;
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            [parameters setObject:@"158" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:_sign forKey:@"sign"];
            
            if (_requestClient == nil) {
                _requestClient = [[NetWorkClient alloc] init];
                _requestClient.delegate = self;
                
            }
            [_requestClient requestGet:@"app/services" withParameters:parameters];
        }
            break;
        case 0:
        {
            
        }
            break;
    }
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
        optStatus = 47;
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"47" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_sign forKey:@"sign"];
        
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
        
        if (optStatus == 47) {
            
            if( [obj objectForKey:@"bidRemainTime"] != nil && ![[obj objectForKey:@"bidRemainTime"] isEqual:[NSNull null]])
            {
                
                NSString  *timeStr = [[NSString stringWithFormat:@"%@",[obj objectForKey:@"bidRemainTime"]] substringWithRange:NSMakeRange(0, 19)];
                [self timeDown:timeStr];
            }
            
            _hightestBid.text = [NSString stringWithFormat:@"%@ 元", [obj objectForKey:@"hightestBid"]];
        }else if (optStatus == 51){
            dealStatu = NO;
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"transferRefresh" object:self];
                
            });
        }
        
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

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

//剩余时间倒计时
- (void)timeDown:(NSString *)timeStr
{
    //剩余时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSDate *senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:timeStr];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    _time = [endDate timeIntervalSinceDate:senderDate];
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        _bidRemainTime.text =@"已过期";
        
    }else {
        _bidRemainTime.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    }
    
    
}

//剩余时间倒计时(每秒钟调用一次)
- (void)timerFireMethod
{
    _time--;
    
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        _bidRemainTime.text =@"已过期";
        
    }else {
        _bidRemainTime.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        
    }
}

@end