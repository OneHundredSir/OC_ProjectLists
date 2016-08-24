//
//  IncomeViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我的推广收入

#import "IncomeViewController.h"

#import "ColorTools.h"
#import "ExtensionMemberViewController.h"
#import "Income.h"

@interface IncomeViewController ()<HTTPClientDelegate, UIScrollViewDelegate>
{
    NSMutableArray *_collectionArrays;
    NSInteger year;
    NSInteger monthnum;     //  索引
    NSInteger _month;       // 当前月份
    
    CGFloat width;
    CGFloat height;
}

@property (nonatomic, strong) UIButton *leftBut;
@property (nonatomic, strong) UIButton *rightBut;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *isLogin;

//  年份
@property (nonatomic, strong) UILabel *dateTime;
//  总会员名
@property (nonatomic, strong) UILabel *incomeMember;
//  有效会员
@property (nonatomic, strong) UILabel *yesMember;
//  无效会员
@property (nonatomic, strong) UILabel *noMember;
//  CPS奖金
@property (nonatomic, strong) UILabel *cpsBonus;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation IncomeViewController


- (void)request {
    if (AppDelegateInstance.userInfo == nil) {
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"96" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化数据
    [self initData];
    [self request];
    
    // 初始化视图
    [self initView];
    
    
}

/**
 初始化数据
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
    
    _collectionArrays =[[NSMutableArray alloc] init];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Income" withExtension:@"plist"];
//    NSArray *collections = [NSArray arrayWithContentsOfURL:url];
//    for (NSDictionary *item in collections) {
//    Income *bean = [[Income alloc] init];
//        bean.dateTime =  [item objectForKey:@"times"];
//        bean.incomeMember = [item objectForKey:@"incomeMember"];
//        bean.yseMember = [item objectForKey:@"yseMember"];
//        bean.noMember = [item objectForKey:@"noMember"];
//        bean.cpsBonus =  [item objectForKey:@"cpsBonus"];
//    [_collectionArrays addObject:bean];
//}
    for (int item = 0; item < 12; item++) {

        Income *bean = [[Income alloc] init];
        
        bean.dateTime =  0;
        bean.incomeMember = @"0";
        bean.yseMember = @"0";
        bean.noMember = @"0";
        bean.cpsBonus =  @"0";
        
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
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"我的推广收入";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:16.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    _isLogin = AppDelegateInstance.userInfo.isLogin;
    
    if (_isLogin) {
        DLOG(@"已登录");
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 225)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:whiteView];
        
        //  左边按钮
        _leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBut.frame = CGRectMake(5.0f, 80.0f, 50.0f, 40.0f);
        _leftBut.backgroundColor = KblackgroundColor;
        _leftBut.tag = 1;
        [_leftBut setTitle:[NSString stringWithFormat:@"%ld月",monthnum - 1] forState:UIControlStateNormal];
        [_leftBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftBut.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
        [_leftBut addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_leftBut];
        
        //  右边按钮
        _rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBut.frame = CGRectMake(self.view.frame.size.width - 55.0f, 80.0f, 50.0f, 40.0f);
        _rightBut.backgroundColor = KblackgroundColor;
        _rightBut.tag = 2;
        [_rightBut setTitle:[NSString stringWithFormat:@"%ld月",monthnum + 1] forState:UIControlStateNormal];
        [_rightBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBut.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
        [_rightBut addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBut.hidden = YES;
        
        [self.view addSubview:_rightBut];
        
        // 中间部分 年月
        _dateTime = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0f) * 0.5, 90.0f, 150.0f, 30.0f)];
        _dateTime.text = [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)monthnum];
        _dateTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
        _dateTime.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:_dateTime];
        
        // 画直线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.view.frame.size.width, 1)];
        lineView.backgroundColor = KblackgroundColor;
        [self.view addSubview:lineView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 136, self.view.frame.size.width, 155)];
        width = _scrollView.frame.size.width;
        height = _scrollView.frame.size.height;
        
        [self.view addSubview:_scrollView];
        
//        for (int i = 0; i < _collectionArrays.count; i++) {
//            Income *income = _collectionArrays[i];
//            
//            // 中间部分 推广会员数
//            _incomeMember = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80, 15.0f, 200.0f, 30.0f)];
//            _incomeMember.text = [NSString stringWithFormat:@"推广会员数: %@", income.incomeMember];
//            _incomeMember.font = [UIFont fontWithName:@"Arial" size:14.0];
//            
//            [_scrollView addSubview:_incomeMember];
//            
//            // 中间部分 有效会员数
//            _yesMember = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 45.0f, 200.0f, 30.0f)];
//            _yesMember.text = [NSString stringWithFormat:@"有效会员数: %@", income.yseMember];
//            _yesMember.font = [UIFont fontWithName:@"Arial" size:14.0];
//            
//            [_scrollView addSubview:_yesMember];
//            
//            // 中间部分 无效会员数
//            _noMember = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 75.0f, 200.0f, 30.0f)];
//            _noMember.text = [NSString stringWithFormat:@"无效会员数: %@", income.noMember];
//            _noMember.font = [UIFont fontWithName:@"Arial" size:14.0];
//            
//            [_scrollView addSubview:_noMember];
//            
//            // 中间部分 CPS奖金
//            _cpsBonus = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 105.0f, 200.0f, 30.0f)];
//            _cpsBonus.text = [NSString stringWithFormat:@"CPS奖金: ￥%@", income.cpsBonus];
//            _cpsBonus.font = [UIFont fontWithName:@"Arial" size:14.0];
//            
//            [_scrollView addSubview:_cpsBonus];
//        }
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_collectionArrays.count * width, height);
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = NO;
//        _scrollView.delegate = self;
        
        // 根据当前日期，定位。
        CGFloat offsetX = (_month - 1) * _scrollView.frame.size.width;
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset = CGPointMake(offsetX, 0);
        }];
        
        // 查看明细
        UIButton *DetailBut = [UIButton buttonWithType:UIButtonTypeCustom];
        DetailBut.frame = CGRectMake((self.view.frame.size.width - 150)*0.5,320.0f, 150.0f, 30.0f);
        DetailBut.backgroundColor = GreenColor;
        [DetailBut setTitle:@"查看明细" forState:UIControlStateNormal];
        [DetailBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        DetailBut.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
        [DetailBut.layer setMasksToBounds:YES];
        [DetailBut.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
        [DetailBut addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:DetailBut];
    }else {
        [SVProgressHUD showErrorWithStatus:@"未登录"];
    }
}

#pragma mark 1、返回
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 查看详细
- (void)detailClick
{
    ExtensionMemberViewController *member = [[ExtensionMemberViewController alloc] init];
    [self.navigationController pushViewController:member animated:YES];
}

#pragma 左右按钮
- (void)butClick:(UIButton *)button
{
    if (button.tag == 1) {
        DLOG(@"left Button");
        _month --;
        monthnum --;
        _rightBut.hidden = NO;
        
        if (_month < 2) {
            _leftBut.hidden = YES;
        }
        
        if (monthnum < 1) {
            monthnum = 12;
            year --;
        }
        
        DLOG(@"current - > %@", @(monthnum));
    }else{
         DLOG(@"right Button");
        
        _month ++;
        monthnum ++;
        _leftBut.hidden = NO;
        
        if (_month > 11) {
            _rightBut.hidden = YES;
        }
        
        if (monthnum > 12) {
            monthnum = 1;
            year ++;
        }
        
        DLOG(@"current - > %@", @(monthnum));
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
        [_rightBut setTitle:@"1月" forState:UIControlStateNormal];
    }else {
        [_rightBut setTitle:[NSString stringWithFormat:@"%ld月",monthnum + 1] forState:UIControlStateNormal];
    }
    
    if (monthnum - 1 < 1) {
        [_leftBut setTitle:@"12月" forState:UIControlStateNormal];
    }else {
        [_leftBut setTitle:[NSString stringWithFormat:@"%ld月",monthnum - 1] forState:UIControlStateNormal];
    }
    _dateTime.text = [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)monthnum];
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

        NSArray *collections = [[obj objectForKey:@"page"] objectForKey:@"page"];
        for (NSDictionary *item in collections) {
            Income *bean = [[Income alloc] init];
            
            bean.dateTime =  [item objectForKey:@"year"];
            bean.incomeMember = [item objectForKey:@"spread_user_account"];
            bean.yseMember = [item objectForKey:@"effective_user_account"];
            bean.noMember = [item objectForKey:@"invalid_user_account"];
            bean.cpsBonus =  [item objectForKey:@"cps_reward"];
            
            int curr = (int)[[item objectForKey:@"month"] integerValue];
            
            [_collectionArrays replaceObjectAtIndex:curr + 12 - monthnum - 1 withObject:bean];
        }
        
        // 加载中间内容数据
        for (int i = 0; i < _collectionArrays.count; i++) {
            Income *income = _collectionArrays[i];
            
            // 中间部分 推广会员数
            _incomeMember = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80, 15.0f, 200.0f, 30.0f)];
            _incomeMember.text = [NSString stringWithFormat:@"推广会员数: %@", income.incomeMember];
            _incomeMember.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_incomeMember];
            
            // 中间部分 有效会员数
            _yesMember = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 45.0f, 200.0f, 30.0f)];
            _yesMember.text = [NSString stringWithFormat:@"有效会员数: %@", income.yseMember];
            _yesMember.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_yesMember];
            
            // 中间部分 无效会员数
            _noMember = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 75.0f, 200.0f, 30.0f)];
            _noMember.text = [NSString stringWithFormat:@"无效会员数: %@", income.noMember];
            _noMember.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_noMember];
            
            // 中间部分 CPS奖金
            _cpsBonus = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 80.0f, 105.0f, 200.0f, 30.0f)];
            _cpsBonus.text = [NSString stringWithFormat:@"CPS奖金: ￥%@", income.cpsBonus];
            _cpsBonus.font = [UIFont fontWithName:@"Arial" size:14.0];
            
            [_scrollView addSubview:_cpsBonus];
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

//#pragma mark 调用UIScrollView 代理
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    
//    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
//    DLOG(@"pageNum -> %d", pageNum);
//    if (pageNum == 0) {
//        isLimit ++;
//    }
//    
//    if (isLimit < 3) {
//        if (_month - pageNum > 1) {
//            monthnum --;
//        }else{
//            monthnum ++;
//            isLimit = 1;
//        }
//        
//        _month = pageNum + 1;
//        DLOG(@"monthnum -> %d", monthnum);
//        
//        if (_month < 2) {
//            _leftBut.hidden = YES;
//        }else {
//            _leftBut.hidden = NO;
//        }
//        
//        if (_month > 11) {
//            _rightBut.hidden = YES;
//        }else {
//            _rightBut.hidden = NO;
//        }
//        
//        if (monthnum < 1) {
//            monthnum = 12;
//            year --;
//        }
//        
//        if (monthnum > 12) {
//            monthnum = 1;
//            year ++;
//        }
//        
//        [self update];
//    }
//}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
