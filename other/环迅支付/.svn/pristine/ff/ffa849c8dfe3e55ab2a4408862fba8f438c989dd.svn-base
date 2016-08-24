//
//  TranferNoPassViewController.m
//  SP2P_7
//
//  Created by kiu on 14-10-13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(转让债权管理) -> 不通过

#import "TranferNoPassViewController.h"
#import "ColorTools.h"
#import "CreditorRightTransferDetailsViewController.h"
#import "TransferloanStandardDetailsViewController.h"

@interface TranferNoPassViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate>
{
    
    NSArray *titlyArr;
    NSArray *dataArr;
    
}

@property (nonatomic, strong) UILabel *auditResult;       // 审核结果
@property (nonatomic, strong) UILabel *auditTime;         // 审核时间
@property (nonatomic, strong) UILabel *nopassReason;      // 不通过原因

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TranferNoPassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self requestData];
}

/**
 * 初始化数据
 */
- (void)initData
{
    
    titlyArr = @[@"审核结果:",@"审核时间:",@"不通过原因:"];
    dataArr = @[@"债权转让详情",@"转让的借款标详情"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    for (int i = 0; i<[titlyArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(20, 105+i*30, 120, 30);
        titleLabel.text = [titlyArr objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.view addSubview:titleLabel];
        
    }
    
    
    _auditResult = [[UILabel alloc] initWithFrame:CGRectMake(85, 105, 200, 30)];
    _auditResult.text = @"不通过";
    _auditResult.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _auditResult.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_auditResult];
    
    _auditTime = [[UILabel alloc] initWithFrame:CGRectMake(90, 135, 200, 30)];
    _auditTime.text = @"2014-10-10  09:20:20";
    _auditTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _auditTime.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_auditTime];
    
    
    _nopassReason = [[UILabel alloc] initWithFrame:CGRectMake(100, 165, 200, 100)];
    _nopassReason.text = @"此借款人信用很高,无需但是还款情况。";
    _nopassReason.numberOfLines = 0;
    _nopassReason.lineBreakMode = NSLineBreakByCharWrapping;
    _nopassReason.font = [UIFont systemFontOfSize:14.0];
    _nopassReason.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_nopassReason];
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-75, self.view.frame.size.width, 70) style:UITableViewStyleGrouped];
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.separatorColor = [UIColor grayColor];
    listView.delegate = self;
    listView.scrollEnabled = NO;
    listView.dataSource = self;
    [self.view  addSubview:listView];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.navigationItem.title = @"详情";
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
    
    return [dataArr count];
    
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
    return 30.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.section];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            CreditorRightTransferDetailsViewController *creditorRightTransferDetailsView =[[CreditorRightTransferDetailsViewController alloc] init];
            creditorRightTransferDetailsView.sign = _sign;
            [self.navigationController pushViewController:creditorRightTransferDetailsView animated:YES];
        }
            break;
            
        case 1:
        {
            TransferloanStandardDetailsViewController *transferloanStandardDetailsView =[[TransferloanStandardDetailsViewController alloc]init];
            transferloanStandardDetailsView.sign = _sign;
            [self.navigationController pushViewController:transferloanStandardDetailsView animated:YES];
            
        }
            break;
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
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"48" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_sign forKey:@"sign"];
        
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

}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        if (![[obj objectForKey:@"successTransferTime"] isEqual:[NSNull null]]) {
            _auditTime.text = [NSString converDate:[obj objectForKey:@"successTransferTime"] withFormat:@"yyyy-MM-dd hh-mm-ss"];
        }
        
        if (![[obj objectForKey:@"nopassReason"] isEqual:[NSNull null]]) {
            _nopassReason.text = [obj objectForKey:@"nopassReason"];
        }
        
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
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
