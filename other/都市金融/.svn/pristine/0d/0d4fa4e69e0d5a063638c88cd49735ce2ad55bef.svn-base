//
//  AJAddController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJAddController.h"
#import "AJAddCell.h"
#import "AJAddCellData.h"
#import "MJRefresh.h"
#import "JSONKit.h"

@interface AJAddController ()<HTTPClientDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, assign) int currPage;
@property (nonatomic, assign) int totalPage;
@end

@implementation AJAddController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.data.count == 0) {
        [self.tableView headerBeginRefreshing];
    }
}
- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    // 拦截外部设置
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {}
    return self;
}
- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.currPage = 1;
        [weakSelf sendRequestWithPage:weakSelf.currPage];
    }];
    [self.tableView addFooterWithCallback:^{
        if (++ weakSelf.currPage < weakSelf.totalPage) {
            [weakSelf sendRequestWithPage:weakSelf.currPage];
        }else{
            weakSelf.tableView.footerRefreshingText = @"没有更多";
            [weakSelf.tableView footerEndRefreshing];
        }
    }];
    
}

- (void)sendRequestWithPage:(int)page
{
    //2.1获取投资列表信息，包含投资列表。[OK]
    //        [_dataArrays removeAllObjects];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"" forKey:@"body"];
    //    [parameters setObject:@"179" forKey:@"OPT"];// 179日利宝首页信息
    parameters[@"OPT"] = @"180";
    parameters[@"userId"] = AppDelegateInstance.userInfo.userId ;
    parameters[@"currPage"] = [NSString stringWithFormat:@"%@", @(page)];
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sameDay = self.data[section];
    return sameDay.count + (sameDay.count-1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row + 1)% 2 ==0) { // 1/3/5/7/9 ...
        static NSString *separatorCellID = @"separatorCell";
        UITableViewCell *separatorCell = [tableView dequeueReusableCellWithIdentifier:separatorCellID];
        if (separatorCell == nil) {
            separatorCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:separatorCellID];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            separatorCell.selectionStyle = UITableViewCellSelectionStyleNone;
            separatorCell.backgroundColor = KblackgroundColor;
        }
        return separatorCell;
    }else{// 0/2/4/6/8/10
        AJAddCell *cell = [AJAddCell cellWithTableView:tableView];
        NSArray *sameDay = self.data[indexPath.section];
        NSInteger index = indexPath.row/2;
        cell.aAJAddCellData = sameDay[index];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.f/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row+1) %2 == 0) {
        return 16.f/2;
    }
    return 150.f/2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerReuseID = @"AJAddControllerSectionHeader";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseID];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerReuseID];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 32.f/2, 250, 36.f/2)];
        label.textColor = [ColorTools colorWithHexString:@"#969696"];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"2015-32-54";
        [view addSubview:label];
        label.tag = 5201314;
    }
    UILabel *label = [view viewWithTag:5201314];
    label.text = [[self.data[section] firstObject] transfer_time];
    return view;
}
//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    
//    header.textLabel.textColor = [ColorTools colorWithHexString:@"#969696"];
//    header.textLabel.frame = CGRectMake(50.f, header.textLabel.frame.origin.y, header.textLabel.frame.size.width, header.textLabel.frame.size.height);
//}

#pragma mark - HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", [dics JSONString]);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
// #warning 后台返回的数据是按顺序加载，下一页的交易记录的时间有比上一页的早，
        NSNumber *totolCount = dics[@"records"][@"totalCount"];
        NSNumber *pageSize = dics[@"records"][@"pageSize"];
        if (self.currPage == 1) {
            [self.data removeAllObjects];
        }
        self.totalPage = [totolCount intValue]/[pageSize intValue] + 1;
        for (NSDictionary *item in dics[@"records"][@"page"]) {
            AJAddCellData *data = [[AJAddCellData alloc] initWithDict:item];
            
            if (self.data.count == 0) {// self.data里面装着同一天下的记录数组
                 NSMutableArray *tempArr = [NSMutableArray array];
                [tempArr addObject:data];
                [self.data addObject:tempArr];
            }else{
                NSMutableArray *lastArr = self.data.lastObject;
                AJAddCellData *lastdata = lastArr.lastObject;
                if ([data.transfer_time isEqualToString:lastdata.transfer_time]) {
                    [lastArr addObject:data];
                }else{
                    NSMutableArray *tempArr = [NSMutableArray array];
                    [tempArr addObject:data];
                    [self.data addObject:tempArr];
                }
            }
        }
        [self.tableView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

@end
