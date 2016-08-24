//
//  TranferSuccessedViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(转让债权管理) -> 已成功

#import "TranferSuccessedViewController.h"
#import "ColorTools.h"
#import "CreditorRightTransferDetailsViewController.h"
#import "TransferloanStandardDetailsViewController.h"

#import "NSString+Date.h"

@interface TranferSuccessedViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{

    NSArray *titlyArr;
    NSArray *dataArr;

}

@property (nonatomic, strong) UILabel *transferStatus;       // 转让状态
@property (nonatomic, strong) UILabel *transferType;          // 债权转让类型
@property (nonatomic, strong) UILabel *assigneeName;         // 受让方用户名
@property (nonatomic, strong) UILabel *successTransferTime;  // 成功转让时间
@property (nonatomic, strong) UILabel *collectCapital;       // 待收本金
@property (nonatomic, strong) UILabel *collectBid;           // 待收成交价

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TranferSuccessedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    [self initNavigationBar];
    
    [self requestData];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    titlyArr = @[@"转让状态:",@"转让方式:",@"受让方:",@"成功转让时间:",@"待收本金:",@"待收本金成交价:"];
    dataArr = @[@"债权转让详情",@"转让的借款标详情"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    self.view.backgroundColor = KblackgroundColor;

    for (int i = 0; i<[titlyArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10, 75+i*30, 120, 30);
        titleLabel.text = [titlyArr objectAtIndex:i];
        titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
        [self.view addSubview:titleLabel];
        
    }
    
    _transferStatus = [[UILabel alloc] initWithFrame:CGRectMake(80, 75, 200, 30)];
    _transferStatus.text = @"已成功";
    _transferStatus.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _transferStatus.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_transferStatus];
    
    _transferType = [[UILabel alloc] initWithFrame:CGRectMake(80, 105, 200, 30)];
    _transferType.text = @"";
    _transferType.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _transferType.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_transferType];
    
    
    _assigneeName = [[UILabel alloc] initWithFrame:CGRectMake(65, 135, 200, 30)];
    _assigneeName.text = @"";
    _assigneeName.font = [UIFont systemFontOfSize:15.0];
    _assigneeName.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_assigneeName];
    
    
    _successTransferTime = [[UILabel alloc] initWithFrame:CGRectMake(115, 165, 200, 30)];
    _successTransferTime.text = @"";
    _successTransferTime.font = [UIFont systemFontOfSize:15.0];
    _successTransferTime.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_successTransferTime];
    
    
    _collectCapital = [[UILabel alloc] initWithFrame:CGRectMake(80, 195, 200, 30)];
    _collectCapital.text = @"";
    _collectCapital.font = [UIFont systemFontOfSize:15.0];
    _collectCapital.textColor = [UIColor redColor];
    [self.view addSubview:_collectCapital];
    
    
    _collectBid = [[UILabel alloc] initWithFrame:CGRectMake(130, 225, 200, 30)];
    _collectBid.text = @"";
    _collectBid.font = [UIFont systemFontOfSize:15.0];
    _collectBid.textColor = [UIColor redColor];
    [self.view addSubview:_collectBid];
    
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
        
        [parameters setObject:@"46" forKey:@"OPT"];
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
        
        if ([[obj objectForKey:@"transferType"] integerValue] == 1) {
            _transferType.text = @"定向转让";
        }else {
            _transferType.text = @"竞价转让";
        }
        if ([obj objectForKey:@"successTransferTime"]!= nil && ![[obj objectForKey:@"successTransferTime"] isEqual:[NSNull null]]) {
        _successTransferTime.text = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"successTransferTime"]] substringWithRange:NSMakeRange(0, 19)];
        }else
         _successTransferTime.text = @"";
        
        _assigneeName.text = [obj objectForKey:@"assigneeName"];
        if (![[obj objectForKey:@"collectCapital"] isEqual:[NSNull null]]) {
            _collectCapital.text = [NSString stringWithFormat:@"%.2f  元", [[obj objectForKey:@"collectCapital"] floatValue]];
        }
        if (![[obj objectForKey:@"collectBid"] isEqual:[NSNull null]]) {
            _collectBid.text = [NSString stringWithFormat:@"%@  元", [obj objectForKey:@"collectBid"]];
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
  [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
