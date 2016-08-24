//
//  TransferViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  债权转让
//

#import "TransferViewController.h"

#import "BarButtonItem.h"

#import "ColorTools.h"

#import "SortItem.h"
#import "SortItemGrop.h"

#import "CreditorTransfer.h"

#import "CreditorTransferTableViewCell.h"
#import "DetailsOfCreditorViewController.h"
//#import "CreditScreenViewController.h"
#import "CacheUtil.h"
#import "LoginViewController.h"
#import "AuctionViewController.h"
#import "AJSearchBar.h"
#import "AJTransferCell.h"

#define kSortHeight 40.0
#define kIS_IOS7                (kCFCoreFoundationVersionNumber> kCFCoreFoundationVersionNumber_iOS_6_1)

@interface TransferViewController ()<UITableViewDelegate,UITableViewDataSource/*,UISearchBarDelegate,UISearchDisplayDelegate*/, HTTPClientDelegate, UITextFieldDelegate >
{
    NSMutableArray *_sortArrays;// 排序View集合
    
    SortItemGrop *_sortGrop;
    
    NSMutableArray *_dataArrays;
    
//    CreditScreenViewController *ScreenView;
//    UINavigationController *ScreenViewNV;
    
    NSInteger _currPage;//页数
    NSInteger _num;//识别不同网络请求
    NSInteger _num2;//加载更多标志
}

@property (strong, nonatomic) UIView *sortContentView;
@property (strong, nonatomic) UITableView *tableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (strong, nonatomic) UISearchBar* searchBar;
@property (nonatomic, strong)  NSMutableArray *dataArr;
@property (nonatomic, copy)  NSString *transferFileName;
@property(nonatomic ,copy)  NSString *orderStr;
@property (nonatomic, assign) int totalPage;
@end

@implementation TransferViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_dataArrays.count == 0) {
        [self.tableView headerBeginRefreshing];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //通知检测对象
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(transferScreen:) name:@"screen2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"AuctionRefresh" object:nil];
    
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
//    [self readData];
}

- (void)readData
{}
- (void)initData
{
    _orderStr = @"0";
    _dataArr = [[NSMutableArray alloc] init];
    _dataArrays =[[NSMutableArray alloc] init];
}

- (void)initView
{
    self.view.backgroundColor = KblackgroundColor;
    //搜索
    //搜索
    UIView *titleV = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {440/2, 58/2}}];
    titleV.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    AJSearchBar *bar = [[AJSearchBar alloc] initWithFrame:titleV.bounds searchBlock:^(AJSearchBar *bar) {
        if (bar.text.length) {
            [weakSelf searchBarSearchButtonClicked:bar.text];  //关键字	借款标题或编号
        }else{
            [weakSelf searchBarSearchButtonClicked:@""];   //关键字	借款标题或编号
        }
        
    }];
    bar.delegate = self;
    NSDictionary *attr = @{NSForegroundColorAttributeName: SETCOLOR(235, 235, 235, 1),
                           NSFontAttributeName:[UIFont systemFontOfSize:17] };
    bar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入转让标题" attributes:attr];
    [titleV addSubview:bar];
    self.navigationItem.titleView = titleV;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64-49) style:UITableViewStyleGrouped];
    [tableView setContentInset:UIEdgeInsetsMake(0, 0,30.f/2, 0)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView setBackgroundView:nil];
    tableView.backgroundColor = KblackgroundColor;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
//    [self headerRereshing];
    
//    ScreenView = [[CreditScreenViewController alloc] init];
//    ScreenViewNV = [[UINavigationController alloc] initWithRootViewController:ScreenView];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _num = 0;
    _num2 = 0;
    _currPage = 1;
    _searchBar.text = nil;
    [self requestData];
}

-(void)requestData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取债权转让列表信息，包含债权转让列表 (opt=30)
    [parameters setObject:@"30" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"debtAmount"]; //借款金额
    [parameters setObject:@"" forKey:@"loanType"];    //借款类型
    [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
//    if (_dataArr.count) {
//        
//        _num = 2;
//        _num2 = 0;
//        [parameters setObject:[_dataArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
//        [parameters setObject:[_dataArr objectAtIndex:1]  forKey:@"debtAmount"]; //借款金额
//        [parameters setObject:[_dataArr objectAtIndex:2]  forKey:@"loanType"];    //借款类型
//        [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
//        [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
//        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
//    }
    _transferFileName = [CacheUtil creatCacheFileName:parameters];
    
    [self.requestClient requestGet:@"app/services" withParameters:parameters];

}

- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}

- (void)footerRereshing
{
    _num2 = 1 ;
    _currPage++;
    if (_currPage <= self.totalPage) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //获取债权转让列表信息，包含债权转让列表 (opt=30)
        [parameters setObject:@"30" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:@"0" forKey:@"debtAmount"]; //借款金额
        [parameters setObject:@"" forKey:@"loanType"];    //借款类型
        [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
        //    DLOG(@"债权转让加载更多的页数为 is %ld",(long)_currPage);
        if (_num ==0) {
            
            
            [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
            
            
        }else if(_num ==1){
            
            [parameters setObject:_searchBar.text forKey:@"keywords"];   //关键字	借款标题或编号
            
        }else if( _num == 2){
            [parameters setObject:[_dataArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
            [parameters setObject:[_dataArr objectAtIndex:1] forKey:@"debtAmount"]; //借款金额
            [parameters setObject:[_dataArr objectAtIndex:2] forKey:@"loanType"];    //借款类型
            [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
            [parameters setObject:@"" forKey:@"keywords"];
        }
        
        [self.requestClient requestGet:@"app/services" withParameters:parameters];  
    }else{
        self.tableView.footerRefreshingText = @"已经到底啦";
        [self.tableView footerEndRefreshing];
    }
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
//    [self readCache];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
  DLOG(@"==债权转让返回成功=======%@",obj);
    [self processData:obj isCache:NO];
}

-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    [self hiddenRefreshView];
    
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_transferFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
        }
        
        if ([[dataDics objectForKey:@"list"] count] == 0){
            
            if(_num2 == 0){
                switch (_num) {
                        
                    case 0:
                        [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                        break;
                    case 1:
                        [SVProgressHUD showErrorWithStatus:@"无搜索结果"];
                        break;
                    case 2:
                        [SVProgressHUD showErrorWithStatus:@"无筛选结果"];
                        break;
                }
                
                [_dataArrays removeAllObjects];
                [self.tableView reloadData];
            }
            
            
        }else {
            NSArray *dataArr = [dataDics objectForKey:@"list"];
            
            if (_num2 == 0){
                [_dataArrays removeAllObjects];
                
                switch (_num) {
                        
                    case 0:
//                        [SVProgressHUD showSuccessWithStatus:@"已刷新"];
                        break;
                    case 1:
                        [SVProgressHUD showSuccessWithStatus:@"搜索成功"];
                        break;
                    case 2:
                        [SVProgressHUD showSuccessWithStatus:@"筛选成功"];
                        break;
                }
            }
    
            self.totalPage = [dataDics[@"totalNum"] intValue]/ [dataDics[@"pageSize"] intValue] + 1;
            for (NSDictionary *item in dataArr) {
                
                CreditorTransfer *bean = [[CreditorTransfer alloc] initWithDict:item];
                [_dataArrays addObject:bean];
                
            }
        [_tableView reloadData];
    
    }
        
    }else if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        if (!isCache) {
            DLOG(@"返回成功===========%@",[dataDics objectForKey:@"msg"]);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
        }
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    [self readCache];
    [self hiddenRefreshView];
}

// 无可用的网络
-(void) networkError
{
    [self readCache];
    [self hiddenRefreshView];
}

- (void)readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_transferFileName];// 合成归档保存的完整路径
    DLOG(@"path is %@",cachePath);
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    if (dics) {
        [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
    }else{
        
    }
}

#pragma  mark - UITextFieldDelegate 开始搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBarSearchButtonClicked:textField.text];
    return YES;
}
#pragma 搜索点击触发方法
- (void)searchBarSearchButtonClicked:(NSString *)keywords;
{
    DLOG(@"点击了搜索按钮");
    
    if (keywords.length) {
    
        _num = 1;
        _num2 = 0;
        _currPage = 1;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //获取债权转让列表信息，包含债权转让列表 (opt=30)
        [parameters setObject:@"30" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:@"0" forKey:@"debtAmount"]; //借款金额
        [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
        [parameters setObject:keywords forKey:@"keywords"];   //关键字	借款标题或编号
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
        DLOG(@"债权转让加载更多的页数为 is %ld",(long)_currPage);
        
        [self.requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJTransferCell *cell = [AJTransferCell cellWithTableView:tableView];
    cell.aCreditorTransfer = _dataArrays[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 305.0f/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f/2;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CreditorTransfer *object = _dataArrays[indexPath.section];
    DetailsOfCreditorViewController *DetailsOfCreditorView = [[DetailsOfCreditorViewController alloc] init];
    DetailsOfCreditorView.titleString = object.title;
    DetailsOfCreditorView.rulingPriceStr = [NSString stringWithFormat:@"¥%.1f",object.currentPrincipal];
    DetailsOfCreditorView.creditorId = [NSString stringWithFormat:@"%ld", (long)object.creditorId];
    //DetailsOfCreditorView.timeString = object.time;
    [self.navigationController pushViewController:DetailsOfCreditorView animated:YES];
}

#pragma mark - 立即竞拍
//- (void)auctionBtnClick:(UIButton *)btn
//{
//    if (AppDelegateInstance.userInfo == nil) {
//        
//        [ReLogin goLogin:self];
//    }else {
//        CreditorTransfer *object = [_dataArrays objectAtIndex:btn.tag];
//        
//        [self.tabBarController.tabBar setHidden:YES];
//        AuctionViewController *auctionView = [[AuctionViewController alloc] init];
//        auctionView.creditorId = [NSString stringWithFormat:@"%ld",object.creditorId];
//        //    auctionView.debtNo = debtNo;
//        [self.navigationController pushViewController:auctionView animated:YES];
//    }
//}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    if (!self.tableView.isFooterHidden) {
        [self.tableView footerEndRefreshing];
    }
}
-(void)viewDidLayoutSubviews
{
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {

    CGRect viewBounds = self.view.bounds;
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGFloat topBarOffset = 20.0;
    viewBounds.origin.y = +topBarOffset;
    navBounds.origin.y = +topBarOffset;
    self.view.bounds = viewBounds;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//for status bar style
        
    }
}
@end
