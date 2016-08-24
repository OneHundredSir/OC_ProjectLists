//
//  AuditingViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心---》借款子账户----》 审核中借款标
#import "AuditingViewController.h"

#import "ColorTools.h"
#import "AuditingTableViewCell.h"

#import "BorrowingDetailsViewController.h"

#import "Auditing.h"

@interface AuditingViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
}

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AuditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"审核中的借款标";
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
    AuditingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AuditingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    Auditing *bean = _dataArrays[indexPath.section];

    cell.titleLabel.text = [bean title];
    
    [cell.typeView  sd_setImageWithURL:[NSURL URLWithString:bean.smallImageFilename]
                      placeholderImage:[UIImage imageNamed:@"default_head"]];
    cell.nopostLabel.text =  [NSString stringWithFormat:@"%ld",(long)bean.productItemCount];//未提交资料数
    cell.nopassLabel.text =  [NSString stringWithFormat:@"%ld",(long)bean.userItemCountTrue];// 未通过
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
// 跳转过去右上角新增一个撤销按钮，现在临时不加
//    ReviewBorrowingViewController *ReviewBorrowingView = [[ReviewBorrowingViewController alloc] init];
//    [self.navigationController pushViewController:ReviewBorrowingView animated:YES];
    BorrowingDetailsViewController *borrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    
    Auditing *bean = _dataArrays[indexPath.section];
    borrowingDetailsView.borrowID = [NSString stringWithFormat:@"%ld", (long)bean.auditingId];
    borrowingDetailsView.titleString = [bean title];
    borrowingDetailsView.stateNum = 1;
    [self.navigationController pushViewController:borrowingDetailsView animated:YES];

}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"90" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
    
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
//        [_tableView reloadData];
//
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self hiddenRefreshView];
//    });
}

#pragma

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

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if (_total == 1) {
            [_dataArrays removeAllObjects];
        }
        
        _total = [[dics objectForKey:@"totalNum"] intValue];// 总共多少条
        
        NSArray *dataArr = [dics objectForKey:@"page"];
        for (NSDictionary *item in dataArr) {
            Auditing *bean = [[Auditing alloc] init];
            bean.title = [item objectForKey:@"title"];
            bean.auditingId = [[item objectForKey:@"id"] intValue];
            
            if ([[item objectForKey:@"small_image_filename"] hasPrefix:@"http"]) {
                
                bean.smallImageFilename = [NSString stringWithFormat:@"%@", [item objectForKey:@"small_image_filename"]];
            }else{
                
                bean.smallImageFilename = [NSString stringWithFormat:@"%@%@", Baseurl, [item objectForKey:@"small_image_filename"]];
            }
          
            bean.productItemCount = [[item objectForKey:@"product_item_count"] intValue];// 未提交资料数
            bean.userItemCountTrue = [[item objectForKey:@"user_item_count_false"] intValue];// 未通过资料数
            
            [_dataArrays addObject:bean];
        }
        [_tableView reloadData];
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];        
    }else {
        // 服务器返回数据异常
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
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

#pragma Hidden View

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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
