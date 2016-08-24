//
//  MyCollectionBorrowssViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-7.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我收藏的借款

#import "MyCollectionBorrowsViewController.h"
#import "ColorTools.h"
#import "CollectionBorrow.h"

#import "CollectionBorrowsTableViewCell.h"
#import "BorrowingDetailsViewController.h"


@interface MyCollectionBorrowsViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;
    
    NSInteger _section;
    NSInteger isOPT;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MyCollectionBorrowsViewController

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
 初始化数据
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

    self.view.backgroundColor = KblackgroundColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-104) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [_tableView headerBeginRefreshing];
    
}



#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    CollectionBorrowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CollectionBorrowsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CollectionBorrow *object = [_dataArrays objectAtIndex:indexPath.section];
    [cell fillCellWithObject:object];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.5f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//返回时取消选中状态

    CollectionBorrow *object = [_dataArrays objectAtIndex:indexPath.section];
    
    BorrowingDetailsViewController *BorrowingDetailsView = [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.borrowID = object.rowId;
    BorrowingDetailsView.HidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:BorrowingDetailsView animated:YES];
    
}

// 先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    CollectionBorrow *bean = _dataArrays[indexPath.section];
    
    _section = indexPath.section;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"153" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)bean.bidId] forKey:@"bidId"];
    
    isOPT = 153;
    if (_requestClient == nil) {
        
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData];
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    isOPT = 66;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"66" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
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
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if (isOPT == 66) {
            [_dataArrays removeAllObjects];// 清空全部数据
            
            NSArray *dataArr = [dics objectForKey:@"list"];
            for (NSDictionary *item in dataArr) {
                CollectionBorrow *bean = [[CollectionBorrow alloc] init];
                bean.title = [item objectForKey:@"title"];// 借款标题
                bean.rowId = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                if ([item objectForKey:@"small_image_filename"]!= nil && ![[item objectForKey:@"small_image_filename"]isEqual:[NSNull null]])
                {
                    if ([[item objectForKey:@"small_image_filename"] hasPrefix:@"http"]) {
                        
                        bean.type = [NSString stringWithFormat:@"%@", [item objectForKey:@"small_image_filename"]];// 借款标类型
                    }else{
                        
                        bean.type = [NSString stringWithFormat:@"%@%@", Baseurl, [item objectForKey:@"small_image_filename"]];// 借款标类型
                        
                    }
                }
            
                bean.status = [[item objectForKey:@"status"] intValue];// 状态
                if ([item objectForKey:@"creditLevel"]!=nil && ![[item objectForKey:@"creditLevel"] isEqual:[NSNull null]]) {
                    if ([[[item objectForKey:@"creditLevel"] objectForKey:@"imageFilename"] hasPrefix:@"http"]) {
                        
                        bean.creditLevel = [NSString stringWithFormat:@"%@",[[item objectForKey:@"creditLevel"] objectForKey:@"imageFilename"]];//信用等级
                    }else
                    {
                         bean.creditLevel = [NSString stringWithFormat:@"%@%@", Baseurl, [[item objectForKey:@"creditLevel"] objectForKey:@"imageFilename"]];//信用等级
                        
                    }
                   
                }
                
                bean.amount = [[item objectForKey:@"amount"] floatValue];// 借款金额
                bean.apr = [[item objectForKey:@"apr"] floatValue];// 年利率
                bean.period = [[item objectForKey:@"period"] floatValue]; // 周期
                bean.periodUnit = [[item objectForKey:@"period_unit"] intValue]; // 单位
                bean.productItemCount = [[item objectForKey:@"product_item_count"] intValue]; // 需要审核的资料
                bean.userItemCountTrue = [[item objectForKey:@"user_item_count_true"] intValue]; // 已经审核的资料
                
                bean.bidId = [[item objectForKey:@"bid_id"] intValue];
                
                [_dataArrays addObject:bean];
            }
            
            [_tableView reloadData];
            
        }else if (isOPT == 153) {
            [_dataArrays removeObjectAtIndex:_section];
            [_tableView deleteSections: [NSIndexSet indexSetWithIndex: _section] withRowAnimation:UITableViewRowAnimationBottom];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
        
    } else {
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
