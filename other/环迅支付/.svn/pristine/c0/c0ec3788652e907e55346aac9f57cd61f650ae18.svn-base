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
#import "CreditScreenViewController.h"
#import "CacheUtil.h"
#import "LoginViewController.h"
#import "AuctionViewController.h"

#define kSortHeight 40.0
#define kIS_IOS7                (kCFCoreFoundationVersionNumber> kCFCoreFoundationVersionNumber_iOS_6_1)

@interface TransferViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,HTTPClientDelegate>
{
    NSMutableArray *_sortArrays;// 排序View集合
    
    SortItemGrop *_sortGrop;
    
    NSMutableArray *_dataArrays;
    
    CreditScreenViewController *ScreenView;
    UINavigationController *ScreenViewNV;
    
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

@end

@implementation TransferViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    [self headerRereshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //通知检测对象
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(transferScreen:) name:@"screen2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"AuctionRefresh" object:nil];
    
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
//    [self readData];
}


- (void)readData
{

    

}



/**
 初始化数据
 */
- (void)initData
{
    _orderStr = @"0";
    _dataArr = [[NSMutableArray alloc] init];
    _dataArrays =[[NSMutableArray alloc] init];
//    _sortContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, kSortHeight)];
//    _sortContentView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_sortContentView];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _sortContentView.frame.origin.y + _sortContentView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _sortContentView.frame.size.height -_sortContentView.frame.origin.y-49) style:UITableViewStyleGrouped];
     _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 64, self.view.frame.size.width-10, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundColor = KblackgroundColor;
    [self.view addSubview:_tableView];
    
    _sortArrays = [[NSMutableArray alloc] init];
    
    NSArray *sortArrays = [NSArray arrayWithObjects:NSLocalizedString(@"Sort_Default", nil), NSLocalizedString(@"Sort_Capital", nil), NSLocalizedString(@"Sort_Rate", nil), NSLocalizedString(@"Sort_Time", nil), NSLocalizedString(@"Sort_Quality_Creditor", nil), nil];
    CGFloat widthCount = 0;
    for (NSString *name in sortArrays) {
        CGSize text = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        widthCount += text.width;
    }
    CGFloat frameWidth = 0;
    for (NSString *name in sortArrays) {
        CGSize text = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        CGFloat divideWidth = (self.view.frame.size.width - (widthCount + SORT_IMAGE_WIDTH*(sortArrays.count-1)))/(sortArrays.count+1);
        SortState state;
        CGFloat viewWidth;
        if([sortArrays indexOfObject:name] == 0 )
        {
            state = SortNone;
            viewWidth  = text.width;
        }else {
            state = SortDesc;
            viewWidth  = text.width + SORT_IMAGE_WIDTH;
        }
        frameWidth += divideWidth;
        SortItem *sortView;
        if([sortArrays indexOfObject:name] == 0 )
        {
            sortView = [[SortItem alloc] initWithFrame:CGRectMake(frameWidth+2, 0, viewWidth, kSortHeight) andName:name sortImage:@"sort_desc" state:state];
            sortView.nameLabel.textColor = PinkColor;
        }else{
            
            sortView = [[SortItem alloc] initWithFrame:CGRectMake(frameWidth+6, 0, viewWidth, kSortHeight) andName:name sortImage:@"sort_desc" state:state];
            
        }
        
        UILabel *linelabel = [[UILabel alloc] init];
        linelabel.backgroundColor = [UIColor lightGrayColor];
        if([sortArrays indexOfObject:name] != 4)
        {
            linelabel.frame = CGRectMake(frameWidth+viewWidth+9, 11, 0.2, kSortHeight-22);
            
        }

        
        if(state == SortNone){
            frameWidth += text.width;
        }else {
            frameWidth += (text.width + SORT_IMAGE_WIDTH) ;
        }
        
        [_sortArrays addObject:sortView];
        [_sortContentView addSubview:sortView];
        [_sortContentView addSubview:linelabel];
    }
    
    _sortGrop = [[SortItemGrop alloc] initWithFrame:CGRectMake(0, kSortHeight - 4.0, 320, 4) sortArrays:_sortArrays defaultPosition:0];
    int i=0;
    for (SortItem *sortView in _sortArrays) {
        [sortView setTag:i];
        [sortView addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
    
    [_sortContentView addSubview:_sortGrop];

}




/**
 初始化数据
 */
- (void)initView
{
    self.title = NSLocalizedString(@"Tab_Transfer", nil);
    self.view.backgroundColor = KblackgroundColor;
    [self initNavigationBar];
    
    
    //搜索
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 200, 35)];
    _searchBar.delegate = self;
    _searchBar.barStyle =  UIBarStyleDefault;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.placeholder = @"查找";
    _searchBar.keyboardType =  UIKeyboardTypeDefault;
    [_searchBar setBackgroundImage:[[UIImage alloc] init]];
    self.navigationItem.titleView = _searchBar;
    
    // 提取搜索框，空值也可以点击软键盘搜索键
    // 退出软键盘
    for (UIView *subview in _searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                textField.enablesReturnKeyAutomatically = NO;
                
                break;
            }
        }
    }
    
     [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    ScreenView = [[CreditScreenViewController alloc] init];
    ScreenViewNV = [[UINavigationController alloc] initWithRootViewController:ScreenView];
    
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData:_orderStr];
}


-(void)requestData:(NSString*)orderTypeStr
{

    _num = 0;
    _num2 = 0;
    _currPage = 1;
    _searchBar.text = nil;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取债权转让列表信息，包含债权转让列表 (opt=30)
    [parameters setObject:@"30" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"debtAmount"]; //借款金额
    [parameters setObject:@"" forKey:@"loanType"];    //借款类型
    [parameters setObject:orderTypeStr forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    if (_dataArr.count) {
        
        _num = 2;
        _num2 = 0;
        [parameters setObject:[_dataArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:[_dataArr objectAtIndex:1]  forKey:@"debtAmount"]; //借款金额
        [parameters setObject:[_dataArr objectAtIndex:2]  forKey:@"loanType"];    //借款类型
        [parameters setObject:@"0" forKey:@"orderType"];  //排序类型
        [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    }
    
    
    _transferFileName = [CacheUtil creatCacheFileName:parameters];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        //(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self.tableView headerEndRefreshing];
//    });

}

- (void)footerRereshing
{
    _num2 = 1 ;
    _currPage++;
      NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取债权转让列表信息，包含债权转让列表 (opt=30)
    [parameters setObject:@"30" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"debtAmount"]; //借款金额
     [parameters setObject:@"" forKey:@"loanType"];    //借款类型
    [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    DLOG(@"债权转让加载更多的页数为 is %ld",(long)_currPage);
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

    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
//    //2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self.tableView footerEndRefreshing];
//    });
}



- (void)initNavigationBar
{
    BarButtonItem *leftButton = [BarButtonItem barItemWithImage:[UIImage imageNamed:@"ic_account_normal"] selectedImage:[UIImage imageNamed:@"ic_account_normal"] target:self action:@selector(leftClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];// 左边导航按钮
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:KColor];
    
    UIBarButtonItem *ScreenItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(ScreenClick)];
    ScreenItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:ScreenItem];

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
        
        if ([[dataDics objectForKey:@"list"] count] == 0)
        {
            
            if(_num2 == 0){
                switch (_num) {
                        
                    case 0:
//                        [SVProgressHUD showErrorWithStatus:@"无数据"];
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
        
            for (NSDictionary *item in dataArr) {
                
                CreditorTransfer *bean = [[CreditorTransfer alloc] init];
                bean.title = [item objectForKey:@"title"];
                bean.apr = [item objectForKey:@"apr"];
                
                if([item objectForKey:@"end_time"]  != nil && ![[item objectForKey:@"end_time"]  isEqual:[NSNull null]])
                {
                //剩余时间
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"end_time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
                NSDate *senddate=[NSDate date];
                //结束时间
                NSDate *endDate = date;
                //当前时间
                NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
                //得到相差秒数
                NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
                int days = ((int)time)/(3600*24);
                int hours = ((int)time)%(3600*24)/3600;
                int minute = ((int)time)%(3600*24)%3600/60;
//                int seconds = ((int)time)%(3600*24)%3600%60;
                //            DLOG(@"相差时间 天:%i 时:%i 分:%i",days,hours,minute);
                    bean.time = [NSString stringWithFormat:@"%d天%d时%d分",days,hours,minute];
                if (days > 0){
//                    bean.time = [[NSString alloc] initWithFormat:@"%i",days];
//                    bean.sortTime = (int)time;
//                    bean.units =@"天";
                }else  if (hours > 0){
                    
//                    bean.time = [[NSString alloc] initWithFormat:@"%i",hours];
//                    bean.sortTime = (int)time;
//                    bean.units =@"时";
                    
                }else if (minute > 0){
//                    bean.time = [[NSString alloc] initWithFormat:@"%i",minute];
//                    bean.sortTime = (int)time;
//                    bean.units =@"分";
                }
                else if (minute <= 0)
                {
                    bean.time = [[NSString alloc] initWithFormat:@"%i",0];
                    bean.sortTime = (int)time;
                    bean.units =@"秒";
                    
                }
                    
                }
                //还款时间
                if ([item objectForKey:@"repayment_time"]  != nil && ![[item objectForKey:@"repayment_time"]  isEqual:[NSNull null]]) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"repayment_time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
                    NSDate *senddate=[NSDate date];
                    //结束时间
                    NSDate *endDate =  [dateFormat dateFromString:[dateFormat stringFromDate:date]];
                    //当前时间
                    NSDate *senderDate = [dateFormat dateFromString:[dateFormat stringFromDate:senddate]];
                    //得到相差秒数
                    bean.repaytime = (int)[endDate timeIntervalSinceDate:senderDate];
                }else{
                    
                    bean.repaytime = 0;
                }
                
                
                
                bean.creditorId = [[item objectForKey:@"id"] intValue];
                bean.content = [item objectForKey:@"transfer_reason"];
                bean.principal = [[item objectForKey:@"debt_amount"] floatValue];
                bean.minPrincipal = [[item objectForKey:@"transfer_price"] floatValue];
                bean.currentPrincipal = [[item objectForKey:@"max_price"] floatValue];
                bean.isQuality = [[item objectForKey:@"is_quality_debt"] boolValue];
                bean.joinNumStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"join_times"]];
                //             bean.isQuality = YES;
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
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
    
}

#pragma  mark 筛选触发方法
-(void)transferScreen:(NSNotification*)notification
{
    
   _dataArr = (NSMutableArray *)[notification object];
    
    _num = 2;
    _num2 = 0;
    _currPage = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取债权转让列表信息，包含债权转让列表 (opt=30)
    [parameters setObject:@"30" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[_dataArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:[_dataArr objectAtIndex:1]  forKey:@"debtAmount"]; //借款金额
    [parameters setObject:[_dataArr objectAtIndex:2]  forKey:@"loanType"];    //借款类型
    [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        //(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
////        [self.tableView headerEndRefreshing];
//    });
    

}



#pragma mark -
#pragma 排序方法
bool isclick1 = YES;
bool isclick2 = YES;
bool isclick3 = YES;
bool isclick4 = YES;
bool isclick5 = YES;
- (void)itemClick:(SortItem *)sender
{
    
    DLOG(@"id is %ld",(long)sender.tag);
    switch (sender.tag) {
        case 0:{
            if (isclick1) {
                _orderStr = @"0";
                [self requestData:_orderStr];
                [sender setState:SortAsc];
            }
            //遍历选项
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;

        }
            
            break;
        case 1:
        {
            if (isclick2) {
                [sender setState:SortDesc];
                isclick2=NO;
                _orderStr = @"1";
            }
            else
            {
                
                [sender setState:SortAsc];
                isclick2=YES;
                _orderStr = @"2";
            }
             [self requestData:_orderStr];
            
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;
            
            
        }
            break;
        case 2:
        {
        
                    if (isclick3) {
                        [sender setState:SortDesc];
                        isclick3=NO;
                        _orderStr = @"3";
                        
                    }
                    else
                    {

                        [sender setState:SortAsc];
                        isclick3=YES;
                        _orderStr = @"4";
                    }
           
                [self requestData:_orderStr];
                for (SortItem *sortView in _sortArrays) {
                    
                    sortView.nameLabel.textColor = [UIColor blackColor];
                }
                sender.nameLabel.textColor = PinkColor;
            
            
        }
            
            break;
        case 3:
            
        {
            if (isclick4) {

                [sender setState:SortDesc];
                isclick4=NO;
                _orderStr = @"5";
            }
            else
            {

                [sender setState:SortAsc];
                isclick4=YES;
                 _orderStr = @"6";
            }
            
           [self requestData:_orderStr];
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;
            
            
        }
            break;
        case 4:
        {
            
            if (isclick5) {
                [sender setState:SortDesc];
                isclick5=NO;
                 _orderStr = @"7";
                
            }
            else
            {

                [sender setState:SortAsc];
                isclick5=YES;
                 _orderStr = @"8";
            }
            [self requestData:_orderStr];
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;
            
            
        }
            
            break;
    }
    [_tableView reloadData];
    
}


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

#pragma mark 筛选按钮

- (void)ScreenClick
{
//    DLOG(@"点击了筛选按钮");
//    CreditScreenViewController *controller = [[CreditScreenViewController alloc] init];
//    controller.leftMargin = 60;
//    
//    UINavigationController *rightNavigationController =  [[UINavigationController alloc] initWithRootViewController:controller];
//    [self performSelector:@selector(changeRightMenuViewController:) withObject:rightNavigationController];
//    
//    [self performSelector:@selector(presentRightMenuViewController:) withObject:self];

}


#pragma 搜索点击触发方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    DLOG(@"点击了搜索按钮");
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length) {
    
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
        [parameters setObject:_searchBar.text forKey:@"keywords"];   //关键字	借款标题或编号
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
        DLOG(@"债权转让加载更多的页数为 is %ld",(long)_currPage);
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];

    }
    
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
    CreditorTransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
       cell = [[CreditorTransferTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
    CreditorTransfer *object = [_dataArrays objectAtIndex:indexPath.section];
    
    [cell fillCellWithObject:object];
    if ([object.time isEqualToString:@"0"]) {
        
        cell.tenderBtn.userInteractionEnabled = NO;
    }else{
        [cell.tenderBtn setTag:indexPath.section];
        [cell.tenderBtn addTarget:self action:@selector(auctionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.showsReorderControl =YES;
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.layer.cornerRadius = 10.0f;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section == [_dataArrays count]-2) {
////        [self.tableView footerBeginRefreshing];
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 2.0f;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 2.0f;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     CreditorTransfer *object = [_dataArrays objectAtIndex:indexPath.section];
    DetailsOfCreditorViewController *DetailsOfCreditorView = [[DetailsOfCreditorViewController alloc] init];
    DetailsOfCreditorView.titleString = object.title;
    DetailsOfCreditorView.rulingPriceStr = [NSString stringWithFormat:@"¥%.1f",object.currentPrincipal];
    DetailsOfCreditorView.creditorId = [NSString stringWithFormat:@"%ld", (long)object.creditorId];
    //DetailsOfCreditorView.timeString = object.time;
    DetailsOfCreditorView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DetailsOfCreditorView animated:YES];
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


#pragma mark - 立即竞拍
- (void)auctionBtnClick:(UIButton *)btn
{
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin goLogin:self];
    }else {
        CreditorTransfer *object = [_dataArrays objectAtIndex:btn.tag];
        
        [self.tabBarController.tabBar setHidden:YES];
        AuctionViewController *auctionView = [[AuctionViewController alloc] init];
        auctionView.creditorId = [NSString stringWithFormat:@"%ld",object.creditorId];
        //    auctionView.debtNo = debtNo;
        [self.navigationController pushViewController:auctionView animated:YES];
    }
    
}


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
