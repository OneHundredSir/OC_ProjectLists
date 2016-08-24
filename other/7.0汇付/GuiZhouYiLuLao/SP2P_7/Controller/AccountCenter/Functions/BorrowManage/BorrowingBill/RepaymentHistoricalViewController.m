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
{

}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
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
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
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
    static NSString *cellid = @"cellid";
    // 防止UI修改
    HistoryRepaymentTableViewCell *cell = [[HistoryRepaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    HistoryRepayment *bean = _historyArrays[indexPath.section];
    
    //cell.titleLabel.text = bean.title;
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@（第%ld期）", bean.title ,(long)bean.period];
    if(bean.overdueMark == Overdue_None){
        // 未逾期
        cell.overdueView.image = [UIImage imageNamed:@""];
        cell.overdueView.frame = CGRectMake(CGRectGetMinX(cell.titleLabel.frame), 30, 0, 0);
        cell.repayView.frame = CGRectMake(CGRectGetMinX(cell.titleLabel.frame) + 4, 30, 30, 20);
    }else {
        // 逾期
        cell.overdueView.frame = CGRectMake(CGRectGetMinX(cell.titleLabel.frame), 30, 20, 20);
        cell.overdueView.image = [UIImage imageNamed:@"state_exceed"];
        cell.repayView.frame = CGRectMake(CGRectGetMaxX(cell.overdueView.frame) + 4, 30, 30, 20);
    }
    
    cell.moneyLabel.frame = CGRectMake(CGRectGetMaxX(cell.repayView.frame)+12, 30, 100, 20);
    
    switch (bean.status) {
        case Repayment_None1:
            // 未还款
            cell.repayView.image = [UIImage imageNamed:@"state_did_not"];
            break;
        case Repayment_None2:
            // 未还款
            cell.repayView.image = [UIImage imageNamed:@"state_did_not"];
            break;
        default:
            // 已还款
            cell.repayView.image = [UIImage imageNamed:@"state_has_been"];
            break;
    }
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",bean.currentPayAmount];
    cell.timeLabel.text = bean.repaymentTime;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

@end
