//
//  CompletedViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》理财子账户————》已完成

#import "CompletedViewController.h"

#import "ColorTools.h"
#import "UIFolderTableView.h"
#import "CompletedFinancialCell.h"

#import "FinancialComplete.h"
#import "BorrowingDetailsViewController.h"
#import "NSString+Date.h"

@interface CompletedViewController ()<UIFolderTableViewDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate> {
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
    
    NSString *_borrowID;
}

@property (nonatomic,strong) UIFolderTableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation CompletedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    _borrowID = @"";
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
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
    self.title = @"已完成的理财标";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _dataArrays.count;
    
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
    return 65.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.section];
    CompletedFinancialCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[CompletedFinancialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FinancialComplete *complate = _dataArrays[indexPath.section];
    cell.titleLabel.text = complate.title;
    cell.stateImg.image = [UIImage imageNamed:@"state_finish"];
    cell.typeImg.image = [UIImage imageNamed:@"state_cast"];
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.f", complate.bidAmount];
    
    UIButton *expanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expanBtn.frame = CGRectMake(self.view.frame.size.width - 30, 25, 25, 25);
    [expanBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
    [expanBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateSelected];
    [expanBtn setTag:indexPath.section + 1];
    [cell addSubview:expanBtn];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FinancialComplete *complate = _dataArrays[indexPath.section];
    _borrowID = [NSString stringWithFormat:@"%ld", (long)complate.bidId];
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)_listView;
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 135)];
    dropView.backgroundColor = [UIColor whiteColor];
    
    // 注册点击事件
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tapR.numberOfTouchesRequired = 1;
    tapR.numberOfTapsRequired = 1;
    [dropView addGestureRecognizer:tapR];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, dropView.frame.size.width + 100, 2)];
    line.text = @"------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    [dropView addSubview:line];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, dropView.frame.size.width, 20)];
    moneyLabel.text = [NSString stringWithFormat:@"借款金额: ￥%.2f", complate.bidAmount];
    moneyLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    moneyLabel.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel];
    
    UILabel *moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, dropView.frame.size.width, 20)];
    moneyLabel2.text = [NSString stringWithFormat:@"年利率: %d%%", complate.apr];
    moneyLabel2.font = [UIFont boldSystemFontOfSize:14.0f];
    moneyLabel2.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel2];
    
    UILabel *moneyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, dropView.frame.size.width, 20)];
    moneyLabel3.text = [NSString stringWithFormat:@"本息合计应收: ￥%.2f", complate.receivingAmount];
    moneyLabel3.font = [UIFont boldSystemFontOfSize:14.0f];
    moneyLabel3.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel3];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 83, dropView.frame.size.width, 20)];
    stateLabel.text = [NSString stringWithFormat:@"成功收款时间: %@", complate.repaymentTime];
    stateLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    stateLabel.textColor = [UIColor grayColor];
    [dropView addSubview:stateLabel];
    
    UILabel *wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 108, dropView.frame.size.width, 20)];
    wayLabel.text = [NSString stringWithFormat:@"逾期账单: %d", complate.overduePaybackPeriod];
    wayLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    wayLabel.textColor = [UIColor grayColor];
    [dropView addSubview:wayLabel];
    
    UITableViewCell *cell1 = [_listView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell1 viewWithTag:indexPath.section + 1];
    
    DLOG(@"%d", btn.selected);
    if (btn.selected == 0) {
        btn.selected = 1;
    }
    
    DLOG(@"Click - %d", btn.selected);
    
    _listView.scrollEnabled = NO;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:dropView
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                     
                                     btn.selected = !btn.selected;
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                    //[self CloseAndOpenACtion:indexPath];
                                }
                           completionBlock:^{
                               _listView.scrollEnabled = YES;
                           }];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

#pragma 点击展开跳转到账单详情页面
- (void)tapClick {
    DLOG(@"_borrowID ->%@", _borrowID);
    
    BorrowingDetailsViewController *borrowD = [[BorrowingDetailsViewController alloc] init];
    borrowD.borrowID = _borrowID;
    borrowD.stateNum = 5;
    [self.navigationController pushViewController:borrowD animated:YES];
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"44" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
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
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        // 清空全部数据
        if (_total == 1) {
            [_dataArrays removeAllObjects];
        }
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        for (NSDictionary *item in dataArr) {
            FinancialComplete *complate = [[FinancialComplete alloc] init];
            complate.title = [item objectForKey:@"title"];
            complate.bidAmount = [[item objectForKey:@"bid_amount"] floatValue];                         // 借款金额
            complate.investAmount = [[item objectForKey:@"invest_amount"] floatValue];                   // 投标金额
            complate.receivingAmount = [[item objectForKey:@"receiving_amount"] floatValue];             // 本息合计应收金额
            complate.apr = (int)[[item objectForKey:@"apr"] integerValue];  // 年利率
            complate.hasReceivedAmount = [[item objectForKey:@"has_received_amount"] floatValue];        // 已收金额
            complate.remainingAmount = complate.receivingAmount - complate.hasReceivedAmount;            // 剩余应收款
            complate.overduePaybackPeriod = [[item objectForKey:@"overdue_payback_period"] intValue];    // 逾期未还账单
            complate.bidId = [[item objectForKey:@"bid_id"] integerValue];
            
            if ([item objectForKey:@"last_repay_time"] != nil && ![[item objectForKey:@"last_repay_time"] isEqual:[NSNull null]]) {
                complate.repaymentTime = [NSString converDate:[[item objectForKey:@"last_repay_time"] objectForKey:@"time"] withFormat:@"MM/dd"];
            }
            
            [_dataArrays addObject:complate];
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
     [self hiddenRefreshView];
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];

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
    
//    [_dataArrays removeAllObjects];// 清空全部数据
    
    [self requestData];
}


- (void)footerRereshing
{    _currPage++;
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