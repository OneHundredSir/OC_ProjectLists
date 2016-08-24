//
//  HomeViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  首页
//
#define kHeaderHeight (40 + 88 - 26 + 282 + 16)/2.f + (80 + 30)/2.f
#import "HomeViewController.h"

#import "BarButtonItem.h"

#import "ColorTools.h"

#import "HomeListView.h"

#import "Investment.h"

#import "AdvertiseGallery.h"

#import "AdWebViewController.h"

#import "UIScrollView+MJRefresh.h"

#import "CacheUtil.h"
#import "InvestmentTableViewCell.h"
#import "BorrowingDetailsViewController.h"
#import "LoginViewController.h"
#import "TenderOnceViewController.h"
#import "AdvertiseGallery.h"
#import "AJHomeHeaderView.h"
#import "AJHomeCell.h"
#import "RegistrationViewController.h"
#import "JSONKit.h"

@interface HomeViewController ()<HTTPClientDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_adArrays;
    
    NSInteger _typeNum;//
}
@property (weak, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) Investment *bidInfo;
//@property (nonatomic, weak)UIScrollView *scrollContent;

@property (nonatomic, strong) NSMutableArray* tempArrays;

@property (nonatomic, strong) NSMutableArray  *qualityInfoArr;
@property (nonatomic, strong) NSMutableArray  *fullInfoArr;

@property (nonatomic, strong) NSMutableArray  *qualityDataArr;
@property (nonatomic, strong) NSMutableArray  *fullDataArr;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property(nonatomic, copy) NSString *cacheFileName;

@property (nonatomic, strong) NSMutableArray *qualityIdArr;
@property (nonatomic, strong) NSMutableArray *fullyIdArr;
@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden = YES;
    
     AJHomeHeaderView *header = (AJHomeHeaderView *)self.tableView.tableHeaderView;
//    header.backgroundColor = [UIColor redColor];
    if (AppDelegateInstance.userInfo &&  header.loginRegister.hidden == NO) {
       
        header.loginRegister.hidden = YES;
        CGRect frame = header.frame;
        frame.size.height -= 55.f;
        header.frame = frame;
        self.tableView.tableHeaderView = header;
    }else if(!AppDelegateInstance.userInfo && header.loginRegister.hidden){
        
        header.loginRegister.hidden = NO;
        CGRect frame = header.frame;
        frame.size.height += 55.f;
        header.frame = frame;
 
        self.tableView.tableHeaderView = header;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 隐藏导航栏
  
    //列表刷新通知注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"investRefresh" object:nil];
    
    // 初始化数据
    [self initData];
    
//    [self readData];
    // 初始化视图
    [self initView];
}

- (void)readData
{
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:_tempArrays.count+2];
    //添加最后一张图 用于循环
    if (_tempArrays.count > 1)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:_tempArrays.count-1];
        bean.tag = -1;
        [itemArray addObject:bean];
    }
    
    for (int i = 0; i < _tempArrays.count; i++)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:i];
        [itemArray addObject:bean];
    }

    //添加第一张图 用于循环
    if (_tempArrays.count >1)
    {
        AdvertiseGallery *bean = [_tempArrays objectAtIndex:0];
        bean.tag = _tempArrays.count;
        [itemArray addObject:bean];
    }
    
    [_adArrays addObjectsFromArray:itemArray];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    _typeNum = 0;
    if (!_adArrays)  _adArrays = [[NSMutableArray alloc] init];
    if (!_tempArrays)  _tempArrays = [[NSMutableArray alloc] init];

}

bool isUpdate = YES;
#pragma mark 版本更新
-(void) upload
{
    if (isUpdate) {
    isUpdate = NO;
    DLOG(@"版本更新");
    _typeNum = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"127" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"2" forKey:@"deviceType"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
        
    }else return;
}

- (void)initView
{
    // 1.展示列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
    tableView.backgroundColor = KblackgroundColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    // 头部视图
    AJHomeHeaderView *header = [[AJHomeHeaderView alloc] initWithHeight:kHeaderHeight imageItems:_adArrays];
    __weak typeof(self) weakSelf = self;
    header.loginRegisterBlock = ^(UIButton *sender){
        if ([sender.titleLabel.text isEqualToString:@"登录"]) {
            // 1.已登录时
            // 2.未登录时
            // 重新登录
            LoginViewController *loginView = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginView animated:YES];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginView];
//            [self presentViewController:navigationController animated:YES completion:nil];

        }else if ([sender.titleLabel.text isEqualToString:@"注册"]){
            // 1.已登录时
            // 2.未登录时
            RegistrationViewController *regView = [[RegistrationViewController alloc] init];
            [self.navigationController pushViewController:regView animated:YES];
        }
    };
    header.tapImgBlock = ^(AdvertiseGallery *item){
        if ([item.urlStr isEqual:[NSNull null]] || item.urlStr == nil || [item.urlStr isEqualToString:@""]) {
            DLOG(@"没有链接，禁止点击！");
        }else {
            AdWebViewController *adWebView = [[AdWebViewController alloc] init];
            adWebView.urlStr = item.urlStr;
            adWebView.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:adWebView animated:YES];
        }

    };
    tableView.tableHeaderView = header;
    // 下拉刷新
    [self.tableView addHeaderWithCallback:^{
        [weakSelf requestData];
    }];
//    [self.tableView headerBeginRefreshing];
    [weakSelf requestData];
}

-(void)requestData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //5 app首页（opt=132）
    _typeNum = 1;
    [parameters setObject:@"122" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"" forKey:@"id"]; //栏目id
    
    _cacheFileName = [CacheUtil creatCacheFileName:parameters];
//    DLOG(@"dfjdfkjdk is %@",_cacheFileName);
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    if(_typeNum == 1){
           [self processData:obj isCache:NO];// 读取当前请求到的数据
        
    }else if(_typeNum == 2){
        // 获取服务器版本
        NSString *version = [obj objectForKey:@"version"];
        if (codeNum < [[obj objectForKey:@"code"] integerValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"有最新的版本%@，是否前往更新？", version] delegate:self cancelButtonTitle:@"下次更新" otherButtonTitles:@"马上更新", nil];
            alert.tag = 10000;
            [alert show];
        }else {
            DLOG(@"当前为最新版本");
        }
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self.tableView headerEndRefreshing];
     if(_typeNum == 1){
       [self readCache];
    }
}

// 无可用的网络
-(void) networkError
{
    [self.tableView headerEndRefreshing];
      if(_typeNum == 1){
            [self readCache];
    }
}

-(void)processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    DLOG(@"dataDics is %@",dataDics);
   
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"])
    {
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_cacheFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
        }
        //广告滚动条.
        if (![[dataDics objectForKey:@"homeAds"] isEqual:[NSNull null]]) {
            
            NSArray *dataArr = [dataDics objectForKey:@"homeAds"];
            if ([dataArr count]!=0) {
                [_adArrays removeAllObjects];
                [_tempArrays removeAllObjects];
                for (NSDictionary *item in dataArr)
                {
                    AdvertiseGallery *bean = [[AdvertiseGallery alloc] initWithDict:item];
                    [_tempArrays addObject:bean];
                }
                [self readData];
                AJHomeHeaderView *header = (AJHomeHeaderView*)self.tableView.tableHeaderView;
                [header updateViewsContent:_adArrays];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:@"服务器返回广告业数据错误！"];
            
        }
        //优质借款标
        NSDictionary *bidInfoDic = [dataDics objectForKey:@"onceBid"];
        if (![bidInfoDic isEqual:[NSNull null]] && bidInfoDic.count > 0) {
            DLOG(@"%@", [dataDics objectForKey:@"onceBid"]);
            DLOG(@"%@", [dataDics JSONString]);
            _bidInfo = [[Investment alloc] initWithDict:[dataDics objectForKey:@"onceBid"]];
             [_tableView reloadData];

        }else {
            [SVProgressHUD showImage:nil status:@"暂无数据！"];
        }
        //升级检测
        [self upload];
        
    }else if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        if (!isCache) {
            // 非缓存数据才显示错误
            [SVProgressHUD showErrorWithStatus:@"服务器返回数据错误！"];
        }
    }
    
    [self.tableView headerEndRefreshing];
}

-(void) readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_cacheFileName];// 合成归档保存的完整路径
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bidInfo?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    AJHomeCell *cell = [AJHomeCell cellWithTableView:tableView btnClickBlock:^{
        // 点击投标
//        if (100 - weakSelf.bidInfo.progress <= 0.001) {
            TenderOnceViewController *tenderOnceView = [[TenderOnceViewController alloc] init];
            tenderOnceView.borrowId = weakSelf.bidInfo.borrowId;
            [weakSelf.navigationController pushViewController:tenderOnceView animated:YES];
//        }
    }];
    cell.aInvestment = _bidInfo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 618.f/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.f/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f/2;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//返回时取消选中状态
    if (![_bidInfo.title isEqualToString:@"无数据"]) {
        BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
        BorrowingDetailsView.borrowID = _bidInfo.borrowId;
        [self.navigationController pushViewController:BorrowingDetailsView animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            DLOG(@"更新中...");
            
            NSURL *url;
            if ([Baseurl isEqualToString:@"http://119.29.117.101"]) {
                
                url =  [NSURL URLWithString:@"https://appstore.qiwangyun.com/lab/sp2p_gw/download.html"];
            }else if([Baseurl isEqualToString: @"http://www.niumail.com"]){
                
                url = [NSURL URLWithString:@"https://appstore.qiwangyun.com/lab/sp2p/download.html"];
                
            }
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = NO;
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
