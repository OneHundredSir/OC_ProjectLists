//
//  FullScaleViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》理财子账户————》等待满标
#import "FullScaleViewController.h"

#import "ColorTools.h"
#import "AuditingLoanCell.h"
#import "BorrowingDetailsViewController.h"

#import "Tender.h"

@interface FullScaleViewController ()<UITableViewDelegate,UITableViewDataSource, HTTPClientDelegate> {
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
}

@property (nonatomic,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation FullScaleViewController

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
   // [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"等待满标的理财标";
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
    
    return [_dataArrays count];
    
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
    AuditingLoanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AuditingLoanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    Tender *bean = _dataArrays[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = [bean title];
    cell.typeView.image = [UIImage imageNamed:[bean smallImageFilename]];
    
    cell.nopostLabel.text = [NSString stringWithFormat:@"%ld", (long)[bean productItemCount]];
    cell.nopassLabel.text = [NSString stringWithFormat:@"%ld", (long)[bean userItemCountTrue]];
    [cell.typeView sd_setImageWithURL:[NSURL URLWithString:[bean smallImageFilename]]];
    cell.roundimgView.image = [UIImage imageNamed:@"round_back"];
    cell.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)[bean loanSchedule]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BorrowingDetailsViewController *borrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    Tender *bean = _dataArrays[indexPath.section];
    borrowingDetailsView.borrowID = [NSString stringWithFormat:@"%ld", (long)[bean tenderId]];
    borrowingDetailsView.titleString = [bean title];
    borrowingDetailsView.progressnum = [bean loanSchedule];
    borrowingDetailsView.stateNum = 0;
    
    [self.navigationController pushViewController:borrowingDetailsView animated:YES];
    
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
        
        [parameters setObject:@"41" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:@"1" forKey:@"currPage"];
        
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
    [self hiddenRefreshView];

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
        
        _total = [[dics objectForKey:@"totalNum"] intValue];// 总共多少条
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        for (NSDictionary *item in dataArr) {
            Tender *tender = [[Tender alloc] init];
            tender.title = [item objectForKey:@"title"];
            tender.tenderId = [[item objectForKey:@"bid_id"] intValue];
            tender.productItemCount = [[item objectForKey:@"product_item_count"] intValue];// 未提交资料数
            tender.userItemCountTrue = [[item objectForKey:@"user_item_count_true"] intValue];// 未通过资料数
            tender.loanSchedule = [[item objectForKey:@"loan_schedule"] floatValue];// 投标进度
            
            if ([item objectForKey:@"image_filename"]!= nil && ![[item objectForKey:@"image_filename"]isEqual:[NSNull null]])
            {
                if ( [[item objectForKey:@"image_filename"] hasPrefix:@"http"]) {
                    
                    tender.smallImageFilename = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];//借款标类型
                }else{
                    
                    tender.smallImageFilename = [NSString stringWithFormat:@"%@%@", Baseurl, [item objectForKey:@"image_filename"]];//借款标类型
                    
                }
            }
            
            [_dataArrays addObject:tender];
            
            DLOG(@"title -> %@", tender.title);
            DLOG(@"title -> %@", tender.smallImageFilename);
        }
        
        // 刷新表格
        [_listView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self hiddenRefreshView];
        
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
    
    [self requestData];
}


- (void)footerRereshing
{
    
    _currPage++;
    
    
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
