//
//  HomeViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  首页
//

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


@interface HomeViewController ()<FocusImageFrameDelegate,HTTPClientDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArrays;
    
    NSMutableArray *_adArrays;
    
    NSInteger _typeNum;
    
 
}
@property (strong, nonatomic)  UITableView *tableView;

@property (nonatomic, strong)UIScrollView *scrollContent;

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
    
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //列表刷新通知注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"investRefresh" object:nil];
    
    // 初始化数据
    [self initData];
    
    [self readData];
    
    // 初始化视图
    [self initView];
    
//    [self requestData];
  
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
    _dataArrays = [[NSMutableArray alloc] init];
    _adArrays = [[NSMutableArray alloc] init];
    _tempArrays = [[NSMutableArray alloc] init];


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


/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    _scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, MSHIGHT)];
    _scrollContent.showsHorizontalScrollIndicator = NO;
    _scrollContent.showsVerticalScrollIndicator = NO;
//    [_scrollContent setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 48, 0)];
//    [_scrollContent setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    _scrollContent.backgroundColor = KblackgroundColor;
    [self.view addSubview:_scrollContent];
    
       _scrollContent.contentSize = CGSizeMake(MSWIDTH, MSHIGHT);
  
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWIDTH, 180)];
    headView.backgroundColor = [UIColor whiteColor];
    
    
    _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, 160) delegate:self imageItems:_adArrays isAuto:YES];
    _adScrollView.contentMode =  UIViewContentModeScaleAspectFit;
    [_scrollContent addSubview:_adScrollView];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5,160, MSWIDTH-10, MSHIGHT-160) style:UITableViewStyleGrouped];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 48, 0)];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    _tableView.backgroundColor = KblackgroundColor;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
//    _tableView.tableHeaderView = headView;
    [_scrollContent addSubview:_tableView];
    
     [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_scrollContent addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [self.scrollContent headerBeginRefreshing];
      [self headerRereshing];
    
}



- (void)initNavigationBar
{
    
    self.title = NSLocalizedString(@"Tab_Home_Title", nil);
    BarButtonItem *leftButton = [BarButtonItem barItemWithImage:[UIImage imageNamed:@"ic_account_normal"] selectedImage:[UIImage imageNamed:@"ic_account_normal"] target:self action:@selector(leftClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];// 左边导航按钮
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
   
    [self.navigationController.navigationBar setBarTintColor:KColor];

}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData];
    
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
{
    if(_typeNum == 1){
    [self readCache];
  }
}

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
            
        }
        else {
            
            DLOG(@"当前为最新版本");
        }
    }
  

}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
     if(_typeNum == 1){
       [self readCache];
    }
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
      if(_typeNum == 1){
            [self readCache];
    }
}


-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
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
                        AdvertiseGallery *bean = [[AdvertiseGallery alloc] init];
                        bean.title = [item objectForKey:@"title"];
                        if ([[item objectForKey:@"image_filename"] hasPrefix:@"http"]) {
                            
                            bean.image = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];
                            
                        }else {
                            
                            bean.image = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"image_filename"]];
                            
                        }
                        
                        bean.urlStr = [item objectForKey:@"url"];
                        bean.tag = [_tempArrays count] + 1;
                        [_tempArrays addObject:bean];
                        
                    }
                    [self readData];
                    [_adScrollView changeImageViewsContent:_adArrays];
                }
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"服务器返回数据错误！"];
                
            }
            

            //优质借款标
            if (![[dataDics objectForKey:@"qualityBids"] isEqual:[NSNull null]]) {
                
                NSArray *qualityArr = [dataDics objectForKey:@"qualityBids"];
                [_dataArrays removeAllObjects];
                
                if (qualityArr.count) {
                    for (NSDictionary *item in qualityArr) {
                        Investment *bean = [[Investment alloc] init];
                        bean.title = [item objectForKey:@"title"];
                        bean.borrowId = [item objectForKey:@"id"];
                        bean.imgurl = [NSString stringWithFormat:@"%@",[item objectForKey:@"bid_image_filename"]];
                        bean.levelStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"small_image_filename"]];
                        bean.progress = [[item objectForKey:@"loan_schedule"] floatValue];
                        bean.amount = [[item objectForKey:@"amount"] floatValue];
                        bean.rate = [[item objectForKey:@"apr"] floatValue];
                        bean.time = [item objectForKey:@"period"];
                        bean.isQuality = [[item objectForKey:@"is_hot"] boolValue];
                        bean.unitstr = [NSString stringWithFormat:@"%@",[item objectForKey:@"period_unit"]];
                        bean.borrowId = [item objectForKey:@"id"]; //借款标ID
                        bean.repayTypeStr = [item objectForKey:@"repayment_type_name"];
                        [_dataArrays addObject:bean];
                    }
                }
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"服务器返回数据错误！"];
                
            }
        if (_dataArrays.count) {
            _tableView.frame = CGRectMake(5,160, MSWIDTH-10, _dataArrays.count*190 + 165);
        }
        
        CGFloat sHeight = _dataArrays.count*190 + 314;
        
        _scrollContent.contentSize = CGSizeMake(MSWIDTH, MSHIGHT < sHeight?sHeight:(MSHIGHT+10));
        
        
        [_tableView reloadData];
        [self hiddenRefreshView];
        
        //升级检测
        [self upload];
        
    }else if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        if (!isCache) {
            // 非缓存数据才显示错误
            [self hiddenRefreshView];
        }
    }

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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cate_cell%ld",(long)indexPath.section];
    InvestmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[InvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.calculatorView.hidden = YES;
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    
    cell.showsReorderControl =YES;
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.layer.cornerRadius = 10.0f;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell fillCellWithObject:object];
    [cell.tenderBtn setTag:indexPath.section];
    if ((int)object.progress == 100) {
        
        cell.tenderBtn.userInteractionEnabled = NO;
    }else
        [cell.tenderBtn addTarget:self action:@selector(tenderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - 立即投标
- (void)tenderBtnClick:(UIButton *)btn
{
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin goLogin:self];
    }else {
        
        Investment *object = [_dataArrays objectAtIndex:btn.tag];
        
        [self.tabBarController.tabBar setHidden:YES];
        TenderOnceViewController *tenderOnceView = [[TenderOnceViewController alloc] init];
        tenderOnceView.borrowId = object.borrowId;
        [self.navigationController pushViewController:tenderOnceView animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3.5f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50.0f;
    }
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWIDTH, 50)];
        headView.backgroundColor = [UIColor whiteColor];
        //横条
        UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(20, 25, MSWIDTH-40, 1)];
        lineView.backgroundColor = [ColorTools colorWithHexString:@"#dbdbdb"];
        [headView addSubview:lineView];
        
        UIView *lineView2  = [[UIView alloc] initWithFrame:CGRectMake(20, 25, MSWIDTH-40, 1)];
        lineView2.backgroundColor = [ColorTools colorWithHexString:@"#dbdbdb"];
        [headView addSubview:lineView2];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(headView.frame)-120)*0.5, 14, 120, 20)];
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor orangeColor];
        label.text = @"优质标推荐";
        label.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:label];
        
        return headView;
    }else{
        return nil;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//返回时取消选中状态
    
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    if (![object.title isEqualToString:@"无数据"]) {
        BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
        BorrowingDetailsView.borrowID = object.borrowId;
        BorrowingDetailsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:BorrowingDetailsView animated:NO];
    }

    
    
}


#pragma mark - FocusImageFrameDelegate

- (void)foucusImageFrame:(AdScrollView *)imageFrame didSelectItem:(AdvertiseGallery *)item
{
    
    DLOG(@"广告栏选中%ld - %@",(long)item.tag, item.urlStr);
    
    if ([item.urlStr isEqual:[NSNull null]] || item.urlStr == nil || [item.urlStr isEqualToString:@""]) {
        
        DLOG(@"没有链接，禁止点击！");
        
    }else {
        
        AdWebViewController *adWebView = [[AdWebViewController alloc] init];
        adWebView.urlStr = item.urlStr;
        adWebView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adWebView animated:YES];
        
    }
    
     
}

- (void)foucusImageFrame:(AdScrollView *)imageFrame currentItem:(int)index
{
    //DLOG(@"当前广告图片%d",index);
}

#pragma mark - Button click

- (void)leftClick:(id)sender{
    if (AppDelegateInstance.userInfo == nil) {
        // 重新登录
        LoginViewController *loginView = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self presentViewController:navigationController animated:YES completion:nil];

    }else{
        
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        [self.frostedViewController presentMenuViewController];

    }
    
}


#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    if (AppDelegateInstance.userInfo == nil) {
        // 重新登录
        LoginViewController *loginView = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self presentViewController:navigationController animated:YES completion:nil];
        
        
    }else{
        
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        if ([sender velocityInView:self.view].x > 0 && [sender velocityInView:self.view].y == 0) {
            
            [self.frostedViewController presentMenuViewController];
        }
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            DLOG(@"更新中...");
            
            NSURL *url;
            if ([Baseurl isEqualToString:@"http://www.niumail.com.cn"]) {
                
                url =  [NSURL URLWithString:@"https://appstore.qiwangyun.com/lab/sp2p_gw/download.html"];
            }else if([Baseurl isEqualToString: @"http://www.niumail.com"]){
                
                url = [NSURL URLWithString:@"https://appstore.qiwangyun.com/lab/sp2p/download.html"];
                
            }
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    
    
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_scrollContent.isHeaderHidden) {
        [_scrollContent headerEndRefreshing];
    }
    
    if (!_scrollContent.isFooterHidden) {
        [_scrollContent footerEndRefreshing];
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
