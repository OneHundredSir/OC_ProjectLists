//
//  FinancialStatisticsViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》理财子账户————》理财统计
#import "FinancialStatisticsViewController.h"

#import "ColorTools.h"
#import "FinancialStatistics.h"

#define fontsize 16.0f

@interface FinancialStatisticsViewController ()<HTTPClientDelegate, UIScrollViewDelegate>
{
    NSArray *btntitleArr;
    NSArray *titleArr;
    NSInteger year;
    NSInteger monthnum;     //  索引
    NSInteger _month;       // 当前月份
    
    CGFloat width;
    CGFloat height;
   
    NSMutableArray *_collectionArrays;
}
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *yearlabel;
@property (nonatomic,strong) UILabel *shulabel;

@property (nonatomic, strong) UIScrollView *scrollView;
//  投标数量
@property (nonatomic, strong) UILabel *bidNum;
//  均借款标金额
@property (nonatomic, strong) UILabel *avgBorrowAmount;
//  均借款期限(月)
@property (nonatomic, strong) UILabel *avgDeadline;
//  均投标金额
@property (nonatomic, strong) UILabel *avgbidAmount;
//  投标总金额
@property (nonatomic, strong) UILabel *bidAmountSum;
//  均投资回报率
@property (nonatomic, strong) UILabel *avgReturnRate;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation FinancialStatisticsViewController


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
    //获得系统时间
    NSDate * senddate=[NSDate date];
    //获得系统日期
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    year = [conponent year];
    NSInteger month=[conponent month];
    monthnum = month;
    // 记录当前月份
    _month = 12;
    
    titleArr = @[@"投标数量:",@"均借款标金额:",@"均借款期限(月):",@"均投标金额:",@"投标总金额:",@"均投资回报率:"];
    
    _collectionArrays =[[NSMutableArray alloc] init];
    
    for (int item = 0; item < 12; item++) {
        
        FinancialStatistics *bean = [[FinancialStatistics alloc] init];
        
        bean.bidNum = 0;
        bean.avgDeadline = @"0";
        bean.avgbidAmount = @"0";
        bean.avgBorrowAmount = @"0";
        bean.bidAmountSum = @"0";
        bean.avgReturnRate = @"0";
        
        [_collectionArrays addObject:bean];
    }
    
    DLOG(@"_collectionArrays -> %lu", (unsigned long)_collectionArrays.count);
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //  左边按钮
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(5.0f, 80.0f, 50.0f, 40.0f);
    _leftBtn.backgroundColor = KblackgroundColor;
    _leftBtn.tag = 1;
    [_leftBtn setTitle:[NSString stringWithFormat:@"《%d月",(int)monthnum - 1] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_leftBtn addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.userInteractionEnabled = NO;
    
    [self.view addSubview:_leftBtn];
    
    //  右边按钮
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(self.view.frame.size.width - 55.0f, 80.0f, 50.0f, 40.0f);
    _rightBtn.backgroundColor = KblackgroundColor;
    _rightBtn.tag = 2;
    [_rightBtn setTitle:[NSString stringWithFormat:@"%d月》",(int)monthnum + 1] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_rightBtn addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.userInteractionEnabled = NO;
    _rightBtn.hidden = YES;
    
    [self.view addSubview:_rightBtn];
    
    // 中间部分 年月
    _yearlabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0f) * 0.5, 90.0f, 150.0f, 30.0f)];
    _yearlabel.text = [NSString stringWithFormat:@"%d年%d月", (int)year, (int)monthnum];
    _yearlabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
    _yearlabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_yearlabel];
    
    // 画直线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.view.frame.size.width, 1)];
    lineView.backgroundColor = KblackgroundColor;
    [self.view addSubview:lineView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 136, self.view.frame.size.width, 270)];
    width = _scrollView.frame.size.width;
    height = _scrollView.frame.size.height;
    
    [self.view addSubview:_scrollView];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(_collectionArrays.count * width, height);
    _scrollView.pagingEnabled = YES;
//    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = NO;
    
    // 根据当前日期，定位。
    CGFloat offsetX = (_month - 1) * _scrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
    
}

#pragma 左右按钮
- (void)butClick:(UIButton *)button
{
    if (button.tag == 1) {
        DLOG(@"left Button");
        _month --;
        monthnum --;
        _rightBtn.hidden = NO;
        
        if (_month < 2) {
            _leftBtn.hidden = YES;
        }
        
        if (monthnum < 1) {
            monthnum = 12;
            year --;
        }
        
        DLOG(@"current - > %d", (int)monthnum);
    }else{
        DLOG(@"right Button");
        
        _month ++;
        monthnum ++;
        _leftBtn.hidden = NO;
        
        if (_month > 11) {
            _rightBtn.hidden = YES;
        }
        
        if (monthnum > 12) {
            monthnum = 1;
            year ++;
        }
        
        DLOG(@"current - > %d", (int)monthnum);
    }
    
    CGFloat offsetX = (_month - 1) * _scrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
    
    [self update];
}

// 更新中间区域数据
- (void)update
{
    if (monthnum + 1 > 12) {
        [_rightBtn setTitle:@"1月" forState:UIControlStateNormal];
    }else {
        [_rightBtn setTitle:[NSString stringWithFormat:@"%d月",(int)monthnum + 1] forState:UIControlStateNormal];
    }
    
    if (monthnum - 1 < 1) {
        [_leftBtn setTitle:@"12月" forState:UIControlStateNormal];
    }else {
        [_leftBtn setTitle:[NSString stringWithFormat:@"%d月",(int)monthnum - 1] forState:UIControlStateNormal];
    }
    _yearlabel.text = [NSString stringWithFormat:@"%d年%d月", (int)year, (int)monthnum];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"理财统计";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];

    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma 返回按钮触发方法
- (void)backClick
{
      [self dismissViewControllerAnimated:YES completion:^(){}];
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"61" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        
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
        
        NSArray *collections = [obj objectForKey:@"list"];
        for (NSDictionary *item in collections) {
            FinancialStatistics *bean = [[FinancialStatistics alloc] init];
            
            bean.bidNum = [[item objectForKey:@"invest_count"] integerValue];   // 投标数量
            bean.avgDeadline = [item objectForKey:@"average_invest_period"];    // 均借款期限(月)
            bean.avgbidAmount = [item objectForKey:@"average_invest_amount"];            // 均投标金额
            bean.avgBorrowAmount = [item objectForKey:@"average_loan_amount"];      // 均借款标金额
            bean.bidAmountSum = [item objectForKey:@"invest_amount"];            // 投标总金额
            
            NSString *percentStr = @"%";
            bean.avgReturnRate = [NSString stringWithFormat:@"%@%@", [item objectForKey:@"invest_fee_back"],percentStr];          // 均投资回报率
            
            int curr = [[item objectForKey:@"month"] intValue];
            
            [_collectionArrays replaceObjectAtIndex:curr + 12 - monthnum - 1 withObject:bean];
            
            DLOG(@"item -> %@", item);
        }
        
        DLOG(@"_collectionArrays.count -> %lu", (unsigned long)_collectionArrays.count);
        
        
        // 更新页面中间模块内容
        for (int i = 0; i < _collectionArrays.count; i++) {
            FinancialStatistics *income = _collectionArrays[i];
            
            // 中间部分 投标数量
            _bidNum = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80, 15.0f, 200.0f, 30.0f)];
            _bidNum.text = [NSString stringWithFormat:@"投标数量: %ld", (long)income.bidNum];
            _bidNum.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_bidNum];
            
            // 中间部分 均借款标金额
            _avgBorrowAmount = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 45.0f, 200.0f, 30.0f)];
            _avgBorrowAmount.text = [NSString stringWithFormat:@"均借款标金额: %@", income.avgBorrowAmount];
            _avgBorrowAmount.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_avgBorrowAmount];
            
            // 中间部分 均借款期限(月)
            _avgDeadline = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 75.0f, 200.0f, 30.0f)];
            _avgDeadline.text = [NSString stringWithFormat:@"均借款期限(月): %@", income.avgDeadline];
            _avgDeadline.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_avgDeadline];
            
            // 中间部分 均投标金额
            _avgbidAmount = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 105.0f, 200.0f, 30.0f)];
            _avgbidAmount.text = [NSString stringWithFormat:@"均投标金额: ￥%@", income.avgbidAmount];
            _avgbidAmount.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_avgbidAmount];
            
            // 中间部分 投标总金额
            _bidAmountSum = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 135.0f, 200.0f, 30.0f)];
            _bidAmountSum.text = [NSString stringWithFormat:@"投标总金额: ￥%@", income.bidAmountSum];
            _bidAmountSum.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_bidAmountSum];
            
            // 中间部分 均投资回报率
            _avgReturnRate = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 165.0f, 200.0f, 30.0f)];
            _avgReturnRate.text = [NSString stringWithFormat:@"均投资回报率: %@", income.avgReturnRate];
            _avgReturnRate.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_avgReturnRate];
        }
        
        _leftBtn.userInteractionEnabled = YES;
        _rightBtn.userInteractionEnabled = YES;
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

#pragma mark 调用UIScrollView 代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    monthnum = pageNum + 1;
    
    DLOG(@"monthnum -> %ld", (long)monthnum);
    
    if (monthnum < 2) {
        _leftBtn.hidden = YES;
    }else {
        _leftBtn.hidden = NO;
    }
    
    if (monthnum > 11) {
        _rightBtn.hidden = YES;
    }else {
        _rightBtn.hidden = NO;
    }
    
    [self update];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
