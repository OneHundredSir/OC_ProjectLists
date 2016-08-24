//
//  SuccessfullyViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心---》借款子账户----》“已成功”
#import "SuccessfullyViewController.h"

#import "ColorTools.h"
#import "SuccessfullyTableViewCell.h"
#import "BorrowingDetailsViewController.h"
#import "Successfully.h"

#import "NSString+Date.h"

#import "BorrowAccountContants.h"

//-1为年 0为月 1为天
#define Period_Year -1
#define Period_Month 0
#define Period_Day 1

@interface SuccessfullyViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
}

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SuccessfullyViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [_tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"已成功的借款标";
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
    SuccessfullyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[SuccessfullyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Successfully *bean = _dataArrays[indexPath.section];
    
    
    cell.titleLabel.text = [bean title];
//    cell.typeView.image = [UIImage imageNamed:[bean smallImageFilename]];// 借款标类型
    [cell.typeView  sd_setImageWithURL:[NSURL URLWithString:bean.smallImageFilename] placeholderImage:[UIImage imageNamed:@""]];
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[bean amount]];
    switch (bean.periodUnit) {
        case Period_Year:
            
            cell.periodLabel.text = [NSString stringWithFormat:@"%ld %@",(long)bean.period, @"期"];
            break;
        case Period_Month:
            cell.periodLabel.text = [NSString stringWithFormat:@"%ld %@",(long)bean.period, @"期"];
            break;
        case Period_Day:
            cell.periodLabel.text = [NSString stringWithFormat:@"%ld %@",(long)bean.period, @"期"];
            break;
        default:
            break;
    }

    switch (bean.status) {
        case Borrow_State_Auditing:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_auditing"];
            break;
        case Borrow_State_BeforeLoan:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_beforeloan"];
            break;
        case Borrow_State_Fundraising:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_fundraising"];
            break;
        case Borrow_State_WaitingLoan:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_waitingloan"];
            break;
        case Borrow_State_Repaying:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_repaying"];
            break;
        case Borrow_State_Repayed:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_repayed"];
            break;
        case Borrow_State_AuditFail:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_auditfail"];
            break;
        case Borrow_State_LoanningFail:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_loanninglail"];
            break;
        case Borrow_State_LoanedFail:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_loanedfail"];
            break;
        case Borrow_State_BadBids:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_badbids"];
            break;
        case Borrow_State_Revocation:
            cell.statusView.image = [UIImage imageNamed:@"borrow_state_revocation"];
            break;
        default:
            break;
    }
    
    cell.aprLabel.text = [NSString stringWithFormat:@"%.f%%", bean.apr];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BorrowingDetailsViewController *borrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    
    Successfully *bean = _dataArrays[indexPath.section];
    borrowingDetailsView.borrowID = [NSString stringWithFormat:@"%ld", (long)[bean successfullyId]];
    borrowingDetailsView.titleString = [bean title];
    borrowingDetailsView.stateNum = 3;
    
    [self.navigationController pushViewController:borrowingDetailsView animated:YES];
    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
   // [self.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"93" forKey:@"OPT"]; //已成功的借款标查询
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
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
    _total = 2;
    
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
        if(_total==1)
        {
            [_dataArrays removeAllObjects];// 清空全部数据
        
        
        }
        
        _total = [[dics objectForKey:@"totalNum"] intValue];// 总共多少条
        
        NSArray *dataArr = [dics objectForKey:@"page"];
        for (NSDictionary *item in dataArr) {
            Successfully *bean = [[Successfully alloc] init];
            bean.title = [item objectForKey:@"title"];
            bean.successfullyId = [[item objectForKey:@"id"] intValue];

            if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"small_image_filename"]] hasPrefix:@"http"]) {
                
                bean.smallImageFilename = [NSString stringWithFormat:@"%@",[item objectForKey:@"small_image_filename"]]; //借款标类型
            }else{
                
                bean.smallImageFilename = [NSString stringWithFormat:@"%@%@", Baseurl, [item objectForKey:@"small_image_filename"]]; //借款标类型
                
            }
            
            
            bean.amount = [[item objectForKey:@"amount"] floatValue];// 借款金额
            
            bean.periodUnit = [[item objectForKey:@"period_unit"] intValue];// 借款期限单位	-1为年 0为月 1为天
            if (bean.periodUnit == Period_Year) {
                // 借款期数	当借款期限单位为年时期数要乘以12
                bean.period = [[item objectForKey:@"period"] intValue] * 12;
            }else {
                bean.period = [[item objectForKey:@"period"] intValue];
            }
            
            if ([item objectForKey:@"last_repay_time"] != nil && ![[item objectForKey:@"last_repay_time"] isEqual:[NSNull null]] ) {
                bean.lastRepayTime = [NSString converDate:[[item objectForKey:@"last_repay_time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd"];//
            }
            
            bean.apr = [[item objectForKey:@"apr"] floatValue];// 年利率
            bean.status = [[item objectForKey:@"status"] intValue];//
            
            [_dataArrays addObject:bean];
        }
        
        [_tableView reloadData];
        
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    [self hiddenRefreshView];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
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
