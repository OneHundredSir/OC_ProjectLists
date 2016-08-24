//
//  InvestmentViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我要投资
//

#import "InvestmentViewController.h"

#import "BarButtonItem.h"
#import "ColorTools.h"

#import "SortItem.h"
#import "SortItemGrop.h"
#import "InvestmentTableViewCell.h"

#import "Investment.h"
#import "BorrowingDetailsViewController.h"
#import "InterestcalculatorViewController.h"
#import "ScreenViewOneController.h"
#import "AppDelegate.h"
#import "CacheUtil.h"

#define kSortHeight 40.0

#define kIS_IOS7                (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)

extern NSString *headertitle;

@interface InvestmentViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,HTTPClientDelegate>
{
    NSMutableArray *_sortArrays;// 排序View集合
    
    SortItemGrop *_sortGrop;
    NSMutableArray *_dataArrays;
    BorrowingDetailsViewController *BorrowingDetailsView;
    
    NSInteger _currPage;//页数
    NSInteger _num;//识别不同网络请求
    NSInteger _num2;//加载更多标志
    
    int clickRow;
}

@property (strong, nonatomic)  UIView *sortContentView;
@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic ,strong)   UISearchBar* searchBar;

@property(nonatomic ,strong) NetWorkClient *requestClient1;
@property(nonatomic ,strong)  NSMutableArray *screenArr;
@property(nonatomic ,copy)  NSString *investFileName;
@property(nonatomic ,copy)  NSString *orderStr;

@end


@implementation InvestmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //通知检测对象
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(investScreen:) name:@"screen1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"investRefresh" object:nil];
    // 初始化数据
    [self initData];
    //读取网络数据
    // [self readData];
    
    // 初始化视图
    [self initView];
    
    
    
}


- (void)readData
{
    
    
    
}

/**
 初始化数据
 */
- (void)initData
{
    _screenArr = [[NSMutableArray alloc] init];
    _dataArrays =[[NSMutableArray alloc] init];
    _orderStr = [[NSString alloc] init];
    _orderStr = @"0";
    _sortContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, kSortHeight)];
    _sortContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sortContentView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _sortContentView.frame.origin.y + _sortContentView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _sortContentView.frame.size.height - 64) style:UITableViewStyleGrouped];
    [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 48, 0)];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _sortArrays = [[NSMutableArray alloc] init];
    
    NSArray *sortArrays = [NSArray arrayWithObjects:NSLocalizedString(@"Sort_Default", nil), NSLocalizedString(@"Sort_Money", nil), NSLocalizedString(@"Sort_Rate", nil), NSLocalizedString(@"Sort_Progress", nil), NSLocalizedString(@"Sort_Quality", nil), nil];
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
            sortView = [[SortItem alloc] initWithFrame:CGRectMake(frameWidth, 0, viewWidth, kSortHeight) andName:name sortImage:@"sort_desc" state:state];
            sortView.nameLabel.textColor = PinkColor;
        }else{
            
            sortView = [[SortItem alloc] initWithFrame:CGRectMake(frameWidth+12, 0, viewWidth, kSortHeight) andName:name sortImage:@"sort_desc" state:state];
            
        }
        UILabel *linelabel = [[UILabel alloc] init];
        linelabel.backgroundColor = [UIColor lightGrayColor];
        if([sortArrays indexOfObject:name] != 4)
        {
            linelabel.frame = CGRectMake(frameWidth+viewWidth+14, 11, 0.2, kSortHeight-22);
            
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
    
    _sortGrop = [[SortItemGrop alloc] initWithFrame:CGRectMake(0, kSortHeight - 4.0, self.view.frame.size.width, 4) sortArrays:_sortArrays defaultPosition:0];
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
    //self.title = NSLocalizedString(@"Tab_Investment", nil);
    
    [self initNavigationBar];
    
    //搜索
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 200, 35)];
    _searchBar.delegate = self;
    _searchBar.barStyle =  UIBarStyleDefault;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.placeholder = @"请输入标题或编号";
    _searchBar.keyboardType =  UIKeyboardTypeDefault;
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
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)initNavigationBar
{
    BarButtonItem *leftButton = [BarButtonItem barItemWithImage:[UIImage imageNamed:@"ic_account_normal"] selectedImage:[UIImage imageNamed:@"ic_account_normal"] target:self action:@selector(leftClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];// 左边导航按钮
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:KColor];
    
    // 导航条返回按钮
    UIBarButtonItem *ScreenItem=[[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(ScreenClick)];
    ScreenItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:ScreenItem];
    
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
    [parameters setObject:@"-1" forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:orderTypeStr forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    if (_screenArr.count)
    {
        _num = 2;
        _num2 = 0;
        [parameters setObject:[_screenArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:[_screenArr objectAtIndex:1] forKey:@"amount"]; //借款金额
        [parameters setObject:[_screenArr objectAtIndex:2] forKey:@"loanSchedule"]; //投标进度
        [parameters setObject:[_screenArr objectAtIndex:4] forKey:@"endDate"]; //结束日期
        [parameters setObject:[_screenArr objectAtIndex:3] forKey:@"loanType"]; //借款类型
        [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
    }
    
    _investFileName = [CacheUtil creatCacheFileName:parameters];
    
    if (_requestClient1 == nil) {
        _requestClient1 = [[NetWorkClient alloc] init];
        _requestClient1.delegate = self;
        
    }
    [_requestClient1 requestGet:@"app/services" withParameters:parameters];
    
}

- (void)footerRereshing
{
    
    _num2 = 1;
    _currPage++;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"10" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:@"0" forKey:@"amount"]; //借款金额
    [parameters setObject:@"0" forKey:@"loanSchedule"]; //投标进度
    [parameters setObject:@"" forKey:@"startDate"]; //开始日期
    [parameters setObject:@"" forKey:@"endDate"]; //结束日期
    [parameters setObject:@"-1" forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    if (_num ==0) {
        
        
        [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
        
    }
    else if ( _num == 1){
        
        
        [parameters setObject:_searchBar.text forKey:@"keywords"];   //关键字	借款标题或编号
        
    }else if (_num == 2){
        
        [parameters setObject:[_screenArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:[_screenArr objectAtIndex:1] forKey:@"amount"]; //借款金额
        [parameters setObject:[_screenArr objectAtIndex:2] forKey:@"loanSchedule"]; //投标进度
        [parameters setObject:[_screenArr objectAtIndex:4] forKey:@"endDate"]; //结束日期
        [parameters setObject:[_screenArr objectAtIndex:3] forKey:@"loanType"]; //借款类型
        [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
        
    }
    if (_requestClient1 == nil) {
        _requestClient1 = [[NetWorkClient alloc] init];
        _requestClient1.delegate = self;
        
    }
    [_requestClient1 requestGet:@"app/services" withParameters:parameters];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
    
}


#pragma mark
#pragma mark 借款标筛选方法
- (void)investScreen:(NSNotification *)notification
{
    
    _screenArr = (NSMutableArray *)[notification object];
    
    DLOG(@"筛选条件数组为=======%@",_screenArr);
    
    _num = 2;
    _num2 = 0;
    _currPage = 1;
    _searchBar.text = nil;
    //2.1获取投资列表信息，包含投资列表。[OK]
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"10" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[_screenArr objectAtIndex:0] forKey:@"apr"]; //年利率  0 全部
    [parameters setObject:[_screenArr objectAtIndex:1] forKey:@"amount"]; //借款金额
    [parameters setObject:[_screenArr objectAtIndex:2] forKey:@"loanSchedule"]; //投标进度
    [parameters setObject:@"" forKey:@"startDate"]; //开始日期
    [parameters setObject:[_screenArr objectAtIndex:4] forKey:@"endDate"]; //结束日期
    [parameters setObject:[_screenArr objectAtIndex:3] forKey:@"loanType"]; //借款类型
    [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
    [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
    [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
    [parameters setObject:@"" forKey:@"keywords"];   //关键字	借款标题或编号
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];  //当前页数
    
    if (_requestClient1 == nil) {
        _requestClient1 = [[NetWorkClient alloc] init];
        _requestClient1.delegate = self;
        
    }
    [_requestClient1 requestGet:@"app/services" withParameters:parameters];
    
}


-(void) readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_investFileName];// 合成归档保存的完整路径
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
    //    [self readCache];
}




// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    [self processData:obj isCache:NO];// 读取当前请求到的数据
    
}


-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    DLOG(@"==返回成功=======%@",dataDics);
    
    [self hiddenRefreshView];
    
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_investFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
            
        }
        
        if ([[dataDics objectForKey:@"list"] count] == 0)
        {
            if(_num2 == 0){
                
                switch (_num) {
                        
                    case 0:
                        [SVProgressHUD showErrorWithStatus:@"无数据"];
                        break;
                    case 1:
                        [SVProgressHUD showErrorWithStatus:@"无搜索结果"];
                        break;
                    case 2:
                        [SVProgressHUD showErrorWithStatus:@"无筛选结果"];
                        break;
                }
            }else{
                
                //                    [SVProgressHUD showErrorWithStatus:@"无更多数据"];
                
            }
            
        }else {
            
            NSArray *dataArr = [dataDics objectForKey:@"list"];
            
            if (_num2 == 0){
                
                [_dataArrays removeAllObjects];
                
                switch (_num) {
                        
                    case 0:
                        [SVProgressHUD showSuccessWithStatus:@"已刷新"];
                        break;
                    case 1:
                        [SVProgressHUD showSuccessWithStatus:@"搜索成功"];
                        break;
                    case 2:
                        [SVProgressHUD showSuccessWithStatus:@"筛选成功"];
                        break;
                }
                
            }else if (_num == 1 || _num ==2) {
                
                [self.tableView reloadData];
            }
            
            for (NSDictionary *item in dataArr) {
                Investment *bean = [[Investment alloc] init];
                if ([item objectForKey:@"title"] != nil && ![[item objectForKey:@"title"] isEqual:[NSNull null]]) {
                    
                    bean.title = [item objectForKey:@"title"];
                }
                if ([item objectForKey:@"bid_image_filename"] != nil && ![[item objectForKey:@"bid_image_filename"] isEqual:[NSNull null]]) {
                    
                    bean.imgurl = [item objectForKey:@"bid_image_filename"];
                }
                
                if ([item objectForKey:@"creditLevel"]  != nil && ![[item objectForKey:@"creditLevel"]  isEqual:[NSNull null]]) {
                    
                    bean.levelStr = [[item objectForKey:@"creditLevel"] objectForKey:@"image_filename"];
                    
                }else{
                    bean.levelStr  = @"";
                }
                
                bean.progress = [[item objectForKey:@"loan_schedule"] floatValue];
                bean.amount = [[item objectForKey:@"amount"] floatValue];
                bean.rate = [[item objectForKey:@"apr"] floatValue];
                bean.time = [NSString stringWithFormat:@"%@", [item objectForKey:@"period"]];
                
                bean.deadperiodUnit = [[item objectForKey:@"period_unit"] intValue]; // 期限类型
                bean.repayType = [[item objectForKey:@"repayment_type_id"] intValue];    // 还款方式
                bean.deadType = [[item objectForKey:@"bonus_type"] intValue];     // 投标奖励类型
                bean.bonus = [[item objectForKey:@"bonus"] intValue];
                bean.awardScale = [[item objectForKey:@"award_scale"] intValue];
                
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
                
               
                //优质债权
                bean.isQuality = [[item objectForKey:@"is_hot"] boolValue];
                bean.unitstr = [NSString stringWithFormat:@"%@",[item objectForKey:@"period_unit"]];
                bean.borrowId = [item objectForKey:@"id"]; //借款标ID
                [_dataArrays addObject:bean];
            }
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.tableView reloadData];
                
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self hiddenRefreshView];
            });
            
        }
        
    }else {
        [self hiddenRefreshView];
        
        if(!isCache)
        {
            DLOG(@"返回失败===========%@",[dataDics objectForKey:@"msg"]);
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
            
        }
    }
    
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    
    if (_num == 0) {
        [self readCache];
    }
    
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    if (_num == 0) {
        [self readCache];
    }
}


#pragma mark -
#pragma 排序方法
bool isclicked = YES;
bool isclicked1 = YES;
bool isclicked2 = YES;
bool isclicked3 = YES;
bool isclicked4 = YES;
- (void)itemClick:(SortItem *)sender
{
    //sender.nameLabel.textColor = SETCOLOR(233, 125, 124, 1.0);
    DLOG(@"id is %ld",(long)sender.tag);
    switch (sender.tag) {
        case 0:
        {
            if (isclicked) {
                //                   NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"repaytime" ascending:NO];//降序排序
                //                   [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                //                   [sender setState:SortDesc];
                //                    isclicked=NO;
                
                //
                //                   NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"progress" ascending:YES];
                //                   [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                _orderStr = @"0";
                [self requestData:_orderStr];
                [sender setState:SortAsc];
                
                
            }
            
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;
            
        }
            
            break;
        case 1:
        {
            if (isclicked1) {
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO];//降序排序
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortDesc];
                isclicked1=NO;
                _orderStr = @"1";
                [self requestData:_orderStr];
                
            }else {
                
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES];//升序排序
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortAsc];
                isclicked1=YES;
                _orderStr = @"2";
                [self requestData:_orderStr];
            }
            
            
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;
            
        }
            break;
        case 2:
        {
            
            if (isclicked2) {
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"rate" ascending:NO];
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortDesc];
                isclicked2=NO;
                _orderStr = @"3";
                [self requestData:_orderStr];
            }
            else
            {
                
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"rate" ascending:YES];
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortAsc];
                isclicked2=YES;
                _orderStr = @"4";
                [self requestData:_orderStr];
            }
            
            
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;
            
        }
            
            break;
        case 3:
            
        {
            if (isclicked3) {
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"progress" ascending:NO];
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortDesc];
                isclicked3=NO;
                _orderStr = @"5";
                [self requestData:_orderStr];
            }
            else
            {
                
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"progress" ascending:YES];
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortAsc];
                isclicked3=YES;
                _orderStr = @"6";
                [self requestData:_orderStr];
            }
            
            for (SortItem *sortView in _sortArrays) {
                
                sortView.nameLabel.textColor = [UIColor blackColor];
            }
            sender.nameLabel.textColor = PinkColor;
            
            
        }
            break;
        case 4:
        {
            
            if (isclicked4) {
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"repaytime" ascending:NO];//降序排序
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortDesc];
                isclicked4 = NO;
                _orderStr = @"7";
                [self requestData:_orderStr];
            }
            else
            {
                
                //                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"repaytime" ascending:YES];//升序排序
                //                [_dataArrays sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                [sender setState:SortAsc];
                isclicked4 = YES;
                _orderStr = @"8";
                [self requestData:_orderStr];
            }
            
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
    [self performSelector:@selector(presentLeftMenuViewController:) withObject:self];
}

#pragma 搜索点击触发方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    DLOG(@"点击了搜索按钮 -> %@", searchBar.text);
    [searchBar resignFirstResponder];
    if (searchBar.text.length) {
        _num = 1;
        _num2 = 0;
        _currPage = 1;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //2.1获取投资列表信息，包含投资列表。[OK]
        [parameters setObject:@"10" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:@"0" forKey:@"apr"]; //年利率  0 全部
        [parameters setObject:@"0" forKey:@"amount"]; //借款金额
        [parameters setObject:@"0" forKey:@"loanSchedule"]; //投标进度
        [parameters setObject:@"" forKey:@"startDate"]; //开始日期
        [parameters setObject:@"" forKey:@"endDate"]; //结束日期
        [parameters setObject:@"-1" forKey:@"loanType"]; //借款类型
        [parameters setObject:@"-1" forKey:@"minLevelStr"]; //最低信用等级
        [parameters setObject:@"-1" forKey:@"maxLevelStr"]; //最高信用等级
        [parameters setObject:_orderStr forKey:@"orderType"];  //排序类型
        [parameters setObject:searchBar.text  forKey:@"keywords"];   //关键字	借款标题或编号
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currPage] forKey:@"currPage"];
        
        if (_requestClient1 == nil) {
            _requestClient1 = [[NetWorkClient alloc] init];
            _requestClient1.delegate = self;
            
        }
        [_requestClient1 requestGet:@"app/services" withParameters:parameters];
    }
}


#pragma mark 筛选按钮

bool Clicked = YES;
- (void)ScreenClick
{
    
    DLOG(@"点击了筛选按钮");
    ScreenViewOneController *controller = [[ScreenViewOneController alloc] init];
    controller.leftMargin = 60;
    
    UINavigationController *rightNavigationController =  [[UINavigationController alloc] initWithRootViewController:controller];
    [self performSelector:@selector(changeRightMenuViewController:) withObject:rightNavigationController];
    
    [self performSelector:@selector(presentRightMenuViewController:) withObject:self];
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cate_cell%ld",(long)indexPath.section];
    InvestmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[InvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (kIS_IOS7) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
    }
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    [cell fillCellWithObject:object];
    cell.calculatorView.tag = indexPath.section;
    [cell.calculatorView addTarget:self action:@selector(repaymentcalculatorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == [_dataArrays count]-2) {
        //        [self.tableView footerBeginRefreshing];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.5f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//返回时取消选中状态
    
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    
    BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.titleString = object.title;
    BorrowingDetailsView.borrowID = object.borrowId;
    BorrowingDetailsView.progressnum = (object.progress)*0.01;
    BorrowingDetailsView.rate = object.rate;
    BorrowingDetailsView.timeString = object.time;
    BorrowingDetailsView.stateNum = 0;
    BorrowingDetailsView.HidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:BorrowingDetailsView animated:YES];
    
    
}

#pragma mark -
#pragma mark 计算器按钮
- (void)repaymentcalculatorBtnClick:(UIButton *)btn
{
    Investment *object = [_dataArrays objectAtIndex:btn.tag];
    
    InterestcalculatorViewController *interestcalculatorView = [[InterestcalculatorViewController alloc] init];
    interestcalculatorView.HidesBottomBarWhenPushed = YES;
    interestcalculatorView.status = 1;
    interestcalculatorView.bidAmout = [NSString stringWithFormat:@"%.0f", object.amount];
    interestcalculatorView.apr = [NSString stringWithFormat:@"%.0f", object.rate];
    interestcalculatorView.deadLine = object.time;
    interestcalculatorView.repayType = object.repayType;
    interestcalculatorView.bonus = object.bonus;
    interestcalculatorView.deadType = object.deadType;
    interestcalculatorView.awardScale = object.awardScale;
    interestcalculatorView.deadperiodUnit = object.deadperiodUnit;
    [self.navigationController pushViewController:interestcalculatorView animated:YES];
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient1 != nil) {
        [_requestClient1 cancel];
    }
    
}

@end
