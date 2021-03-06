//
//  BidRecordsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//借款详情=======》》》投标记录
#import "TenderRecordsViewController.h"
#import "ColorTools.h"
#import "TenderOnceViewController.h"
#import "AuctionRecordCell.h"
#import "TenderRecords.h"

@interface TenderRecordsViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>
{
    
    NSArray *titleArr;
    
}
@property(nonatomic ,strong) NSMutableArray *listDataArr;
@property(nonatomic ,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TenderRecordsViewController

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
    
    titleArr = @[@"参与人",@"支持金额",@"应援时间"];
    _listDataArr = [[NSMutableArray alloc] init];

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
    
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.scrollEnabled = YES;
    _listView.dataSource = self;
    [self.view  addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [self.listView headerBeginRefreshing];
       [self headerRereshing];

    
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    
    [self requestData];
}

-(void)requestData
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //借款投标记录
    [parameters setObject:@"12" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowID] forKey:@"borrowId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        
        if (dataArr.count) {
            
            [_listDataArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                TenderRecords *model = [[TenderRecords alloc] init];
                model.userName = [dic objectForKey:@"name"];
                model.tendAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"invest_amount"]];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[dic objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                 model.time = [dateFormat stringFromDate: date];
                
                [_listDataArr addObject:model];

            }
        }
        [self hiddenRefreshView];
        
        // 刷新表格
        [self.listView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        
        [self hiddenRefreshView];
        DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
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
      [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

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


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"投标记录";
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
    
    return [_listDataArr count];
    
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
    TenderRecords *recordmodel = [_listDataArr objectAtIndex:indexPath.section];
    cell.nameLabel.text = recordmodel.userName;
    cell.bidLabel.text = recordmodel.tendAmount;
    cell.timeLabel.text = recordmodel.time;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
       [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma 立即投标ann
- (void)tenderBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
        
         [ReLogin outTheTimeRelogin:self];        
    }else {
        
        TenderOnceViewController *TenderOnceView = [[TenderOnceViewController alloc] init];
        TenderOnceView.borrowId = _borrowID;
        [self.navigationController pushViewController:TenderOnceView animated:YES];
        
        
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
