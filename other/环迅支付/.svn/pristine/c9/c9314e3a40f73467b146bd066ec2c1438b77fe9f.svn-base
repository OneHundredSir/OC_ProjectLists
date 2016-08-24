//
//  CalculatorViewController.m
//  SP2P_7
//
//  Created by Kiu on 14-6-12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
// 
//  财富工具箱

#import "CalculatorViewController.h"

#import "BarButtonItem.h"
#import "ColorTools.h"

#import "NetvaluecalculatorViewController.h"
#import "InterestcalculatorViewController.h"
#import "CreditcalViewController.h"
#import "RepaymentViewController.h"

@interface CalculatorViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *titleArr;
}

@property (nonatomic,strong) UITableView *TableView;

@end

@implementation CalculatorViewController

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
    titleArr = [NSMutableArray arrayWithObjects:@"信用计算器", @"还款计算器",@"净值计算器",@"利率计算器",nil];
    
}

/**
 初始化数据
 */
- (void)initView
{
    self.title = NSLocalizedString(@"财富工具箱", nil);
    [self initNavigationBar];
    
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}

- (void)initNavigationBar
{
    [self.navigationController.navigationBar setBarTintColor:KColor];
    
    BarButtonItem *leftButton = [BarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_back"] selectedImage:[UIImage imageNamed:@"nav_back"] target:self action:@selector(leftClick)];
    [self.navigationItem setLeftBarButtonItem:leftButton];// 左边导航按钮
    
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
}

#pragma mark - UITableView协议代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
            break;
        case 1:
            cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
            break;
        case 2:
            cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
        case 3:
            cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
            break;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            {
                CreditcalViewController *creditVC = [[CreditcalViewController alloc] init];
                [self.navigationController pushViewController:creditVC animated:YES];
            }
            break;
        case 1:
            {
                RepaymentViewController *repaymentVC = [[RepaymentViewController alloc] init];
                [self.navigationController pushViewController:repaymentVC animated:YES];
            }
            break;
        case 2:
            {
                NetvaluecalculatorViewController *NetvalueVC = [[NetvaluecalculatorViewController alloc] init];
                [self.navigationController pushViewController:NetvalueVC animated:YES];
            }
            break;
        case 3:
            {
                InterestcalculatorViewController *interestVC = [[InterestcalculatorViewController alloc] init];
                interestVC.status = 0;
                [self.navigationController pushViewController:interestVC animated:YES];
            }
            break;
    }
}
#pragma  返回键触发方法
- (void)leftClick
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

@end
