//
//  RepaymentHistoricalViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  历史还款情况
#import "RepaymentHistoricalViewController.h"
#import "ColorTools.h"

#import "HistoryRepaymentTableViewCell.h"

// 还款状态	-1，-2未还款,否则为已还款
#define Repayment_None1 -1
#define Repayment_None2 -2

// overdue	逾期状态	0不是, 其他为逾期
#define Overdue_None 0

@interface RepaymentHistoricalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation RepaymentHistoricalViewController

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
 * 初始化数据
 */
- (void)initData
{}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"历史还款记录";
}


#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_historyArrays count];
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
    return 60.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryRepaymentTableViewCell *cell = [HistoryRepaymentTableViewCell cellWithTableView:tableView];
    HistoryRepayment *bean = _historyArrays[indexPath.section];
    cell.aHistoryRepayment = bean;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

@end
