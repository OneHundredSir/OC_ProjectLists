//
//  IntegralDetailViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//积分明细
#import "IntegralDetailViewController.h"
#import "ColorTools.h"

#import "IntegralDetailAuditInformationViewController.h"
#import "NormalIntegralReimbursementDetailViewController.h"
#import "SuccessfulBorrowingIntegralDetailViewController.h"
#import "SuccessfulTenderIntegralSubsidiaryViewController.h"
#import "BillOverdueIntegralDetailViewController.h"
#import "CreditRulesViewController.h"

@interface IntegralDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   NSArray *dataArr;

}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation IntegralDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
     dataArr = @[@"审核资料积分",@"正常还款积分",@"成功借款积分",@"成功投标积分",@"账单逾期积分"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
 
    
    
}



/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"积分明细";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];

    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条返回按钮
    UIBarButtonItem *RightItem=[[UIBarButtonItem alloc] initWithTitle:@"查看规则" style:UIBarButtonItemStyleDone target:self action:@selector(RightItemClick)];
    RightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:RightItem];
}

#pragma mark UItableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [dataArr count];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60.0f;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 3.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
        
    return 2.0f;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
             {
                 IntegralDetailAuditInformationViewController *integralDetailAuditInformationView = [[IntegralDetailAuditInformationViewController alloc] init];
                 
                 [self.navigationController pushViewController:integralDetailAuditInformationView animated:YES];
             }
            break;
        case 1:
             {
                 NormalIntegralReimbursementDetailViewController *normalIntegralReimbursementDetailView = [[NormalIntegralReimbursementDetailViewController alloc] init];
                 
                 [self.navigationController pushViewController:normalIntegralReimbursementDetailView animated:YES];
             }
            break;
        case 2:
             {
                 SuccessfulBorrowingIntegralDetailViewController *successfulBorrowingIntegralDetailView = [[SuccessfulBorrowingIntegralDetailViewController alloc] init];
                 
                 [self.navigationController pushViewController:successfulBorrowingIntegralDetailView animated:YES];
             }
            break;
        case 3:
             {
                 SuccessfulTenderIntegralSubsidiaryViewController *successfulTenderIntegralSubsidiaryView = [[SuccessfulTenderIntegralSubsidiaryViewController alloc] init];
                 
                 [self.navigationController pushViewController:successfulTenderIntegralSubsidiaryView animated:YES];
             }
            break;
        case 4:
              {
                  BillOverdueIntegralDetailViewController *billOverdueIntegralDetailView = [[BillOverdueIntegralDetailViewController alloc] init];
                  
                  [self.navigationController pushViewController:billOverdueIntegralDetailView animated:YES];
              }
            break;
            
            
    }
    
    
    
}



#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma 查看规则
- (void)RightItemClick
{
   
    CreditRulesViewController *CreditRuleView = [[CreditRulesViewController alloc] init];
    [self.navigationController pushViewController:CreditRuleView animated:YES];
    
    
}

@end
