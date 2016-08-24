//
//  AJDailyEarningRepayController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/20.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJDailyEarningRepayController.h"
#import "AJSegmentView.h"
#import "AJModelAJSegmentView.h"
#import "AJDailyEarningRepayCell.h"
#import "AJDailyEarningRepayDoneCell.h"
#import "JSONKit.h"
#import "AJDailyEarningRepayOut.h"

@interface AJDailyEarningRepayController ()<HTTPClientDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL isRepayBtnRequest;

@property(nonatomic, assign) int currPage;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, copy) NSString *transfer_status;
//@property(nonatomic ,copy)  NSString *investFileName;
@end

@implementation AJDailyEarningRepayController

- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)headerRereshing
{
    self.isRepayBtnRequest = NO;
    self.currPage = 1;
    [self sendRequestWithPage:self.currPage];
    
}
- (void)footerRereshing
{
     self.isRepayBtnRequest = NO;
    if ( ++self.currPage <= self.totalPage) {
        [self sendRequestWithPage:self.currPage];
    }else{
        self.tableView.footerRefreshingText = @"没有更多";
        [self.tableView footerEndRefreshing];
    }
}

- (void)sendRequestWithPage:(int)page
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"" forKey:@"body"];
    parameters[@"OPT"] = @"183";
    parameters[@"userId"] = AppDelegateInstance.userInfo.userId ;
    parameters[@"currPage"] = [NSString stringWithFormat:@"%@", @(page)];
    parameters[@"transfer_status"] = self.transfer_status;
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 如果数组为空则刷新
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = KblackgroundColor;
}

- (void)initView
{
    if ([self.title isEqualToString:@"转出审核管理"]) {
        self.transfer_status = @"0";
    }else{// 已还款列表，这里是确定请求参数
        self.transfer_status = @"2";
    }
}

#pragma  mark - UITableViewDalegate / UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJDailyEarningRepayOut *data = self.data[indexPath.section];
    if ([self.transfer_status isEqualToString:@"0"]) {//转出
        __weak typeof(self) weakSelf = self;
        AJDailyEarningRepayCell *cell = [AJDailyEarningRepayCell cellWithTableView:tableView block:^(NSString *Id) {
            [weakSelf sureRepayment:Id];
                   }];
        cell.aAJDailyEarningRepayOut = data;
        return cell;
    }else{ // 已完成
        AJDailyEarningRepayDoneCell *cell = [AJDailyEarningRepayDoneCell cellWithTableView:tableView];
        cell.aAJDailyEarningRepayOut = data;
        return cell;
    }
}

- (void)sureRepayment:(NSString *)applyId
{
    self.isRepayBtnRequest = YES;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"" forKey:@"body"];
    parameters[@"OPT"] = @"184";
    parameters[@"userId"] = AppDelegateInstance.userInfo.userId ;
    parameters[@"applyId"] = applyId;
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.transfer_status isEqualToString:@"0"])? 240.0f/2 : 135.f/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18.f/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

#pragma mark - HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

-(void) httpResponseSuccessWithParam:(NSDictionary *)param dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self tableViewHeaderFooterHiden];
    
    NSDictionary *dics = obj;
//    DLOG(@"===%@=======", [dics JSONString]);
//    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    if (self.isRepayBtnRequest == YES) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
    }else{
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
           
            NSArray *arr = dics[@"records"][@"page"];
//            DLOG(@"===%@=======", [arr JSONString]);
            NSNumber *totolCount = dics[@"records"][@"totalCount"];
            NSNumber *pageSize = dics[@"records"][@"pageSize"];
            if (self.currPage == 1) {
                [self.data removeAllObjects];
            }
           self.totalPage = [totolCount intValue]/[pageSize intValue] + 1;
            
            if (![arr isEqual:[NSNull null]] && arr.count>0) {
                for (NSDictionary *item in arr) {
                    AJDailyEarningRepayOut *transOut = [[AJDailyEarningRepayOut alloc] initWithDict:item];
                    
                    [self.data addObject:transOut];
                }
            }
            [self.tableView reloadData];
        }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
            
            [ReLogin outTheTimeRelogin:self];
            
        }else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
    }
}

// 返回失败
-(void) httpResponseFailureWithParam:(NSDictionary *)param dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self tableViewHeaderFooterHiden];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self tableViewHeaderFooterHiden];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}
- (void)tableViewHeaderFooterHiden
{
    UITableView *tableView =self.tableView;
    if (!tableView.isHeaderHidden) {
        [tableView headerEndRefreshing];
    }
    if (!tableView.isFooterHidden) {
        [tableView footerEndRefreshing];
    }
}
@end
