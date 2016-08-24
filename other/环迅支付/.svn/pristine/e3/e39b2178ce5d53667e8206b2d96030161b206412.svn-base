//
//  SP2P_7
//
//  Created by Jerry on 14-8-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  债权转让(转让) -> 竞拍记录

#import "AuctionRecordTwoViewController.h"
#import "ColorTools.h"
#import "AuctionRecordCell.h"

#import "AuctionRecordTwo.h"

@interface AuctionRecordTwoViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{

    NSArray *titleArr;
    
    NSMutableArray *_collectionArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数

}

@property (nonatomic, strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AuctionRecordTwoViewController


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
    
    titleArr = @[@"竞拍人",@"竞拍出价",@"竞拍时间"];
    _currPage = 1;
    _collectionArrays =[[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 104)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i<[titleArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake((self.view.frame.size.width/3)*i, 62, self.view.frame.size.width/3, 44);
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [backView addSubview:titleLabel];
        
    }
    
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.scrollEnabled = YES;
    _listView.dataSource = self;
    [self.view  addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"竞拍记录";
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
    return 35.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    AuctionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AuctionRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.nameLabel.text = @"JESSECA";
//    cell.bidLabel.text = @"200.00";
//    cell.timeLabel.text = @"2014-6-6";
    
    AuctionRecordTwo *auction = _collectionArrays[indexPath.section];
    cell.nameLabel.text = auction.name;
    cell.bidLabel.text = auction.offerPrice;
    cell.timeLabel.text = auction.time;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
        
        [parameters setObject:@"52" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_creditorId forKey:@"sign"];
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
 
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    NSDictionary *dics = obj;
            DLOG(@"返回成功  msg -> %@",dics);
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        NSArray *collections = [obj objectForKey:@"list"];
        for (NSDictionary *item in collections) {
            AuctionRecordTwo *bean = [[AuctionRecordTwo alloc] init];
            
            if( [item objectForKey:@"time"] != nil &&![[item objectForKey:@"time"] isEqual:[NSNull null]])
            {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[item objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
                [dataFormat setDateFormat:@"yyyy-MM-dd"];
                
                bean.time = [NSString stringWithFormat:@"%@",[dataFormat stringFromDate: date]] ;
            }else
                bean.time = @"";
            bean.offerPrice = [NSString stringWithFormat:@"%@",[item objectForKey:@"offer_price"]];
            bean.name = [NSString stringWithFormat:@"%@",[item objectForKey:@"name"]];
            
            [_collectionArrays addObject:bean];
            
            DLOG(@"time -> %@", bean.time);
            DLOG(@"name -> %@", bean.name);
        }
        
        // 有数据后启用。
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
    // 服务器返回数据异常
     [self hiddenRefreshView];
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
    
    [_collectionArrays removeAllObjects];// 清空全部数据
    
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
