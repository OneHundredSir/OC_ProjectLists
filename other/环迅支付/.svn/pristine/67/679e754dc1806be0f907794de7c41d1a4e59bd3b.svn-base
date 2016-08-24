//
//  MailViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心---》信箱
#import "MailViewController.h"

#import "ColorTools.h"

#import "SystemMessageViewController.h"
#import "InBoxViewController.h"
#import "OutBoxViewController.h"
#import "WriteMailViewController.h"
#import "BorrowimgQuestionsViewController.h"
#import "TabViewController.h"

@interface MailViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *titileArr;
    NSArray  *imgNameArr;
    SystemMessageViewController *systemMessageView;
    InBoxViewController *inBoxView;
    OutBoxViewController *outBoxView;
    WriteMailViewController *writeMailView;
    BorrowimgQuestionsViewController *bQuestion;

}

@property (nonatomic,strong) UITableView *TableView;
@end


@implementation MailViewController

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
    titileArr = [NSMutableArray arrayWithObjects:@"系统消息", @"收件箱",@"发件箱",@"借款提问",nil];
    imgNameArr = @[@"system_img",@"in_box_img",@"out_box_img",@"question_img"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    //列表视图
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];

    //子视图初始化
    systemMessageView = [[SystemMessageViewController alloc] init];
    inBoxView = [[InBoxViewController alloc] init];
    outBoxView = [[OutBoxViewController alloc] init];
    writeMailView = [[WriteMailViewController alloc] init];
    bQuestion = [[BorrowimgQuestionsViewController alloc] init];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"站内信";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条返回按钮
    UIBarButtonItem *writemailItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"investment_calculator_normal"] style:UIBarButtonItemStyleDone target:self action:@selector(writemailClick)];
    writemailItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:writemailItem];
    
}

#pragma mark - 表视图协议代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return titileArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 5.0f;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50.0f;


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellId];
        
    }
    cell.imageView.image = [UIImage imageNamed:[imgNameArr objectAtIndex:indexPath.section]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titileArr objectAtIndex:indexPath.section];
  
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:systemMessageView animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:inBoxView animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:outBoxView animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:bQuestion animated:YES];
            break;
    }
}

#pragma mark - 写信触发方法
- (void)writemailClick
{
  
    [self.navigationController pushViewController:writeMailView animated:YES];

}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
//   [self dismissViewControllerAnimated:YES completion:^(){}];
//    TabViewController *tabViewController = [[TabViewController alloc] init];
    TabViewController *tabViewController = [TabViewController shareTableView];
     [self.frostedViewController presentMenuViewController];
    self.frostedViewController.contentViewController = tabViewController;
    
}
@end
