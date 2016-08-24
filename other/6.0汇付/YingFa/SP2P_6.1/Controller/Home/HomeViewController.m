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


@interface HomeViewController ()<FocusImageFrameDelegate,HTTPClientDelegate>
{
    NSMutableArray *_qualityArrays;
    
    NSMutableArray *_fullArrays;
    
    NSMutableArray *_adArrays;
    
 
}

@property (nonatomic, strong) HomeListView *qualityListView;//

@property (nonatomic, strong) HomeListView *fullListView;//

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



- (void)viewDidLoad
{
    [super viewDidLoad];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"investRefresh" object:nil];
    
    // 初始化数据
    [self initData];
    
    [self readData];
    
    // 初始化视图
    [self initView];
    
    [self requestData];
    
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
    _qualityArrays = [[NSMutableArray alloc] init];
    _fullArrays = [[NSMutableArray alloc] init];
    _adArrays = [[NSMutableArray alloc] init];
    _tempArrays = [[NSMutableArray alloc] init];
    _qualityInfoArr = [[NSMutableArray alloc] init];
    _fullInfoArr = [[NSMutableArray alloc] init];
    _qualityDataArr = [[NSMutableArray alloc] init];
    _fullDataArr = [[NSMutableArray alloc] init];
    _qualityIdArr = [[NSMutableArray alloc] init];
    _fullyIdArr = [[NSMutableArray alloc] init];

}


/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    _scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _scrollContent.showsHorizontalScrollIndicator = NO;
    _scrollContent.showsVerticalScrollIndicator = NO;
    [_scrollContent setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 48, 0)];
    [_scrollContent setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    [self.view addSubview:_scrollContent];
    
    _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160) delegate:self imageItems:_adArrays isAuto:YES];
    _adScrollView.contentMode =  UIViewContentModeScaleAspectFill;
    [_scrollContent addSubview:_adScrollView];

    
    _qualityListView = [[HomeListView alloc] initWithFrame:CGRectMake(0, 165, self.view.frame.size.width, 296) type:HomeListViewTypeQuality];
    _qualityListView.HomeNAV = self;
    
    _fullListView = [[HomeListView alloc] initWithFrame:CGRectMake(0, 155 + 296 +16, self.view.frame.size.width, 296) type:HomeListViewTypeFull];
    _fullListView.HomeNAV = self;
    
    _scrollContent.contentSize = CGSizeMake(self.view.frame.size.width, 160 + 296*2 + 16);
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.scrollContent addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [self.scrollContent headerBeginRefreshing];
   
  
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
    //[self readCache];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self processData:obj isCache:NO];// 读取当前请求到的数据
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    
    [self readCache];
//    
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    
    [self readCache];
//    
//  [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{
    DLOG(@"dataDics is %@",dataDics);
    NSInteger qualistNum = 0;
    NSInteger fulllistNum = 0;
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
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
                    
                    if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]] hasPrefix:@"http"]) {
                        
                        bean.image = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];
                    }else
                    {
                        bean.image = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"image_filename"]];
                    }
                    
                    bean.urlStr = [item objectForKey:@"url"];
                    bean.tag = [_tempArrays count] + 1;
                    [_tempArrays addObject:bean];
                    
                }
                [self readData];
                [_adScrollView changeImageViewsContent:_adArrays];
            }
        }
        
        //最新借款资讯
        if (![[dataDics objectForKey:@"bids"] isEqual:[NSNull null]]) {
            
            NSArray *bidsArr = [dataDics objectForKey:@"bids"];
            [_qualityDataArr removeAllObjects];
            [_qualityInfoArr removeAllObjects];
            [_qualityIdArr removeAllObjects];
            if (bidsArr.count) {
                for (NSDictionary *bidDic in bidsArr) {
                    
                    NSString *nameStr = [bidDic objectForKey:@"userName"];//用户名
                    NSString *idStr = [NSString  stringWithFormat:@"%@",[bidDic objectForKey:@"id"]];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[bidDic objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    NSString *timeStr = [dateFormat stringFromDate:date];//时间
                    NSString *amountStr = [NSString  stringWithFormat:@"%@",[bidDic objectForKey:@"amount"]];//金额
                    NSString *StatusStr = [bidDic objectForKey:@"strStatus"];
                    NSString *aprStr = [NSString  stringWithFormat:@"%.1f",[[bidDic objectForKey:@"apr"] floatValue]];//金额
                    NSString *adStr = [NSString stringWithFormat:@"会员%@ %@发布了借款金额¥%@,年利率%@%%%@...",nameStr,timeStr,amountStr,aprStr,StatusStr];
                    [_qualityDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)nameStr.length]];
                    [_qualityDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)amountStr.length]];
                    [_qualityInfoArr addObject:adStr];
                    [_qualityIdArr addObject:idStr];
                }
                
            }
//            else{
//                
//                for (int i=0; i<3; i++) {
//                    NSString *nameStr = @"无数据";//用户名
//                    NSString *idStr = @"";
//                    NSString *timeStr = @"..";//时间
//                    NSString *amountStr = @"..";//金额
//                    NSString *StatusStr = @"...";
//                    NSString *aprStr = @"无数据";//金额
//                    NSString *adStr = [NSString stringWithFormat:@".%@ %@........%@......%@...%@...",nameStr,timeStr,amountStr,aprStr,StatusStr];
//                    [_qualityInfoArr addObject:adStr];
//                    [_qualityDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)nameStr.length]];
//                    [_qualityDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)amountStr.length]];
//                    [_qualityIdArr addObject:idStr];
//                }
//                
//            }
            
            [_qualityListView addContentView:_qualityInfoArr qualitydata:_qualityDataArr qualityIdArr:_qualityIdArr full:nil fullData:nil fullIdArr:nil];
            //      [_qualityListView addContentView:_qualityInfoArr qualitydata:_qualityDataArr full:nil fullData:nil];
            
        }
        
        //优质借款标
        if (![[dataDics objectForKey:@"qualityBids"] isEqual:[NSNull null]]) {
            
            NSArray *qualityArr = [dataDics objectForKey:@"qualityBids"];
            [_qualityArrays removeAllObjects];
            
            if (qualityArr.count) {
                for (NSDictionary *item in qualityArr) {
                    Investment *bean = [[Investment alloc] init];
                    bean.title = [item objectForKey:@"title"];
                    bean.borrowId = [item objectForKey:@"id"];
                    bean.imgurl = [NSString stringWithFormat:@"%@",[item objectForKey:@"bid_image_filename"]];
                    bean.levelStr = [NSString stringWithFormat:@"%@",[[item objectForKey:@"creditLevel"] objectForKey:@"imageFilename"]];
                    bean.progress = [[item objectForKey:@"loan_schedule"] floatValue];
                    bean.amount = [[item objectForKey:@"amount"] floatValue];
                    bean.rate = [[item objectForKey:@"apr"] floatValue];
                    bean.time = [item objectForKey:@"period"];
                    bean.isQuality = [[item objectForKey:@"is_hot"] boolValue];
                    bean.unitstr = [NSString stringWithFormat:@"%@",[item objectForKey:@"period_unit"]];
                    bean.borrowId = [item objectForKey:@"id"]; //借款标ID
                    [_qualityArrays addObject:bean];
                }
                qualistNum = _qualityArrays.count;
            }
//            else {
//                
//                for (int i = 0; i < 3; i++) {
//                    
//                    Investment *bean = [[Investment alloc] init];
//                    bean.title = @"无数据";
//                    bean.imgurl = nil;
//                    bean.progress = 0;
//                    bean.amount = 0;
//                    bean.rate = 0;
//                    bean.time = @"0";
//                    [_qualityArrays addObject:bean];
//                    
//                }
//                qualistNum = 3;
//            }
            
            [_qualityListView fillTableWithObject:_qualityArrays];
//            [_scrollContent addSubview:_qualityListView];
            
        }
        [_scrollContent addSubview:_qualityListView];
        
        //最新投资资讯
        if (![[dataDics objectForKey:@"invests"] isEqual:[NSNull null]]) {
            
            NSArray *investArr = [dataDics objectForKey:@"invests"];
            [_fullDataArr removeAllObjects];
            [_fullInfoArr removeAllObjects];
            [_fullyIdArr removeAllObjects];
            if (investArr.count) {
                for (NSDictionary *investDic in investArr) {
                    
                    //  NSString *nameStr = [NSString stringWithFormat:@"%@**", [[investDic objectForKey:@"userName"] substringWithRange:NSMakeRange(0, 1)]];
                    NSString *nameStr = [NSString  stringWithFormat:@"%@",[investDic objectForKey:@"userName"]];
                    NSString *idStr = [NSString  stringWithFormat:@"%@",[investDic objectForKey:@"id"]];
                    NSString *numStr = [NSString  stringWithFormat:@"%@",[investDic objectForKey:@"count"]];
                    NSString *aprStr = [NSString  stringWithFormat:@"%@",[investDic objectForKey:@"apr"]];
                    NSString *amountStr = [NSString stringWithFormat:@"%@",[investDic objectForKey:@"amount"]];
                    //   NSString *adStr = [NSString stringWithFormat:@"会员%@ %@借出金额¥%@,成功理财",nameStr,timeStr,amountStr];
                    NSString *adStr = [NSString stringWithFormat:@"会员%@ 借出了金额¥%@,成功理财投标%@次,年息%@%%...",nameStr,amountStr,numStr,aprStr];
                    [_fullInfoArr addObject:adStr];
                    [_fullDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)nameStr.length]];
                    [_fullDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)amountStr.length]];
                    [_fullyIdArr addObject:idStr];
                    
                }
                
            }
//            else {
//                
//                for (int i = 0; i < 3; i++) {
//                    NSString *nameStr = @"无数据";//用户名
//                    NSString *idStr = @"0";
//                    NSString *timeStr =@"....";//时间
//                    NSString *amountStr = @"无数据";//金额
//                    NSString *adStr = [NSString stringWithFormat:@"..%@..%@.........%@..........",nameStr,timeStr,amountStr];
//                    [_fullInfoArr addObject:adStr];
//                    [_fullDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)nameStr.length]];
//                    [_fullDataArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)amountStr.length]];
//                    [_fullyIdArr addObject:idStr];
//                }
//                
//            }

            
            [_fullListView addContentView:nil qualitydata:nil qualityIdArr:nil full:_fullInfoArr fullData:_fullDataArr fullIdArr:_fullyIdArr];
            
        }
        
        //满标借款标  OK
        if (![[dataDics objectForKey:@"fullBids"] isEqual:[NSNull null]]) {
            
            NSArray *fullArr = [dataDics objectForKey:@"fullBids"];
            [_fullArrays removeAllObjects];
            if (fullArr.count) {
                for (NSDictionary *item in fullArr) {
                    
                    Investment *bean = [[Investment alloc] init];
                    bean.title = [item objectForKey:@"title"];
                    bean.amount = [[item objectForKey:@"has_invested_amount"] floatValue];
                    bean.numStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"num"]];
                    bean.borrowId = [item objectForKey:@"id"];
                    if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"bid_image_filename"]] hasPrefix:@"http"]) {
                        
                        bean.imgurl = [NSString stringWithFormat:@"%@",[item objectForKey:@"bid_image_filename"]];
                    }else
                    {
                        
                        bean.imgurl = [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"bid_image_filename"]];
                    }
                    
                    bean.rate = [[item objectForKey:@"apr"] floatValue];
                    [_fullArrays addObject:bean];
                }
                fulllistNum = _fullArrays.count;
            }
//            else {
//                
//                for (int i = 0; i < 3; i++) {
//                    
//                    Investment *bean = [[Investment alloc] init];
//                    bean.title = @"无数据";
//                    bean.imgurl = nil;
//                    [_fullArrays addObject:bean];
//                    
//                }
//                fulllistNum = 3;
//            }
            
            [_fullListView fillTableWithObject:_fullArrays];
//            [_scrollContent addSubview:_fullListView];
            
        }
        [_scrollContent addSubview:_fullListView];
        
        if (!isCache) {
            // 非缓存数据才显示隐藏
            [self hiddenRefreshView];
        }
        
        _qualityListView.frame = CGRectMake(0, 165, self.view.frame.size.width, 56 + qualistNum * 80);
        _fullListView.frame = CGRectMake(0, CGRectGetMaxY(_qualityListView.frame), self.view.frame.size.width, 56 + fulllistNum * 80);
        
        if (qualistNum == 0 && fulllistNum == 0)
        {
            _scrollContent.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+10);
        }
        else if ((qualistNum == 1 && fulllistNum == 0) ||(qualistNum == 0 && fulllistNum == 1))
        {
            _scrollContent.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_adScrollView.frame)+56*2+90*2+20);
        }
        else if (qualistNum == 1 && fulllistNum == 1)
        {
            _scrollContent.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_fullListView.frame)+20);
        }
        else{
            _scrollContent.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_fullListView.frame)+20);
        }

        
    }else {
        if (!isCache) {
            // 非缓存数据才显示错误
            [self hiddenRefreshView];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
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

#pragma mark - FocusImageFrameDelegate

- (void)foucusImageFrame:(AdScrollView *)imageFrame didSelectItem:(AdvertiseGallery *)item
{
    
    DLOG(@"广告栏选中%ld",(long)item.tag);
    if(item.urlStr.length > 0)
    {
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
    
    [self performSelector:@selector(presentLeftMenuViewController:) withObject:self];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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
