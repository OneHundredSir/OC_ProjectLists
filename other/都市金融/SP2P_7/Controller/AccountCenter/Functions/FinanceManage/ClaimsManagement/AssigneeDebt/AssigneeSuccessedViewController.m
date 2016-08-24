//
//  AssigneeSuccessedViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(受让债权管理) -> 已成功

#import "AssigneeSuccessedViewController.h"
#import "ColorTools.h"
#import "CreditorRightAssigneeDetailsViewController.h"
#import "AssigneeLoanStandardDetailsViewController.h"

@interface AssigneeSuccessedViewController ()<UITableViewDelegate,UITableViewDataSource, HTTPClientDelegate>
{
    
    NSArray *titlyArr;
    NSArray *dataArr;
    
}

@property (nonatomic, strong) UILabel *stateLabel;    // 受让状态
@property (nonatomic, strong) UILabel *assigneeName;    // 受让人
@property (nonatomic, strong) UILabel *wayLabel;      // 受让方式
@property (nonatomic, strong) UILabel *timeLabel;     // 成功转让时间
@property (nonatomic, strong) UILabel *capitalLabel;  // 待收本金
@property (nonatomic, strong) UILabel *bidLabel;  // 待收本金成交价

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AssigneeSuccessedViewController

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
    
    titlyArr = @[@"受让状态:",@"受让方式:",@"转让人:",@"成功转让时间:",@"待收本金:",@"待收本金成交价:"];
    dataArr = @[@"债权受让详情",@"受让的借款标详情"];
    
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
        titleLabel.frame = CGRectMake(20, 75+i*30, 120, 30);
        titleLabel.text = [titlyArr objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.view addSubview:titleLabel];
        
    }
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 75, 200, 30)];
    _stateLabel.text = @"已成功";
    _stateLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _stateLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_stateLabel];
    
    _wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 105, 200, 30)];
    _wayLabel.text = @"";
    _wayLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _wayLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_wayLabel];
    
    _assigneeName = [[UILabel alloc] initWithFrame:CGRectMake(80, 135, 200, 30)];
    _assigneeName.text = @"";
    _assigneeName.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _assigneeName.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_assigneeName];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 165, 200, 30)];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont systemFontOfSize:15.0];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_timeLabel];
    
    _capitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 195, 200, 30)];
    _capitalLabel.text = @"";
    _capitalLabel.font = [UIFont systemFontOfSize:15.0];
    _capitalLabel.textColor = PinkColor;
    [self.view addSubview:_capitalLabel];
    
    _bidLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 225, 200, 30)];
    _bidLabel.text = @"";
    _bidLabel.font = [UIFont systemFontOfSize:15.0];
    _bidLabel.textColor = PinkColor;
    [self.view addSubview:_bidLabel];
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-75, self.view.frame.size.width, 70) style:UITableViewStyleGrouped];
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.separatorColor = [UIColor grayColor];
    listView.delegate = self;
    listView.scrollEnabled = NO;
    listView.dataSource = self;
    [self.view  addSubview:listView];
    
    for (UIView *view in self.view.subviews) {
        CGRect frame = view.frame;
        frame.origin.y -= 64.f;
        view.frame = frame;
    }
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.navigationItem.title = @"详情";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
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
            CreditorRightAssigneeDetailsViewController *creditorRightAssigneeDetailsView = [[CreditorRightAssigneeDetailsViewController alloc] init];
            creditorRightAssigneeDetailsView.signId = _signId;
            [self.navigationController pushViewController:creditorRightAssigneeDetailsView animated:YES];
        }
            break;
            
        case 1:
        {
            
            AssigneeLoanStandardDetailsViewController *assigneeLoanStandardDetailsView = [[AssigneeLoanStandardDetailsViewController alloc] init];
            assigneeLoanStandardDetailsView.signId = _signId;
            [self.navigationController pushViewController:assigneeLoanStandardDetailsView animated:YES];
            
            
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
        
        [parameters setObject:@"54" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:_signId forKey:@"signId"];
        
    
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
        
        if ([[obj objectForKey:@"assigneeWay"] integerValue] == 1) {
            _wayLabel.text = @"定向转让";
        }else {
            _wayLabel.text = @"竞价转让";
        }
        
        _assigneeName.text = [obj objectForKey:@"assigneeName"];
        if ([obj objectForKey:@"successTransferTime"]!= nil && ![[obj objectForKey:@"successTransferTime"] isEqual:[NSNull null]]) {
            _timeLabel.text = [[NSString stringWithFormat:@"%@",[obj objectForKey:@"successTransferTime"]] substringWithRange:NSMakeRange(0, 19)];
            NSLog(@"_timeLabel.text -> %@", _timeLabel.text);
        }
        _timeLabel.text = @"";
        
        if (![[obj objectForKey:@"collectCapital"] isEqual:[NSNull null]]) {
            _capitalLabel.text = [NSString stringWithFormat:@"%@  元", [obj objectForKey:@"collectCapital"]];
        }
        if (![[obj objectForKey:@"collectBid"] isEqual:[NSNull null]]) {
            _bidLabel.text = [NSString stringWithFormat:@"%@  元", [obj objectForKey:@"collectBid"]];
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
