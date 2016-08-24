//
//  AJInvestChildController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/23.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJInvestChildController.h"
#import "CacheUtil.h"
#import "Investment.h"
#import "AJInvestRecommendCell.h"
#import "AJInvestCell.h"
#import "JSONKit.h"
#import "BorrowingDetailsViewController.h"

@interface AJInvestChildController ()<HTTPClientDelegate>
@property (nonatomic, strong) NSMutableArray *DataArray;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic, assign) int currPage;
@property (nonatomic, copy)NSString *loanType;
@property(nonatomic ,copy)  NSString *investFileName;
@property (nonatomic, assign) int totalPage;
@end

@implementation AJInvestChildController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (self.DataArray.count== 0) {
//        [self.tableView headerBeginRefreshing];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 如果数组为空则刷新
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = KblackgroundColor;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
}

- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}

- (NSMutableArray *)DataArray
{
    if (_DataArray == nil) {
        _DataArray = [NSMutableArray array];
    }
    return _DataArray;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.currPage = 1;
    [self requestData];
}

-(void)requestData
{
    //2.1获取投资列表信息，包含投资列表。[OK]
    //        [_dataArrays removeAllObjects];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"10" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"amount"]; //借款金额
    [parameters setObject:@"0" forKey:@"loanSchedule"]; //投标进度
    [parameters setObject:@"" forKey:@"startDate"]; //开始日期
    [parameters setObject:@"" forKey:@"endDate"]; //结束日期
    [parameters setObject:self.loanType forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    long currPage = self.currPage;
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)currPage] forKey:@"currPage"];  //当前页数
    
    _investFileName = [CacheUtil creatCacheFileName:parameters];
    
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)footerRereshing
{
    self.currPage ++;
    
    if ( self.currPage <= self.totalPage) {
         [self requestData];
    }else{
        self.tableView.footerRefreshingText = @"已经到底啦";
        [self.tableView footerEndRefreshing];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.DataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Investment *object = self.DataArray[indexPath.section];
    if (indexPath.section == 0 && [self.loanType isEqualToString:@"-1"] && [object.product_id intValue] == 7) {
        // 全部里面的第一个是推荐的新手表则由 ;5 — 稳赢宝  7 —— 新手表 ; 其他 === 商理宝
        
        AJInvestRecommendCell *cell = [AJInvestRecommendCell cellWithTableView:tableView];
        cell.aInvestment = object;
        return cell;
    }else{
        AJInvestCell *cell = [AJInvestCell cellWithTableView:tableView];
        
        cell.aInvestment = object;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Investment *object = self.DataArray[indexPath.section];
    if (indexPath.section == 0 &&  [self.loanType isEqualToString:@"-1"] && [object.product_id intValue] == 7) {
        // 全部里面的第一个是推荐的新手表则由 ;5 — 稳赢宝  7 —— 新手表 ; 其他 === 商理宝
        
        return 445.f/2;
    }else{
        return 308.f/2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f/2;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//返回时取消选中状态
    Investment *object = self.DataArray[indexPath.section];
    BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.titleString = object.title;
    BorrowingDetailsView.borrowID = object.borrowId;
    BorrowingDetailsView.progressnum = (object.progress)*0.01;
    BorrowingDetailsView.rate = object.rate;
    BorrowingDetailsView.timeString = object.time;
    BorrowingDetailsView.stateNum = 0;
    [self.navigationController pushViewController:BorrowingDetailsView animated:YES];
}

-(void)readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_investFileName];// 合成归档保存的完整路径
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES loanType:dics[@"loanType"]];// 读取上一次成功缓存的数据
}

-(void)processData:(NSDictionary *)dataDics isCache:(BOOL) isCache loanType:(NSString *)loanType
{
    DLOG(@"==返回成功=======%@",[dataDics JSONString]);
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_investFileName];// 合成归档保存的完整路径
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dataDics];
            [dic setObject:loanType forKey:@"loanType"];
            [NSKeyedArchiver archiveRootObject:dic toFile:cachePath];// 数据归档，存取缓存
        }
        if ([[dataDics objectForKey:@"list"] count] == 0){
            
            [SVProgressHUD showErrorWithStatus:@"暂无数据"];
        }else {
//            NSNumber *totolCount = dataDics[@"records"][@"totalCount"];
//            NSNumber *pageSize = dataDics[@"records"][@"pageSize"];
            if (self.currPage == 1) {
                [self.DataArray removeAllObjects];
            }
            if (![dataDics[@"totalNum"] isEqual:[NSNull null]] && ![dataDics[@"pageSize"] isEqual:[NSNull null]]) {
                 self.totalPage = [dataDics[@"totalNum"] intValue]/ [dataDics[@"pageSize"] intValue] + 1;
            }
            NSArray *dataArr = [dataDics objectForKey:@"list"];
            if (self.currPage == 1) {
                [self.DataArray removeAllObjects];
            }
            for (NSDictionary *item in dataArr) {
                Investment *bean = [[Investment alloc] initWithDict:item];
                [self.DataArray addObject:bean];
            }
            
            [self.tableView reloadData];
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        
        if(!isCache)
        {
            DLOG(@"返回失败===========%@",[dataDics objectForKey:@"msg"]);
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
            
        }
    }
}
#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}
// 返回成功
-(void) httpResponseSuccessWithParam:(NSDictionary *)param dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSString *loanType = param[@"loanType"];
    [self processData:obj isCache:NO loanType:loanType];// 读取当前请求到的数据
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}
// 返回失败
-(void) httpResponseFailureWithParam:(NSDictionary *)param dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    [self readCache];
}

// 无可用的网络
-(void) networkError
{
    [self.tableView headerEndRefreshing];
    [self.tableView  footerEndRefreshing];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    [self readCache];
}

#pragma  mark - 搜索
- (void)searchBidsWithKeywords:(NSString *)keywords
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"10" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"amount"]; //借款金额
    [parameters setObject:@"0" forKey:@"loanSchedule"]; //投标进度
    [parameters setObject:@"" forKey:@"startDate"]; //开始日期
    [parameters setObject:@"" forKey:@"endDate"]; //结束日期
    [parameters setObject:self.loanType forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
    if (keywords.length) {
        [parameters setObject:keywords  forKey:@"keywords"];   //关键字	借款标题或编号
    }else{
        
        [parameters setObject:@""  forKey:@"keywords"];   //关键字	借款标题或编号
    }
    self.currPage = 1;// 搜索的时候分页没处理
    [parameters setObject:[NSString stringWithFormat:@"%d",self.currPage] forKey:@"currPage"];
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}
@end
