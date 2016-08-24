//
//  AssigneeDebtFailureViewController.m
//  SP2P_7
//
//  Created by kiu on 14/11/6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(受让债权管理) -> 失败

#import "AssigneeDebtFailureViewController.h"
#import "ColorTools.h"
#import "CreditorRightAssigneeDetailsViewController.h"
#import "AssigneeLoanStandardDetailsViewController.h"

@interface AssigneeDebtFailureViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *dataArr;
    
}

@end

@implementation AssigneeDebtFailureViewController

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
    AuditImg.image = [UIImage imageNamed:@"finance_failure"];
    [self.view addSubview:AuditImg];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 190, self.view.frame.size.width, 30);
    titleLabel.text = @"此债权受让时间已过,仍未转让成功,";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines= 0;
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.view addSubview:titleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.frame = CGRectMake(0, 220, self.view.frame.size.width, 30);
    titleLabel1.text = @"因此该债权受让失败。";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.numberOfLines= 0;
    titleLabel1.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.view addSubview:titleLabel1];
    
    
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

@end
