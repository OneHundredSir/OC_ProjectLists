//
//  BidRecordsViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》理财子账户————》投标记录
#import "BidRecordsViewController.h"

#import "ColorTools.h"
#import "BidRecordsCell.h"
#import "BorrowingDetailsViewController.h"

#import "BidRecords.h"

@interface BidRecordsViewController ()<UITableViewDelegate,UITableViewDataSource, HTTPClientDelegate> {
    
    NSMutableArray *_collectionArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
}

@property (nonatomic,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation BidRecordsViewController

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
    [_listView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"我的投标记录";
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
    static NSString *cellid = @"cellid";
    BidRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[BidRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    BidRecords *bean = [_collectionArrays objectAtIndex:indexPath.section];
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@", bean.investAmount];
    cell.numLabel.text = bean.time;
    
    [cell setStateColor:bean.status];
    if (bean.status == 0) {
        cell.stateLabel.text = @"正常";
        
    }else if (bean.status == 1) {
        cell.stateLabel.text = @"转让中";
    }else if (bean.status == -1) {
        cell.stateLabel.text = @"已转让出";
    }
    
    cell.billidLabel.text = [NSString stringWithFormat:@"借款标标号: %@", bean.bidId];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BidRecords *bean = _collectionArrays[indexPath.section];
    
    BorrowingDetailsViewController *borrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    borrowingDetailsView.borrowID = bean.bidId;
    borrowingDetailsView.stateNum = 0;
    borrowingDetailsView.titleString = bean.titleName;
    
    [self.navigationController pushViewController:borrowingDetailsView animated:YES];
    
    DLOG(@"borrow ->%@", bean.bidId);
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
        [self hiddenRefreshView];
       [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"40" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
        

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
    [self hiddenRefreshView];
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        // 清空全部数据
        if (_total == 1) {
            [_collectionArrays removeAllObjects];
        }
        
        _total = [[dics objectForKey:@"totalNum"] intValue];// 总共多少条
        
        NSArray *collections = [obj objectForKey:@"list"];
        
        if (![collections isEqual:[NSNull null]]) {
            
            for (NSDictionary *item in collections) {
                BidRecords *bean = [[BidRecords alloc] init];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[item objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
                [dataFormat setDateFormat:@"MM-dd"];
                
                bean.time = [dataFormat stringFromDate: date];
                bean.investAmount = [item objectForKey:@"invest_amount"];
                bean.status = [[item objectForKey:@"transfer_status"] intValue];
                bean.bidId =  [item objectForKey:@"bid_id"];
                bean.titleName =  [item objectForKey:@"title"];
                
                [_collectionArrays addObject:bean];
                
                DLOG(@"time -> %@", bean.time);
                DLOG(@"time -> %@", bean.investAmount);
            }
        }
        
        // 刷新表格
        [_listView reloadData];
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
     [self hiddenRefreshView];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
    
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

@end
