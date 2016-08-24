//
//  MoreHelpSecondViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-14.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreHelpSecondViewController.h"
#import "MoreHelpDetailViewController.h"

#import "ColorTools.h"


@interface MoreHelpSecondViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate>
{
    NSMutableArray *_titleArrays;
    NSMutableArray *_idArrays;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic, strong) UITableView *helpTableView;

@end

@implementation MoreHelpSecondViewController

/**
 初始化数据
 */
- (void)initWithName:(NSString *)name ColumnId:(NSString *)ColumnId
{
    self.title = name;
    DLOG(@"columnId -> %@", ColumnId);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"75" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@", ColumnId] forKey:@"id"];
    
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
    
}

/**
 初始化数据
 */
- (void)initView
{
    [self initBar];
    
    [self initContent];
}

/**
 * 初始化导航条
 */
- (void)initBar
{
    self.title = @"帮助中心";
    //[self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:19.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)initContent
{
    _helpTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _helpTableView.delegate = self;
    _helpTableView.dataSource = self;
    
    // [_helpTableView setBackgroundColor:KblackgroundColor];
    
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
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    cell.textLabel.text = _titleArrays[indexPath.section];
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:@"tab_transfer"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *nameStr = _titleArrays[indexPath.section];
    NSString *idStr = _idArrays[indexPath.section];
    
    DLOG(@"idStr - %@", idStr);
    
    MoreHelpDetailViewController *helpDetail = [[MoreHelpDetailViewController alloc] init];
    [helpDetail initWithName:nameStr ColumnId:idStr];
    [self.navigationController pushViewController:helpDetail animated:YES];
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
        
        _titleArrays = [[NSMutableArray alloc] init];
        _idArrays = [[NSMutableArray alloc] init];
        
        NSArray *collections = [obj objectForKey:@"list"];
        for (NSDictionary *item in collections) {
            
            DLOG(@"返回成功  title -> %@",[item objectForKey:@"title"]);
            DLOG(@"返回成功  id -> %@",[item objectForKey:@"id"]);
            [_titleArrays addObject:[item objectForKey:@"title"]];
            [_idArrays addObject:[item objectForKey:@"id"]];
        }
        
        [_helpTableView reloadData];
        
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
