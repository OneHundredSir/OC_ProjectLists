//
//  MembershipDetailsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MembershipDetailsViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>
#import "NewestDynamicViewController.h"
#import "BorrowListViewController.h"
#import "InvestmentListViewController.h"
#import "OtherAttentionUserViewController.h"

@interface MembershipDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titleArr;
    NSArray *dataArr;
 
}
@property (nonatomic,strong) UITableView *ListView;
@end

@implementation MembershipDetailsViewController

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
   
    titleArr = @[@"注册时间:",@"籍贯:",@"居住地:",@"最近登录:",@"个人统计:"];
    dataArr = @[@"最近动态",@"关注用户",@"借款列表",@"投资列表"];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 180)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    headImg.layer.cornerRadius = 30.0f;
    headImg.layer.masksToBounds = YES;
    [headImg sd_setImageWithURL:[NSURL URLWithString:@"http://www.qqpifu.org/wp-content/uploads/2012/05/1636041n6.jpg"]];
    [backView addSubview:headImg];
    
    UIButton *AttentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [AttentionBtn setTitle:@"+加关注" forState:UIControlStateNormal];
    AttentionBtn.frame = CGRectMake(10, 75, 60, 20);
    AttentionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    AttentionBtn.layer.cornerRadius = 3.0f;
    AttentionBtn.layer.masksToBounds = YES;
    AttentionBtn.backgroundColor = GreenColor;
    [AttentionBtn addTarget: self action:@selector(AttentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:AttentionBtn];
    
    
    UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, self.view.frame.size.width, 30)];
    NameLabel.font = [UIFont systemFontOfSize:16.0f];
    NameLabel.textColor = BluewordColor;
    NameLabel.text = @"JESSECA";
    [backView addSubview:NameLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize NameLabelSiZe = [NameLabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
    UIImageView *LevelImg = [[UIImageView alloc] initWithFrame:CGRectMake(NameLabel.frame.origin.x+NameLabelSiZe.width+15, 15,35, 20)];
    [LevelImg setImage:[UIImage imageNamed:@"level_aa"]];
    [backView addSubview:LevelImg];
    
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.frame = CGRectMake(NameLabel.frame.origin.x+NameLabelSiZe.width+60, 10,30, 30);
    [reportBtn setImage:[UIImage imageNamed:@"loan_report"] forState:UIControlStateNormal];
    [reportBtn setImage:[UIImage imageNamed:@"loan_report"] forState:UIControlStateSelected];
    [reportBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:reportBtn];

    
    UIButton *mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mailBtn.frame = CGRectMake(NameLabel.frame.origin.x+NameLabelSiZe.width+100, 10,30, 30);
    [mailBtn setImage:[UIImage imageNamed:@"Loan_mail"] forState:UIControlStateNormal];
    [mailBtn setImage:[UIImage imageNamed:@"Loan_mail"] forState:UIControlStateSelected];
    [mailBtn addTarget:self action:@selector(mailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mailBtn];
    
    for (int i=0; i<[titleArr count]; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45+i*25, 120, 25)];
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [backView addSubview:titleLabel];
    }
    
   
    
    UILabel *logintimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 45, 120, 25)];
    logintimeLabel.textColor = [UIColor lightGrayColor];
    logintimeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    logintimeLabel.text = @"2014-6-6";
    [backView addSubview:logintimeLabel];
    
    UILabel *nativeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, 120, 25)];
    nativeLabel.textColor = [UIColor lightGrayColor];
    nativeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    nativeLabel.text = @"广东 深圳";
    [backView addSubview:nativeLabel];
    
    
    UILabel *abodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 95, 120, 25)];
    abodeLabel.textColor = [UIColor lightGrayColor];
    abodeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    abodeLabel.text = @"深圳宝安";
    [backView addSubview:abodeLabel];
    
    UILabel *latelytimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 120, 200, 25)];
    latelytimeLabel.textColor = [UIColor lightGrayColor];
    latelytimeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    latelytimeLabel.text = @"2014-6-10 15:15:15";
    [backView addSubview:latelytimeLabel];
   
    
    UILabel *statisticsLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 145, 200, 25)];
    statisticsLabel.textColor = [UIColor lightGrayColor];
    statisticsLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    statisticsLabel.text = @"10条借款记录,79条投标记录";
    [backView addSubview:statisticsLabel];
    
    
    _ListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 248, self.view.frame.size.width, 300) style:UITableViewStyleGrouped];
    _ListView.delegate = self;
    _ListView.dataSource = self;
    _ListView.scrollEnabled = NO;
    [self.view addSubview:_ListView];
  
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
    return 45.0f;
    
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
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.section];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            {
                NewestDynamicViewController *NewestDynamicView = [[NewestDynamicViewController alloc] init];
                [self.navigationController pushViewController:NewestDynamicView animated:YES];
            }
             break;
            
        case 1:
        {
            OtherAttentionUserViewController *OtherAttentionUserView = [[OtherAttentionUserViewController alloc] init];
            [self.navigationController pushViewController:OtherAttentionUserView animated:YES];
        }
         break;
            
            
        case 2:
        {
            BorrowListViewController *BorrowListView = [[BorrowListViewController alloc] init];
            [self.navigationController pushViewController:BorrowListView animated:YES];
        }
         break;
            
        case 3:
        {
            InvestmentListViewController * InvestmentListView = [[InvestmentListViewController alloc] init];
            [self.navigationController pushViewController: InvestmentListView animated:YES];
        }
            
            break;
            
    }
    
    

    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"会员详情";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

#pragma 举报按钮触发方法
- (void)reportBtnClick
{
    
    DLOG(@"举报!!!!");
    
}

#pragma 站内信按钮触发方法
- (void)mailBtnClick
{
    
    DLOG(@"站内信!!!!");
    
}



#pragma 加关注按钮触发方法
- (void)AttentionBtnClick
{
    
    DLOG(@"加关注!!!!");
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:NO];
    
}
@end
