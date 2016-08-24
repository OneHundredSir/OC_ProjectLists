//
//  MoreHelpViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-14.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  帮助中心

#import "MoreHelpViewController.h"
#import "MoreHelpSecondViewController.h"

#import "ColorTools.h"

@interface MoreHelpViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate>
{
    NSMutableArray *_titleArrays;
    NSMutableArray *_idArrays;
}

@property (nonatomic, strong) UITableView *helpTableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MoreHelpViewController

// 加载页面之前 加载数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"74" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
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
 初始化数据
 */
- (void)initData
{
//    _titleArrays = @[@"基础知识",@"我要借款",@"我要理财",@"网贷技巧",@"账户资金相关问题"];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContent];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"帮助中心";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:16.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)initContent
{
    _helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -2, self.view.frame.size.width, 280) style:UITableViewStyleGrouped];
    
    _helpTableView.delegate = self;
    _helpTableView.dataSource = self;
    _helpTableView.scrollEnabled = NO;
    
    [_helpTableView setBackgroundColor:KblackgroundColor];
    
    [self.view addSubview:_helpTableView];
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _titleArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    // 设置 cell 右边的箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = _titleArrays[indexPath.section];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG(@"name - %@", _titleArrays[indexPath.section]);
    NSString *nameStr = _titleArrays[indexPath.section];
    NSString *idStr = _idArrays[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MoreHelpSecondViewController *second = [[MoreHelpSecondViewController alloc] init];
    [second initWithName:nameStr ColumnId:idStr];
    [self.navigationController pushViewController:second animated:YES];
}


- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{

}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{

    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        DLOG(@"返回成功  list -> %@",[obj objectForKey:@"list"]);
        _titleArrays = [[NSMutableArray alloc] init];
        _idArrays = [[NSMutableArray alloc] init];
        
        NSArray *collections = [obj objectForKey:@"list"];
        for (NSDictionary *item in collections) {
            
            [_titleArrays addObject:[item objectForKey:@"name"]];
            [_idArrays addObject:[item objectForKey:@"id"]];
        }
        
        DLOG(@"_titleArrays -> %lu", (unsigned long)_titleArrays.count);
        
        [_helpTableView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
       [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

//// 返回失败
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
