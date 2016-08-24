//
//  BorrowingBillViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心---》借款子账户----》借款账单
#import "BorrowingBillViewController.h"

#import "ColorTools.h"
#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"

#import "BorrowingBillTableViewCell.h"
#import "BillingDetailsViewController.h"

#import "BorrowingBill.h"
#import "TabViewController.h"

// 还款状态	-1，-2未还款,否则为已还款
#define Repayment_None1 -1
#define Repayment_None2 -2

// overdue	逾期状态	0不是, 其他为逾期
#define Overdue_None 0


@interface BorrowingBillViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate>
{
    
    NSMutableArray *_listArr;
    NSMutableDictionary *_listDic;
    
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
    
    int _payType ;
    int _isOverType ;
    int _keyType;

}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)UISearchBar* searchBar;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation BorrowingBillViewController
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
 
    _payType = 0;
    _keyType = 0;
    _isOverType = 0;
    _currPage = 1;
    _dataArrays = [[NSMutableArray alloc] init];
    _listArr = [[NSMutableArray alloc] init];
    _listDic = [[NSMutableDictionary alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor greenColor];
    
    //搜索
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 140, 40)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.keyboardType =  UIKeyboardTypeDefault;
    _searchBar.text = @"";
    self.navigationItem.titleView = _searchBar;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
    if (AppDelegateInstance.userInfo != nil) {
        
        [self headerRereshing];
    }
       // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"BorrowingBillSuccess" object:nil];
    
//    //下拉列表
//    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,60, self.view.frame.size.width, 40) dataSource:self delegate:self];
//    dropDownView.backgroundColor = [UIColor whiteColor];
//    dropDownView.mSuperView = self.view;
//    [self.view addSubview:dropDownView];
    
}

// 调用通知，刷新数据。
-(void) updateTable:(id)obj
{
//    [_tableView headerBeginRefreshing];
    [self headerRereshing];
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 共多少条数据
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
    BorrowingBillTableViewCell *cell = [BorrowingBillTableViewCell cellWithTableView:tableView];
    
    NSString *key = [_listArr objectAtIndex:indexPath.section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    // 有数据后启用
    BorrowingBill *bean = array[indexPath.row];
    
    cell.aBorrowingBill = bean;
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
    BorrowingBill *bean  = array[indexPath.row];

    BillingDetailsViewController *billingDetailsView = [[BillingDetailsViewController alloc] init];
    
    billingDetailsView.billId = bean.sign;
    
    if (bean.status == Repayment_None1 || bean.status == Repayment_None2)
    { // 未还款
        if (bean.checkPeriod > 0)// 只能查看暂不能还
        {
            billingDetailsView.isPay = YES;
        }else{// 需要还款
            billingDetailsView.isPay = NO;
        }
    }else {// 已还款
        billingDetailsView.isPay = YES;
    }
    
    [self.navigationController pushViewController:billingDetailsView animated:YES];

}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条取消按钮(退出搜索键盘)
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    cancelItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:cancelItem];

}

- (void)cancelClick {
    [_searchBar resignFirstResponder];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    if (_curr == 1) {
//        [self dismissViewControllerAnimated:YES completion:^(){}];
//        TabViewController *tabViewController = [[TabViewController alloc] init];
         TabViewController *tabViewController = [TabViewController shareTableView];
        self.frostedViewController.contentViewController = tabViewController;
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma 搜索点击触发方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    DLOG(@"点击了搜索按钮");
    [searchBar resignFirstResponder];
    
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [_dataArrays removeAllObjects];
        [parameters setObject:@"87" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"payType"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _isOverType] forKey:@"isOverType"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"keyType"];
        [parameters setObject:_searchBar.text forKey:@"key"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    DLOG(@"选了section:%ld ,xnd;ex:%ld",(long)section,(long)index);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    switch (section) {
        case 0:
            
            _payType = (int)index;
            
            break;
        case 1:
            
            _isOverType = (int)index;
            
            break;
        case 2:
            
            _keyType = (int)index;
            
            
        default:
            break;
    }
    
    [_dataArrays removeAllObjects];
    [parameters setObject:@"87" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"payType"];
    [parameters setObject:[NSString stringWithFormat:@"%d", _isOverType] forKey:@"isOverType"];
    [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"keyType"];
    [parameters setObject:_searchBar.text forKey:@"key"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}


#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        
        [self hiddenRefreshView];
        [ReLogin outTheTimeRelogin:self];
        return;
        
    }else {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"87" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"payType"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _isOverType] forKey:@"isOverType"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"keyType"];
        [parameters setObject:_searchBar.text forKey:@"key"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma 

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

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    
      [_listDic removeAllObjects];
    if (_currPage == 1) {
        [_dataArrays removeAllObjects];// 清空全部数据
        [_listArr removeAllObjects];
    }
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *dataArr = [[dics objectForKey:@"page"] objectForKey:@"page"];
        _total = [[[dics objectForKey:@"page"] objectForKey:@"totalCount"] intValue];// 总共多少条
        
        NSMutableArray *dataArr1 = [NSMutableArray array];
        for (NSDictionary *item in dataArr) {
            BorrowingBill *bean = [[BorrowingBill alloc] init];

            bean.title = [item objectForKey:@"title"];
            bean.sign = [item objectForKey:@"sign"];
            bean.isOverdue = [[item objectForKey:@"is_overdue"] intValue];//逾期状态	0不是,1是
            bean.status = [[item objectForKey:@"status"] intValue];// 还款状态	-1，-2未还款,否则为已还款
            bean.repaymentAmount = [[item objectForKey:@"repayment_amount"] floatValue];// 本期需还款金额
            bean.checkPeriod = [[item objectForKey:@"chechPeriod"]intValue];//检查期数
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"repayment_time"] objectForKey:@"time"] doubleValue]/1000];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd"];
            bean.time  = [dateFormat stringFromDate: date];
            
            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"yyyy年MM月"];
            bean.time1 = [dateFormat2 stringFromDate:date];
            [dataArr1 addObject:bean.time1];
            
            [_dataArrays addObject:bean];
        }
        
        //去重
        for (unsigned i = 0 ; i< [dataArr1 count]; i ++) {
            if ( [_listArr containsObject:dataArr1[i]]==NO) {
                [_listArr addObject:dataArr1[i]];
            }
        }
        
        for (int i = 0; i < [_dataArrays count]; i++)
        {
            BorrowingBill *bean = [_dataArrays objectAtIndex:i];
            
            NSMutableArray *arrData = [_listDic objectForKey:bean.time1];
            if (arrData == nil)
            {
                arrData = [[NSMutableArray alloc] initWithCapacity:1];
                [arrData addObject:bean];
            }else
                [arrData addObject:bean];
            [_listDic setObject:arrData forKey:bean.time1];
        }
        
        [_tableView reloadData];
        
    } else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        // 服务器返回数据异常
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
