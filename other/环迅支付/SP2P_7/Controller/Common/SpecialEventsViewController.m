//
//  SpecialEventsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  资讯公告

#import "SpecialEventsViewController.h"
#import "ColorTools.h"
#import "UIScrollView+MJRefresh.h"
#import "InfoNewsViewController.h"

@interface SpecialEventsViewController ()<HTTPClientDelegate,UIScrollViewDelegate>
{
    
    NSInteger currPage;
    NSInteger typeNum;
    NSInteger tapNum;
    
}
@property(nonatomic ,strong) NetWorkClient *requestClient1;
@property(nonatomic ,strong) UIScrollView *scrollView;
@property(nonatomic ,strong) NSMutableArray *idsArr;
@property(nonatomic ,strong) NSMutableArray *imgArr;
@end

@implementation SpecialEventsViewController

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
    
    [self initView];
    
    [self initNavigationBar];
    
    [self initData];
    
}


- (void)initView
{
    
    [self.view setBackgroundColor:KblackgroundColor];
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 510);
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.scrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [self.scrollView headerBeginRefreshing];
    [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.scrollView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

- (void)initData
{
    currPage = 1;
    _idsArr = [[NSMutableArray alloc] init];
    _imgArr = [[NSMutableArray alloc] init];
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    currPage = 1;
    typeNum = 1;
    [self requestData];
    
}


-(void)requestData
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"149" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)currPage] forKey:@"currPageStr"]; //年利率  0 全部
    
    
    if (_requestClient1 == nil) {
        _requestClient1 = [[NetWorkClient alloc] init];
        _requestClient1.delegate = self;
        
    }
    [_requestClient1 requestGet:@"app/services" withParameters:parameters];
    
}

- (void)footerRereshing
{
    
    currPage++;
    typeNum = 2;
    [self requestData];
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

- (void)setView {
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _imgArr.count*130);
    for (int i = 0; i < _imgArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10 + i * 120, self.view.frame.size.width, 120)];
        if ([_imgArr[i] hasPrefix:@"http"]) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _imgArr[i]]]];
        }else{
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Baseurl, _imgArr[i]]]];
        }
        
        
        UITapGestureRecognizer *tapreg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        UIView *tapview = [tapreg view];
        tapview.tag = i;
        tapreg.numberOfTapsRequired = 1;
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        
        [imageView addGestureRecognizer:tapreg];
    }
    
}

- (void)tapClick:(UITapGestureRecognizer *)tapreg
{
    DLOG(@"点击事件");
    
    UIView *imageview = [tapreg view];
    
    InfoNewsViewController *infoView = [[InfoNewsViewController alloc] init];
    infoView.newsId = [NSString stringWithFormat:@"%@",_idsArr[imageview.tag]];
    infoView.typeStr = @"返回";
    [self.navigationController pushViewController:infoView animated:YES];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dataDic = obj;
    DLOG(@"fhjdfjkdfjk is %@",dataDic);
    [self hiddenRefreshView];
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *dataArr = [dataDic objectForKey:@"records"];
        if (dataArr.count) {
            
            if (typeNum == 1) {
                for (UIImageView *imgView in [_scrollView subviews]) {
                    if ([imgView isKindOfClass:[UIImageView class]]) {
                        
                        [imgView removeFromSuperview];
                        
                    }
                }
                [_imgArr removeAllObjects];
                [_idsArr removeAllObjects];
            }
            
            for (NSDictionary *item in dataArr) {
                [_idsArr addObject:[item objectForKey:@"entityId"]];
                [_imgArr addObject:[item objectForKey:@"image_filename2"]];
                
            }
            
            [self setView];
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        
        DLOG(@"返回失败===========%@",[dataDic objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDic objectForKey:@"msg"]]];
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"资讯公告";
    
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tag = 1;
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}


#pragma mark -
#pragma mark 返回
- (void)backClick
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!self.scrollView.isHeaderHidden) {
        [self.scrollView headerEndRefreshing];
    }
    
    if (!self.scrollView.isFooterHidden) {
        [self.scrollView footerEndRefreshing];
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
