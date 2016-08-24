//
//  IntegralDetailAuditInformationViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//审核资料积分明细

#import "IntegralDetailAuditInformationViewController.h"
#import "ColorTools.h"
#import "AuditDataPointsCell.h"

#import "IntegralDetail.h"

@interface IntegralDetailAuditInformationViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
}

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation IntegralDetailAuditInformationViewController

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
    _dataArrays = [[NSMutableArray alloc] init];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    self.title = @"审核资料积分明细";
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
    static NSString *cellid = @"cellid";
    AuditDataPointsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AuditDataPointsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
//    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
//    CGSize DocumentNameLabelSiZe = [cell.DocumentNameLabel.text boundingRectWithSize:CGSizeMake(999, 30)options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    IntegralDetail *bean = _dataArrays[indexPath.section];
    
    cell.DocumentNameLabel.text = bean.auditItemName;
//    cell.backView.frame =CGRectMake(cell.DocumentNameLabel.frame.origin.x+DocumentNameLabelSiZe.width+20, 2, 30, 30);
    cell.resultLabel.text = [NSString stringWithFormat:@"审核观点:%@",bean.suggestion];
    [cell.backView setImage:[UIImage imageNamed:@"integral_red_back"]];
    cell.scoreLabel.text = [NSString stringWithFormat:@"+%ld", (long)bean.score];
    
    cell.timeLabel.text = bean.auditTime;
    return cell;
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
     [self.navigationController popViewControllerAnimated:NO];
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


#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"115" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self hiddenRefreshView];
    });
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    
    if (_total == 1) {
        [_dataArrays removeAllObjects];// 清空全部数据
    }
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    //if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _total = [[[dics objectForKey:@"list"] objectForKey:@"totalCount" ] intValue];// 总共多少条
        DLOG(@"_total = %ld====",(long)_total);
        NSArray *dataArr = [[dics objectForKey:@"list"] objectForKey:@"page"];
        DLOG(@"dataArr.count = %lu====",(unsigned long)dataArr.count);
        for (NSDictionary *item in dataArr) {
            
            IntegralDetail *bean = [[IntegralDetail alloc] init];
            bean.auditItemName = [item objectForKey:@"audit_item_name"];//
            
            if (![[item objectForKey:@"audit_time"] isEqual:[NSNull null]]) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"audit_time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                bean.auditTime  = [dateFormat stringFromDate: date];
            }
//            
//            bean.auditTime = [NSString stringWithFormat:@"%@", [[item objectForKey:@"audit_time"] objectForKey:@"time"]];
            bean.score = [[item objectForKey:@"score"] intValue];//
            bean.suggestion = [item objectForKey:@"suggestion"] ; //
            
            DLOG(@"bean.auditItemName === %@", bean.auditItemName);
            [_dataArrays addObject:bean];
        }
    
        
    //} else {
        // 服务器返回数据异常
//       [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    //}
    
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
