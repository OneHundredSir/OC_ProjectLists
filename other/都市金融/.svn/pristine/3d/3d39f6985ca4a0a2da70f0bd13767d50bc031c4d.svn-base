//
//  RepaymentHistoricalFBViewController.m
//  SP2P_7
//
//  Created by kiu on 14-10-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  理财子账户 -> 理财账单 -> 历史收款记录

#import "RepaymentHistoricalFBViewController.h"

#import "FinancialBills.h"
//#import "FinancialBillsCell.h"
#import "AJFinancialBillHistoryCell.h"

@interface RepaymentHistoricalFBViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate> {
    NSMutableArray *_collectionArrays;
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
}

@property (nonatomic,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation RepaymentHistoricalFBViewController

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
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"历史收款记录";
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


#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 60.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJFinancialBillHistoryCell *cell = [AJFinancialBillHistoryCell cellWithTableView:tableView];
       // 有数据后启用
    FinancialBills *bean = _collectionArrays[indexPath.section];
    cell.aFinancialBills = bean;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        [parameters setObject:@"39" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
        [parameters setObject:_billId forKey:@"billId"];
        [parameters setObject:@"1" forKey:@"currPage"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [_listView reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self hiddenRefreshView];
        });
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        // 清空全部数据
        if (_total == 1) {
            [_collectionArrays removeAllObjects];
        }
        
        NSArray *collections = [obj objectForKey:@"list"];
        for (NSDictionary *item in collections) {
            FinancialBills *bean = [[FinancialBills alloc] init];
            
            bean.title =  [item objectForKey:@"borrowTitle"];
            bean.incomeAmounts = [[item objectForKey:@"repayAmount"] floatValue];
            
            // 是否逾期（-1, 0, -5是未逾期 否则逾期）
            bean.isOverdue =  [[item objectForKey:@"isOverdue"] intValue];
            // -1，-2，-5 -6 未收款
            // -7 已转让
            // 否则已收款
            bean.status =  [[item objectForKey:@"isRepay"] intValue];
            
            [_collectionArrays addObject:bean];
        }
           [_listView reloadData];
        
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

@end
