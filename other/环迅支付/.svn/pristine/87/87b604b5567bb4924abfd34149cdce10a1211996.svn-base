//
//  FinancialBillsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 —> 理财账单
#import "FinancialBillsViewController.h"

#import "ColorTools.h"
#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"
#import "FinancialBillsCell.h"

#import "FinancialBills.h"
#import "FBillDetailViewController.h"

@interface FinancialBillsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{

    NSMutableArray *_listArr;
    NSMutableDictionary *_listDic;
    NSMutableArray *_collectionArrays;
  
    
    int _payType ;
    int _isOverType ;
    int _keyType;
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数

}
@property (nonatomic,strong) UITableView *listView;
@property (nonatomic,strong)UISearchBar* searchBar;
@property (nonatomic,strong)DropDownListView *dropDownView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation FinancialBillsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.  // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 * 初始化数据
 */
- (void)initData
{
    
    // 初始化排序状态
    _payType = 0;
    _keyType = 0;
    _isOverType = 0;
    _currPage = 1;
    _collectionArrays =[[NSMutableArray alloc] init];
    _listArr = [[NSMutableArray alloc] init];
    _listDic = [[NSMutableDictionary alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor redColor];
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
    

    //搜索
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 140, 40)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.keyboardType =  UIKeyboardTypeDefault;
    self.navigationItem.titleView = _searchBar;
    [self headerRereshing];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];

    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条取消按钮(退出搜索键盘)
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    cancelItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:cancelItem];
    
}

- (void)cancelClick {
    [_searchBar resignFirstResponder];
}

#pragma mark - UItableView代理
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
    FinancialBillsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[FinancialBillsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    NSString *key = [_listArr objectAtIndex:indexPath.section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    // 有数据后启用
    FinancialBills *bean = array[indexPath.row];
    
    cell.titleLabel.text = bean.title;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", bean.incomeAmounts];
    cell.timeLabel.text = bean.time;
    // 是否逾期
    if (bean.status == -2||bean.status == -3||bean.status == -4||bean.status == -6) {
        cell.overdueView.image = [UIImage imageNamed:@"state_exceed"];
        cell.overdueView.frame = CGRectMake(CGRectGetMinX(cell.moneyLabel.frame), 30, 20, 20);
        cell.repayView.frame = CGRectMake(CGRectGetMaxX(cell.overdueView.frame) + 4, 30, 30, 20);
//        cell.moneyLabel.frame = CGRectMake(80, 32, 200, 20);
    }else {
        cell.overdueView.image = nil;
        cell.overdueView.frame = CGRectMake(CGRectGetMinX(cell.moneyLabel.frame), 30, 0, 0);
        cell.repayView.frame = CGRectMake(CGRectGetMaxX(cell.overdueView.frame), 30, 32, 20);
//        cell.moneyLabel.frame = CGRectMake(60, 32, 200, 20);
    }
    
    // 状态
    if (bean.status == 0||bean.status == -3||bean.status == -4) {
        cell.repayView.image = [UIImage imageNamed:@"state_has_been"];
    }else if(bean.status == -7){
        cell.repayView.image = [UIImage imageNamed:@"state_trantf"];
        cell.userInteractionEnabled = NO;
    }else {
        cell.repayView.image = [UIImage imageNamed:@"state_did_not"];
        
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSString *key = [_listArr objectAtIndex:section];
    return key;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 关闭筛选的窗口
//    DLOG(@"dropDown -> %ld", (long)_dropDownView->currentExtendSection);
//    [_dropDownView hideExtendedChooseView];
    
    NSString *key = [_listArr objectAtIndex:indexPath.section];
    //获取分组里面的数组
    NSMutableArray *array =[_listDic objectForKey:key];
    // 有数据后启用
    FinancialBills *financialBills = array[indexPath.row];
    
//    FinancialBills *financialBills = _collectionArrays[indexPath.section];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FBillDetailViewController *fBillDetailsView = [[FBillDetailViewController alloc] init];
    fBillDetailsView.sign = financialBills.sign;
    [self.navigationController pushViewController:fBillDetailsView animated:YES];
    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
      [self dismissViewControllerAnimated:YES completion:^(){}];
    
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
        
        [_collectionArrays removeAllObjects];
        [parameters setObject:@"35" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"payType"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _isOverType] forKey:@"isOverType"];
        [parameters setObject:[NSString stringWithFormat:@"%d", _payType] forKey:@"keyType"];
        [parameters setObject:searchBar.text forKey:@"key"];
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
    DLOG(@"选了section:%ld ,xnd;;;ex:%ld",section,(long)index);
    
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
    
    [_collectionArrays removeAllObjects];
    [parameters setObject:@"35" forKey:@"OPT"];
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
    
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [_listView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self hiddenRefreshView];
//    });
}


/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"35" forKey:@"OPT"];
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
        
//        // 2.2秒后刷新表格UI
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 刷新表格
//            [_listView reloadData];
//            
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self hiddenRefreshView];
//        });
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
  
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        [_listDic removeAllObjects];
        
        // 清空全部数据
        if (_total == 1) {
            [_collectionArrays removeAllObjects];
            [_listArr removeAllObjects];
        }

        _total = [[obj objectForKey:@"totalNum"] integerValue];
        NSMutableArray *dataArr = [NSMutableArray array];
        NSArray *collections = [obj objectForKey:@"list"];
        for (NSDictionary *item in collections) {
            FinancialBills *bean = [[FinancialBills alloc] init];

            bean.title =  [item objectForKey:@"title"];
            bean.userId = [item objectForKey:@"user_id"];
            bean.incomeAmounts = [[item objectForKey:@"income_amounts"] floatValue];
            bean.sign = [item objectForKey:@"sign"];
            // 还款状态（-3，-4,0已收款，否则未收款）
            // 是否逾期（-2,-3,-4,-6是逾期 否则不逾期）
            bean.status =  [[item objectForKey:@"status"] intValue];         // 状态、是否逾期
            bean.kId = [item objectForKey:@"id"];
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"repayment_time"] objectForKey:@"time"] doubleValue]/1000];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd"];
             bean.time  = [dateFormat stringFromDate: date];
            
            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"yyyy年MM月"];
            bean.time1 = [dateFormat2 stringFromDate:date];
            [dataArr addObject:bean.time1];
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
            FinancialBills *bean = [_collectionArrays objectAtIndex:i];
            
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
