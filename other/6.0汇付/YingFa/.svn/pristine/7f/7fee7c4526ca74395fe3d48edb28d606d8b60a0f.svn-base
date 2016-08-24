//
//  MoreViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreViewController.h"

#import "ColorTools.h"
#import "BarButtonItem.h"

#import "TabViewController.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "MoreAboutusViewController.h"
#import "MoreHelpViewController.h"
#import "MoreCustomViewController.h"

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPClientDelegate>
{
    NSArray *_titleArrays;
}

@property (nonatomic , strong)  UITableView *moreTableView;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MoreViewController

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
    _titleArrays = @[@"检查更新",@"关于我们",@"帮助中心",@"客服热线"];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContentView];
}

/**
 * 初始化导航条
*/
- (void)initNavigationBar
{
    self.title = @"更多";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:16.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
    backItem.tag = 1;
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条 右边 设置按钮
    UIBarButtonItem *settingItem=[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
    settingItem.tag = 2;
    settingItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:settingItem];
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"logo"];
    imageView.frame = CGRectMake(self.view.frame.size.width*0.5 - 44, 88, 88, 66);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * .5 - 100, 165, 200, 25)];
    label.text = [NSString stringWithFormat:@"版本号 %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    
    _moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 220) style:UITableViewStyleGrouped];
    _moreTableView.delegate = self;
    _moreTableView.dataSource = self;
    _moreTableView.scrollEnabled = NO;
    
    [_moreTableView setBackgroundColor:KblackgroundColor];
    
    [self.view addSubview:_moreTableView];
}

/**
 * 导航条两侧按钮点击事件
 * 根据Button的tag值区分
 */
- (void)butClick:(UIButton *)but
{
    switch (but.tag) {
        case 1:
            [self dismissViewControllerAnimated:YES completion:^(){}];
            break;
        case 2:
        {
            SettingViewController *setView = [[SettingViewController alloc] init];
            
            [self.navigationController pushViewController:setView animated:YES];
        }
            break;
    }
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
    if (indexPath.section != 0)
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = _titleArrays[indexPath.section];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG(@"name - %@", _titleArrays[indexPath.section]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
            [self upload];
            break;
        case 1:
        {
            MoreAboutusViewController *aboutUs = [[MoreAboutusViewController alloc] init];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        case 2:
        {
            MoreHelpViewController *help = [[MoreHelpViewController alloc] init];
            [self.navigationController pushViewController:help animated:YES];
        }
            break;
        case 3:
        {
            MoreCustomViewController *custom = [[MoreCustomViewController alloc] init];
            [self.navigationController pushViewController:custom animated:YES];
        }
            break;
    }
}

#pragma mark 版本更新
-(void) upload
{
    DLOG(@"版本更新");

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"127" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"2" forKey:@"deviceType"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    [SVProgressHUD load];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"dics -> %@", dics);
        
        
        // 获取服务器版本
        NSString *version = [dics objectForKey:@"version"];
        
        if (codeNum < [[dics objectForKey:@"code"] integerValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"有最新的版本%@，是否前往更新？", version] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
            
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
            
        }
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            DLOG(@"更新中...");
            
            // 正式站点
            NSURL *url = [NSURL URLWithString:@"https://appstore.qiwangyun.com/lab/sp2p/download.html"];
            // 测试站点
//            NSURL *url = [NSURL URLWithString:@"https://appstore.qiwangyun.com/lab/sp2p_test/download.html"];
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    
    
}

@end
