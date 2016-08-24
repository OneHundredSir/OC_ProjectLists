//
//  BorrowListViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户管理 -> 我的收藏 -> 我收藏的借款

#import "BorrowListViewController.h"
#import "ColorTools.h"
#import "Investment.h"
#import "InvestmentTableViewCell.h"
#import "BorrowingDetailsViewController.h"
#import "InterestcalculatorViewController.h"

@interface BorrowListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *_dataArrays;
   
}
@property (strong, nonatomic)  UITableView *tableView;

@end

@implementation BorrowListViewController

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
    
    [self readData];
    
}


- (void)readData
{
    _dataArrays =[[NSMutableArray alloc] init];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"investment_list" withExtension:@"plist"];
    NSArray *collections = [NSArray arrayWithContentsOfURL:url];
    for (NSDictionary *item in collections) {
        Investment *bean = [[Investment alloc] init];
        bean.title = [item objectForKey:@"title"];
        bean.imgurl = [item objectForKey:@"imgurl"];
        bean.levelStr = [item objectForKey:@"level"];
        bean.progress = [[item objectForKey:@"progress"] floatValue];
        bean.amount = [[item objectForKey:@"amount"] floatValue];
        bean.rate = [[item objectForKey:@"rate"] floatValue];
        bean.time = [item objectForKey:@"time"] ;
        [_dataArrays addObject:bean];
    }
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
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"我收藏的借款";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return _dataArrays.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    InvestmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[InvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    [cell fillCellWithObject:object];
    [cell.calculatorView addTarget:self action:@selector(repaymentcalculatorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.5f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//返回时取消选中状态
    
    Investment *object = [_dataArrays objectAtIndex:indexPath.section];
    
    BorrowingDetailsViewController *BorrowingDetailsView= [[BorrowingDetailsViewController alloc] init];
    BorrowingDetailsView.titleString = object.title;
    BorrowingDetailsView.progressnum = (object.progress)*0.01;
//    BorrowingDetailsView.amount = object.amount;
    BorrowingDetailsView.rate = object.rate;
    BorrowingDetailsView.timeString = object.time;
    BorrowingDetailsView.HidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:BorrowingDetailsView animated:YES];
    
    
}

#pragma mark -
#pragma mark 计算器按钮
- (void)repaymentcalculatorBtnClick
{
    
    InterestcalculatorViewController *interestcalculatorView = [[InterestcalculatorViewController alloc] init];
    interestcalculatorView.HidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:interestcalculatorView animated:YES];
    
    
}





#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:NO];
    
}


@end
