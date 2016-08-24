//
//  LoanViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我要借款
//

#import "LoanViewController.h"

#import "BarButtonItem.h"
#import "ColorTools.h"
#import "LoanType.h"

#import "LoanTypeTableViewCell.h"
#import "UIFolderTableView.h"
#import "ApplicationRequirementsViewController.h"
#import "CreditBorrowingScaleViewController.h"
#import "CacheUtil.h"


#define kIS_IOS7 (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)


@interface LoanViewController ()<UITableViewDelegate,UITableViewDataSource,HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;
   
}
@property (nonatomic, strong) UIFolderTableView *tableView;
@property (nonatomic, strong) ApplicationRequirementsViewController *ApplicationRequirementsView;
@property (nonatomic,strong)NSIndexPath *indexPathnum;
@property (nonatomic,copy)NSString *loanFileName;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation LoanViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化视图
    [self initView];

    // 初始化数据
    [self initData];
    
}



/**
 初始化数据
 */
- (void)initData
{
    
    _collectionArrays =[[NSMutableArray alloc] init];
    

}
/**
 初始化数据
 */
- (void)initView
{
    self.title = NSLocalizedString(@"Tab_Loan", nil);
    
    [self initNavigationBar];
    
    _tableView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.backgroundColor = KblackgroundColor;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
  
    [self requestData];
    
}


-(void)requestData
{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //3.1客户端借款标产品列表接口
    [parameters setObject:@"18" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
     _loanFileName = [CacheUtil creatCacheFileName:parameters];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    

    
}

- (void)initNavigationBar
{
    BarButtonItem *leftButton = [BarButtonItem barItemWithImage:[UIImage imageNamed:@"ic_account_normal"] selectedImage:[UIImage imageNamed:@"ic_account_normal"] target:self action:@selector(leftClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];// 左边导航按钮
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:KColor];
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
//    [self readCache];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
   [self processData:obj isCache:NO];// 读取当前请求到的数据
  
}



-(void) processData:(NSDictionary *)dataDics isCache:(BOOL) isCache
{

      [self hiddenRefreshView];
    DLOG(@"dataDics is %@",dataDics);
    if ([[NSString stringWithFormat:@"%@",[dataDics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        if(!isCache){
            // 非缓存数据，且返回的是-1 成功的数据，才更新数据源，否则不保存
            NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cachePath = [path stringByAppendingPathComponent:_loanFileName];// 合成归档保存的完整路径
            [NSKeyedArchiver archiveRootObject:dataDics toFile:cachePath];// 数据归档，存取缓存
            
        }
        
        
        
        NSArray *collections = [dataDics objectForKey:@"list"];
        if ([collections count]==0) {
            
            [SVProgressHUD showErrorWithStatus:@"无数据"];
        }
        else{
            [_collectionArrays removeAllObjects];
            DLOG(@"collections count is %lu",(unsigned long)[collections count]);
            for (NSDictionary *item in collections) {
                LoanType *bean = [[LoanType alloc] init];
                bean.name = [item objectForKey:@"name"];
                bean.ID  = [NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                bean.des =  [item objectForKey:@"fitCrowd"];  //适合人群
                bean.minAmount = [NSString stringWithFormat:@"%@",[item objectForKey:@"minAmount"]];
                bean.maxAmount = [NSString stringWithFormat:@"%@",[item objectForKey:@"maxAmount"]];
                if ([item objectForKey:@"smallImageFilename"]!= nil && ![[item objectForKey:@"smallImageFilename"]isEqual:[NSNull null]])
                {
                    if ([[item objectForKey:@"smallImageFilename"] hasPrefix:@"http"]) {
                        
                        bean.imageurl =  [item objectForKey:@"smallImageFilename"];
                    }else{
                        
                        bean.imageurl =  [NSString stringWithFormat:@"%@%@",Baseurl,[item objectForKey:@"smallImageFilename"]];
                    }
                }
               
                bean.applicantCondition = [item objectForKey:@"applicantCondition"];
                [_collectionArrays addObject:bean];
            }
        
                // 刷新表格
            [self.tableView reloadData];
                
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView headerEndRefreshing];
            
        }
    }
    else{
        [self hiddenRefreshView];
       if (!isCache) {
        DLOG(@"返回失败===========%@",[dataDics objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDics objectForKey:@"msg"]]];
       }
    }
}
// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    
    [self hiddenRefreshView];
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    
     [self readCache];
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    [self hiddenRefreshView];
    [self readCache];

}

- (void)readCache
{
    // 刷新前先加载缓存数据
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingPathComponent:_loanFileName];// 合成归档保存的完整路径
    DLOG(@"path is %@",cachePath);
    NSDictionary *dics = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];// 上一次缓存数据
    [self processData:dics isCache:YES];// 读取上一次成功缓存的数据

}



- (void)leftClick:(id)sender{
    
    [self performSelector:@selector(presentLeftMenuViewController:) withObject:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _collectionArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    LoanTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[LoanTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    if (kIS_IOS7) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
//    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    LoanType *object = [_collectionArrays objectAtIndex:indexPath.section];
    [cell fillCellWithObject:object];
    
    [cell.expanBtn setTag:indexPath.section];
    [cell.expanBtn  addTarget:self action:@selector(expanBtnClick:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LoanTypeTableViewCell rowHeightForObject:[_collectionArrays objectAtIndex:indexPath.row]];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     LoanType *loanModel = [_collectionArrays objectAtIndex:indexPath.section];
    CreditBorrowingScaleViewController *creditBorrowingScaleView = [[CreditBorrowingScaleViewController alloc] init];
    creditBorrowingScaleView.productId = loanModel.ID;
    creditBorrowingScaleView.titleStr = loanModel.name;
    creditBorrowingScaleView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:creditBorrowingScaleView animated:YES];
     
}
#pragma mark 展开按钮
- (void)expanBtnClick:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = 0;
    }
    UITableViewCell *cell;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
       cell = (UITableViewCell *)[btn superview];
    }else
        cell = (UITableViewCell *)[[btn superview] superview];
    NSIndexPath *index1 = [_tableView indexPathForCell:cell];
    
    DLOG(@"index1.setion is %ld",(long)index1.section);
    UIFolderTableView *folderTableView = (UIFolderTableView *)_tableView;
     LoanType *loanModel = [_collectionArrays objectAtIndex:index1.section];
    _ApplicationRequirementsView = [[ApplicationRequirementsViewController alloc] init];
    _ApplicationRequirementsView.applyStr = loanModel.applicantCondition;
    _ApplicationRequirementsView.minAmount = loanModel.minAmount;
    _ApplicationRequirementsView.maxAmount = loanModel.maxAmount;
    
    self.tableView.scrollEnabled = NO;
   [folderTableView openFolderAtIndexPath:index1 WithContentView:_ApplicationRequirementsView.view
                                openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                       btn.selected = !btn.selected;
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                  
                                }
                           completionBlock:^{
                               // completed actions
                               _tableView.scrollEnabled = YES;
                               
                           }];

}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

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

@end
