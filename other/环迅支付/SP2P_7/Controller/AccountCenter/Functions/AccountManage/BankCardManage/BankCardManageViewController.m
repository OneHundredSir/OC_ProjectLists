//
//  BankCardManageViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》银行卡管理
#import "BankCardManageViewController.h"
#import "AddBankVCardViewController.h"
#import "BankCardInfo.h"
#import "ColorTools.h"
#import "SendValuedelegate.h"
#import "BankCardManageCell.h"
#import <QuartzCore/QuartzCore.h>

#import "BankCard.h"
#import "TabViewController.h"
@interface BankCardManageViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;        // 数据
    
    NSInteger _total;                   // 总的数据
    
    NSInteger _currPage;                // 查询的页数
    
    NSInteger isOPT;
    
    NSInteger _section;
}

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation BankCardManageViewController

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
    self.view.backgroundColor = KblackgroundColor;
    //初始化添加银行卡视图控制器


    //列表视图控制器
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateTable:) name:AddBankCardSuccess object:nil];
}

-(void) updateTable:(id)obj
{
//    [_tableView headerBeginRefreshing];
    [self headerRereshing];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"银行卡";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条右边按钮
    UIBarButtonItem *AddItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_bankcard"] style:UIBarButtonItemStyleDone target:self action:@selector(addClick)];
    AddItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:AddItem];
    
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 4.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    BankCard *bean = _dataArrays[indexPath.section];
    
    _section = indexPath.section;
    
//    [_dataArrays removeObjectAtIndex:indexPath.section];
//    [tableView deleteSections: [NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"133" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)bean.bankCardId] forKey:@"accountId"];
    
    isOPT = 133;
    if (_requestClient == nil) {
        
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.section];
    BankCardManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[BankCardManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.showsReorderControl =YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BankCard *object = _dataArrays[indexPath.section];
     [cell fillCellWithObject:object];

    [cell.editBtn setTag:indexPath.section];
    [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}


#pragma 返回按钮触发方法
- (void)backClick
{
    _tableView.editing = UITableViewCellEditingStyleNone;
    if (self.backTypeNum) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
//        TabViewController *tabViewController = [[TabViewController alloc] init];
        TabViewController *tabViewController = [TabViewController shareTableView];
        [self.frostedViewController presentMenuViewController];
        self.frostedViewController.contentViewController = tabViewController;
        
        
    }
    
}

#pragma mark 添加银行卡
- (void)addClick
{
    AddBankVCardViewController *addBankVCardView = [[AddBankVCardViewController alloc] init];
    [addBankVCardView setBankCard:nil];
    [addBankVCardView setEditType:BankCardEditAdd];
    [self.navigationController pushViewController:addBankVCardView animated:YES];
}

#pragma mark 编辑银行卡
- (void)editBtnClick:(id) sender
{
    UIButton *button = sender;
    BankCard *bean = _dataArrays[button.tag];
    AddBankVCardViewController *editBankCardView = [[AddBankVCardViewController alloc] init];
    [editBankCardView setEditType:BankCardEditModify];
    [editBankCardView setBankCard:bean];
    [self.navigationController pushViewController:editBankCardView animated:YES];
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    // 账号：1  密码：1
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"98" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    isOPT = 98;
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
        
        if (isOPT == 98) {
            if (_total == 1) {
                [_dataArrays removeAllObjects];
            }
            
            _total = [[dics objectForKey:@"totalNum"] intValue];// 总共多少条
            
            NSArray *dataArr = [dics objectForKey:@"userBanks"];
            for (NSDictionary *item in dataArr) {
                BankCard *bean = [[BankCard alloc] init];
                
                bean.bankName = [item objectForKey:@"bankName"];
                bean.account = [NSString stringWithFormat:@"**** **** **** %@",[[item objectForKey:@"account"] substringWithRange:NSMakeRange([[item objectForKey:@"account"] length]-4, 4)]];
//                bean.branchBankName = [item objectForKey:@"branchBankName"];
                bean.bankCardId = [[item objectForKey:@"id"] intValue];
                [_dataArrays addObject:bean];
            }
            
            [_tableView reloadData];
        }else if (isOPT == 133) {
            [_dataArrays removeObjectAtIndex:_section];
            [_tableView deleteSections: [NSIndexSet indexSetWithIndex: _section] withRowAnimation:UITableViewRowAnimationBottom];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
         [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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
    [self hiddenRefreshView];
//    _currPage++;
//    
//    [self requestData];
    
}

#pragma Hidden View

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_tableView.isHeaderHidden) {
        [_tableView headerEndRefreshing];
    }
    
    if (!_tableView.isFooterHidden) {
        [_tableView footerEndRefreshing];
    }
}


@end
