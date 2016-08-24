//
//  WaitConfirmedViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14/10/30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(转让债权管理) -> 待确认

#import "WaitConfirmedViewController.h"
#import "ColorTools.h"
#import "CreditorRightTransferDetailsViewController.h"
#import "TransferloanStandardDetailsViewController.h"

@interface WaitConfirmedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSArray *dataArr;
    
}

@end

@implementation WaitConfirmedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
    dataArr = @[@"债权转让详情",@"转让的借款标详情"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    UIImageView *AuditImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5-50, 85, 100, 100)];
    AuditImg.image = [UIImage imageNamed:@"finance_audit"];
    [self.view addSubview:AuditImg];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 185, self.view.frame.size.width, 30);
    titleLabel.text = @"此债权正在确认中,请耐心等候。";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.view addSubview:titleLabel];
    
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

@end
