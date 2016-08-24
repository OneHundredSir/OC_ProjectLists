//
//  FinancialBillsViewController.m
//  SP2P_6.1
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

@interface FinancialBillsViewController ()<DropDownChooseDelegate,DropDownChooseDataSource,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{

    NSMutableArray *chooseArray;
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
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   @[@"全部",@"未还款",@"已还款"],
                                                   @[@"全部",@"未逾期",@"已逾期"],
                                                   @[@"全部",@"标题"]
                                                   ]];
    
    // 初始化排序状态
    _payType = 0;
    _keyType = 0;
    _isOverType = 0;
    _currPage = 1;
    _collectionArrays =[[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [_listView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
    //下拉列表
    _dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,60, self.view.frame.size.width, 40) dataSource:self delegate:self];
    _dropDownView.backgroundColor =  SETCOLOR(230, 230, 230, 1.0);
    _dropDownView.mSuperView = self.view;
    [self.view addSubview:_dropDownView];
    
    //搜索
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 140, 40)];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.keyboardType =  UIKeyboardTypeDefault;
    self.navigationItem.titleView = _searchBar;
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
    
    if (_searchBar.text.length != 0)
    {
        _searchBar.text = @"";
        [self headerRereshing];
    }
    [_searchBar resignFirstResponder];
}

#pragma mark - UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _collectionArrays.count;
    
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
    FinancialBillsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[FinancialBillsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 有数据后启用
    FinancialBills *bean = _collectionArrays[indexPath.section];
    
    cell.titleLabel.text = bean.title;
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥ %.2f", bean.incomeAmounts];
    
    // 是否逾期
    if (bean.status == -2||bean.status == -3||bean.status == -4||bean.status == -6) {
        cell.overdueView.image = [UIImage imageNamed:@"state_exceed"];
        cell.overdueView.frame = CGRectMake(CGRectGetMinX(cell.titleLabel.frame), 30, 20, 20);
        cell.repayView.frame = CGRectMake(CGRectGetMaxX(cell.overdueView.frame) + 4, 30, 30, 20);
        cell.moneyLabel.frame = CGRectMake(80, 32, 200, 20);
    }else {
        cell.overdueView.image = nil;
        cell.overdueView.frame = CGRectMake(CGRectGetMinX(cell.titleLabel.frame), 30, 0, 0);
        cell.repayView.frame = CGRectMake(CGRectGetMaxX(cell.overdueView.frame), 30, 32, 20);
        cell.moneyLabel.frame = CGRectMake(60, 32, 200, 20);
    }
    
    // 状态
    if (bean.status == 0||bean.status == -3||bean.status == -4) {
        cell.repayView.image = [UIImage imageNamed:@"state_has_been"];
    }else {
        cell.repayView.image = [UIImage imageNamed:@"state_did_not"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 关闭筛选的窗口
//    DLOG(@"dropDown -> %ld", (long)_dropDownView->currentExtendSection);
    [_dropDownView hideExtendedChooseView];
    
    FinancialBills *financialBills = _collectionArrays[indexPath.section];
    
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
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
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
    DLOG(@"选了section:%ld ,xnd;;;ex:%ld",(long)section,(long)index);
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
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

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry = chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        
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
        
        // 清空全部数据
        if (_total == 1) {
            [_collectionArrays removeAllObjects];
        }

        _total = [[obj objectForKey:@"totalNum"] integerValue];
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

            [_collectionArrays addObject:bean];
        }
        
        [_listView reloadData];
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
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
