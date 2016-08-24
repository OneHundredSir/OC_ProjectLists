//
//  AJDailyManagerController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//
#define ktabHeaderHeight 570.f/2 - 64
#define kButtonColor SETCOLOR(235,235,235,1.0)
#import "AJDailyManagerController.h"
#import "AJDailyManagerHeader.h"
#import "AJTransferFooter.h"// 尾部，名字起错了
#import "AJTransferController.h"
#import "AJInterstductionController.h"
#import "AJAddController.h"
//#import "AJDailyEarningRepayController.h"
#import "AJDailyManagerHeaderData.h"
#import "AJTransferFatherController.h"

@interface AJDailyManagerController ()<UITableViewDataSource, UITableViewDelegate, HTTPClientDelegate>
@property (nonatomic, strong) NSMutableArray *cellTitles;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) AJDailyManagerHeaderData *headerData;
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, weak) UIButton *coverView;
@end

@implementation AJDailyManagerController

- (NSArray *)arrTitles
{
    if (_arrTitles == nil) {
        _arrTitles = @[@[@"产品说明", @"交易记录"], @[@"产品说明", @"交易记录", @"日利宝还款"]];
    }
    return _arrTitles;
}

- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}
- (NSMutableArray *)cellTitles
{
    if (_cellTitles == nil) {
        _cellTitles = [NSMutableArray array]; // WithObjects;//WithArray:@[@"产品说明", @"加入记录"/*, @"相关资料", @"日利宝还款"*/]];
    }
    return _cellTitles;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self requestData];
}
- (void)initView
{
     self.title = @"日利宝管理";
    // 顶部标题 和返回按钮
    CGFloat selfW = self.view.bounds.size.width;
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfW, 64)];
    navView.backgroundColor = KColor;
    [self.view addSubview:navView];
    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, selfW, 44)];
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:title];
    title.text = self.title;
    // 返回按钮
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normal = [UIImage imageNamed:@"nav_back"];
    [back setImage:normal forState:UIControlStateNormal];
    [back setImage:normal forState:UIControlStateHighlighted];
    CGFloat backH =  2*normal.size.height;
    CGFloat backY = (44 -  backH)/2 + 20;
    back.frame = CGRectMake(10, backY, normal.size.width, 2*normal.size.height);
    [back addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];
    
    // 没有网络时的遮盖图
    UIButton *cover = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navView.frame), selfW, self.view.bounds.size.height - 64)];
    [self.view addSubview:cover];
    cover.backgroundColor = KblackgroundColor;
    self.coverView = cover;
    NSString *netErrorTip = @"网络异常";
    [cover setTitle:netErrorTip forState:UIControlStateNormal];
    [cover setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cover addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, selfW, self.view.bounds.size.height -64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = KblackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    [tableView addHeaderWithCallback:^{
        [weakSelf requestData];
    }];
    
    AJDailyManagerHeader *header = [[AJDailyManagerHeader alloc] init];
    header.frame = CGRectMake(0, 0, 0, ktabHeaderHeight);
    self.tableView.tableHeaderView = header;
    
    AJTransferFooter *footer = [[AJTransferFooter alloc] initWithFrame:CGRectMake(0, 0, selfW, 168.f/2) btnClickblock:^(UIButton *sender) {
        AJTransferController *controller = [[AJTransferController alloc] init];
        controller.title = sender.titleLabel.text;
        [controller setValue:weakSelf.headerData forKeyPath:@"lastViewheaderData"];
        [weakSelf.navigationController pushViewController:controller animated:YES];
//        if ([sender.titleLabel.text isEqualToString:@"转出"]) {
//           
//        }else if([sender.titleLabel.text isEqualToString:@"转人"]) {
//            
//        }
    }];
    self.tableView.tableFooterView = footer;
    [self.view bringSubviewToFront:cover];
    cover.hidden = YES;
}
-(void)requestData
{
    //2.1获取投资列表信息，包含投资列表。[OK]
    //        [_dataArrays removeAllObjects];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.1获取投资列表信息，包含投资列表。[OK]
    [parameters setObject:@"" forKey:@"body"];
//    [parameters setObject:@"179" forKey:@"OPT"];// 179日利宝首页信息
    parameters[@"OPT"] = @"179";
    parameters[@"userId"] = AppDelegateInstance.userInfo.userId ;
    NSLog(@"%@", AppDelegateInstance.userId);
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)btnClick:(UIButton *)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.cellTitles[indexPath.section];
    cell.textLabel.textColor = [ColorTools colorWithHexString:kTextColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {//产品说明
        AJInterstductionController *controller = [[AJInterstductionController alloc] init];
        controller.title = self.cellTitles[indexPath.section];
        [controller setValue:self.headerData forKey:@"data"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(indexPath.section == 1){//交易记录
        AJAddController *controller = [[AJAddController alloc] init];
        controller.title = self.cellTitles[indexPath.section];
        [self.navigationController pushViewController:controller animated:YES];
    }else{//日利宝还款
        AJTransferFatherController *controller = [[AJTransferFatherController alloc] init];
        controller.title = self.cellTitles[indexPath.section];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 42.f/2;
    }
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f/2;
}
#pragma mark - HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        
        self.headerData = [[AJDailyManagerHeaderData alloc] initWithDict:dics];
        AJDailyManagerHeader *header = (AJDailyManagerHeader *)self.tableView.tableHeaderView;
        header.aAJDailyManagerHeaderData = self.headerData;
        if ([self.headerData .isBorrower intValue] == 1) {//是否已经借款，是则显示日利宝还款
            
            self.cellTitles = self.arrTitles[1];
//            if (self.cellTitles.count == 2) {
//                [self.cellTitles addObject:@"日利宝还款"];
//            }
        }else{
            self.cellTitles = self.arrTitles[0];
//            if (self.cellTitles.count == 3) {
//                [self.cellTitles removeObject:@"日利宝还款"];
//            }
        }
        [self.tableView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
        self.coverView.hidden = YES;
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    self.coverView.hidden = YES;
}

// 无可用的网络
-(void) networkError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    self.coverView.hidden = YES;
}

@end
