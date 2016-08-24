//
//  TransferDebtViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(转让债权管理)
#import "TransferDebtViewController.h"

#import "ColorTools.h"
#import "DebtManagementCell.h"
#import "TranferSuccessedViewController.h"
#import "TranferingDebtViewController.h"
#import "AuditingDebtViewController.h"
#import "TranferNoPassViewController.h"
#import "TranferFailureViewController.h"
#import "WaitConfirmedViewController.h"

#import "DebtManagement.h"
#import "NSString+Date.h"

@interface TransferDebtViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;// 数据
    NSMutableArray *_listArr;
    NSMutableDictionary *_listDic;
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
    
    BOOL _isLoading;
}

@property (nonatomic,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TransferDebtViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self initNavigationBar];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    _collectionArrays =[[NSMutableArray alloc] init];
    _listArr = [[NSMutableArray alloc] init];
    _listDic = [[NSMutableDictionary alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view  addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];
    [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"markupSuccess" object:nil];
}

-(void) updateTable:(id)obj
{
//    [_listView headerBeginRefreshing];
    [self headerRereshing];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"转让债权管理";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    

  
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取分组
    NSString *key = [_listArr objectAtIndex:section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    return [array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    DebtManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[DebtManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *key = [_listArr objectAtIndex:indexPath.section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    // 有数据后启用
     DebtManagement *debtMag = array[indexPath.row];

    // -2、-3、-5失败
    // -1未通过
    // 0审核中
    // 3成功
    // 1、2转让中
    cell.titleLabel.text = debtMag.titleName;
    [cell setStateColor:debtMag.status];
    
    DLOG(@"debtMag.status -> %ld", (long)debtMag.status);
    
    switch (debtMag.status) {
        case -5:
            cell.stateLabel.text = @"失败";
            
            break;
        case -3:
            cell.stateLabel.text = @"失败";
            
            break;
        case -2:
            cell.stateLabel.text = @"失败";
            
            break;
        case -1:
            cell.stateLabel.text = @"未通过";
            
            break;
        case 0:
            cell.stateLabel.text = @"审核中";

            break;
        case 1:
            cell.stateLabel.text = @"转让中";

            break;
        case 2:
            cell.stateLabel.text = @"转让中";

            break;
        case 3:
            cell.stateLabel.text = @"成功";

            break;
        case 4:
            cell.stateLabel.text = @"待确认";
            
            break;

        default:
            break;
    }
    cell.timeLabel.text = debtMag.endTime;

    if (debtMag.type == 2) {
        cell.typeImg.image = [UIImage imageNamed:@"state_auction"];
    }else {
        cell.typeImg.image = [UIImage imageNamed:@"state_set"];
    }

    cell.transferLabel.text = [NSString stringWithFormat:@"转让定价:%.2f", debtMag.transferPrice];
    cell.highestLabel.text = [NSString stringWithFormat:@"最高竞价:%.2f", debtMag.maxOfferPrice];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *key = [_listArr objectAtIndex:section];
    return key;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [_listArr objectAtIndex:indexPath.section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    // 有数据后启用
    DebtManagement *item = array[indexPath.row];
    // -2、-3、-5失败
    // -1未通过
    // 0审核中
    // 3成功
    // 1、2转让中
    // 4等待确认
    
    DLOG(@"item.status - >%ld", (long)item.status);
    
    if (item.status == -2 || item.status == -3 || item.status == -5) {
        
        TranferFailureViewController *debtFailureView = [[TranferFailureViewController alloc] init];
        debtFailureView.sign = item.sign;
        [self.navigationController pushViewController:debtFailureView animated:YES];
        
    }else if (item.status == -1) {
        
        TranferNoPassViewController *debtNoPassView = [[TranferNoPassViewController alloc] init];
        debtNoPassView.sign = item.sign;
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationController pushViewController:debtNoPassView animated:YES];
        
    }else if(item.status == 0){
        
        AuditingDebtViewController *auditingDebtView = [[AuditingDebtViewController alloc] init];
        auditingDebtView.sign = item.sign;
        [self.navigationController pushViewController:auditingDebtView animated:YES];
        
    }else if(item.status == 1 || item.status == 2){
        if (item.type == 1) {
            WaitConfirmedViewController *waitConfirmed = [[WaitConfirmedViewController alloc] init];
            waitConfirmed.sign = item.sign;
            [self.navigationController pushViewController:waitConfirmed animated:YES];
            
        }else{
            TranferingDebtViewController *tranferingDebtView = [[TranferingDebtViewController alloc] init];
            tranferingDebtView.sign = item.sign;
            tranferingDebtView.bidName = item.bidName;
            tranferingDebtView.receivedAmount = [NSString stringWithFormat:@"%.f", item.transferPrice];
            [self.navigationController pushViewController:tranferingDebtView animated:YES];
        }
    }else if(item.status == 3){
        
        TranferSuccessedViewController *tranferSuccessedView = [[TranferSuccessedViewController alloc] init];
        tranferSuccessedView.sign = item.sign;
        [self.navigationController pushViewController:tranferSuccessedView animated:YES];
        
    }else if(item.status == 4){
        
        WaitConfirmedViewController *waitConfirmed = [[WaitConfirmedViewController alloc] init];
        waitConfirmed.sign = item.sign;
        [self.navigationController pushViewController:waitConfirmed animated:YES];
        
    }
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
        
        [parameters setObject:@"45" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
        
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
    _isLoading = YES;
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    _isLoading = NO;
    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    [_listDic removeAllObjects];
    if (_currPage == 1) {
        [_collectionArrays removeAllObjects];
        [_listArr removeAllObjects];
    }
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        // 清空全部数据
        NSArray *collections = [obj objectForKey:@"list"];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *item in collections) {
            DebtManagement *bean = [[DebtManagement alloc] init];
            
            bean.time1 = @"";
            
            if (![[item objectForKey:@"end_time"] isEqual:[NSNull null]]) {
                bean.endTime = [NSString converDate:[[item objectForKey:@"end_time"] objectForKey:@"time"] withFormat:@"MM-dd"];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"end_time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
                [dateFormat2 setDateFormat:@"yyyy年MM月"];
                bean.time1 = [dateFormat2 stringFromDate:date];
                
            }
            [dataArr addObject:bean.time1];
            
            bean.titleName = [item objectForKey:@"title"];
            // -2、-3、-5失败
            // -1未通过
            // 0审核中
            // 3成功
            // 1、2转让中
            bean.status = (int)[[item objectForKey:@"status"] integerValue];
            bean.type = (int)[[item objectForKey:@"type"] integerValue];
            bean.transferPrice = [[item objectForKey:@"transfer_price"] floatValue];
            bean.maxOfferPrice = [[item objectForKey:@"max_price"] floatValue];
            bean.sign = [item objectForKey:@"sign"];
            bean.bidName = [item objectForKey:@"name"];
            
            [_collectionArrays addObject:bean];
        }
        //去重
        for (unsigned i = 0 ; i< [dataArr count]; i ++) {
            if ( [_listArr containsObject:dataArr[i]]==NO) {
                [_listArr addObject:dataArr[i]];
            }
        }
        
        for (int i = 0; i < [_collectionArrays count]; i++)
        {
            DebtManagement *bean = [_collectionArrays objectAtIndex:i];
            
            NSMutableArray *arrData = [_listDic objectForKey:bean.time1];
            if (arrData == nil)
            {
                arrData = [[NSMutableArray alloc] initWithCapacity:1];
                [arrData addObject:bean];
            }else
                [arrData addObject:bean];
            [_listDic setObject:arrData forKey:bean.time1];
        }
        
        [_listView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
        [self pageCount:NO];// 页面计数失败
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    _isLoading = NO;
    
    [self hiddenRefreshView];
    
    
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    
    [self pageCount:NO];// 页面计数失败
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    
    _isLoading = NO;
   [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
    
    [self pageCount:NO];// 页面计数失败
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _currPage = 1;
    _total = 0;
    
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


#pragma 页面计数
/**
 页面计数，如果isCount == YES则应该计数
 
 否则，计数失败，当前页应该恢复原来数值
 */
-(void) pageCount:(BOOL)isCount
{
    if(isCount){
        // 计数成功，加载前已经+1了，不处理
    } else {
        // 加载失败，计数无效，当前页应该 -1 ，恢复原来数值
        if(_currPage > 1){
            _currPage --;
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
    if (_isLoading) {
        // 正在加载中退出，关闭下拉，上拉界面，计数恢复原值
        [self hiddenRefreshView];
        [self pageCount:NO];
    }
}


@end
