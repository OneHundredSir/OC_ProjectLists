//
//  BorrowingDetailsViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BorrowingDetailsViewController.h"
#import "LDProgressView.h"
#import "ColorTools.h"
#import "BorrowDetailsCell.h"
NSString *headertitles;
@interface BorrowingDetailsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    NSArray *titleArr;
    NSArray *tableArr;

}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIScrollView *ScrollView;
@property (nonatomic,strong)LDProgressView *progressView;
@end

@implementation BorrowingDetailsViewController

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
    titleArr = @[@"借款金额:",@"年利率:",@"还款方式:",@"合作机构:",@"借款期限:",@"还款日期:"];
    tableArr = @[@"详情描述",@"必要材料审核科目",@"CBO风控体系审核",@"历史记录",@"投标奖励",@"投标记录",@"向借款人提问"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //滚动视图
    _ScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1000)];
    _ScrollView.userInteractionEnabled = YES;
    _ScrollView.scrollEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator =NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.delegate = self;
    _ScrollView.backgroundColor = [UIColor whiteColor];
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
    [self.view addSubview:_ScrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 220, 35)];
    titleLabel.text = @"广告商长期流动资金借款1期";
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_ScrollView addSubview:titleLabel];
    
    UILabel *idtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 80, 30)];
    idtextLabel.text = @"编号:";
    idtextLabel.font = [UIFont systemFontOfSize:13.0f];
    idtextLabel.textAlignment = NSTextAlignmentLeft;
    [_ScrollView addSubview:idtextLabel];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 100, 30)];
    idLabel.text = @"20140223";
    idLabel.textColor = [UIColor redColor];
    idLabel.font = [UIFont systemFontOfSize:13.0f];
    idLabel.textAlignment = NSTextAlignmentLeft;
    [_ScrollView addSubview:idLabel];
    
    //边框
    UIButton *signBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn1.frame = CGRectMake(20, 40, 50, 30);
    signBtn1.backgroundColor = [UIColor whiteColor];
    [signBtn1.layer setMasksToBounds:YES];
    [signBtn1.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [signBtn1.layer setBorderWidth:1.5];   //边框宽度
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 0.3, 0.5, 0.8, 1 });
    [signBtn1.layer setBorderColor:colorref1];//边框颜色
    [_ScrollView addSubview:signBtn1];
    
    
    UILabel *borrowstateLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, 40, 30)];
    borrowstateLabel.text = @"借款中";
    borrowstateLabel.textColor = [UIColor orangeColor];
    borrowstateLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [_ScrollView insertSubview:borrowstateLabel aboveSubview:signBtn1];
    
    
    
    
    //边框
    UIButton *signBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn2.frame = CGRectMake(85, 45, 90, 25);
    signBtn2.backgroundColor = [UIColor whiteColor];
    [signBtn2.layer setMasksToBounds:YES];
    [signBtn2.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [signBtn2.layer setBorderWidth:1.5];   //边框宽度
    CGColorSpaceRef colorSpace2 = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref2 = CGColorCreate(colorSpace2,(CGFloat[]){ 0.3, 0.5, 0.8, 1 });
    [signBtn2.layer setBorderColor:colorref2];//边框颜色
    [_ScrollView addSubview:signBtn2];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(88, 48, 20, 20)];
    imgView.image = [UIImage imageNamed:@"tab_home"];
    [_ScrollView insertSubview:imgView aboveSubview:signBtn2];
    
    
    
    
    UILabel *usageLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 45, 55, 25)];
    usageLabel.text = @"消费周转";
    usageLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [_ScrollView insertSubview:usageLabel aboveSubview:signBtn2];
    
    
    UIImageView *integrityImg = [[UIImageView alloc] initWithFrame:CGRectMake(180, 40, 30, 30)];
    integrityImg.image = [UIImage imageNamed:@"loan_type1"];
    integrityImg.backgroundColor = [UIColor clearColor];
    [_ScrollView addSubview:integrityImg];
    
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(220, 40, 30, 30);
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"menu_collection_00"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_ScrollView addSubview:collectBtn];
    
    _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(15, 80, 280, 10)];
    _progressView.color = [UIColor orangeColor];
    _progressView.flat = @YES;// 是否扁平化
    _progressView.borderRadius = @0;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.animate = @NO;
    _progressView.progressInset = @0;//内边的边距
    _progressView.showBackground = @YES;
    _progressView.outerStrokeWidth = @0;
    _progressView.showText = @YES;
    _progressView.showStroke = @NO;
    _progressView.progress = 0.5;
    _progressView.background = [UIColor lightGrayColor];
    [_ScrollView addSubview:_progressView];
    
    for (int i = 0; i<[titleArr count]; i++){
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = [titleArr objectAtIndex:i];
        textLabel.font = [UIFont systemFontOfSize:12.0f];
        textLabel.textAlignment = NSTextAlignmentRight;
        if (i==4||i==5) {
            
            textLabel.frame = CGRectMake(155, 100+25*(i-3), 60, 20);
            
        }
        else
            textLabel.frame = CGRectMake(10, 100+25*i, 60, 20);
        [_ScrollView addSubview:textLabel];
        
    }
    
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 100, 20)];
    moneyLabel.text = @"$500,000.00";
    moneyLabel.textColor = [UIColor redColor];
    moneyLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:moneyLabel];
    
    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 125, 100, 20)];
    rateLabel.text = @"12.2%";
    rateLabel.textColor = [UIColor redColor];
    rateLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:rateLabel];
    
    UILabel *wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 150, 100, 20)];
    wayLabel.text = @"等额本息";
    wayLabel.textColor = [UIColor redColor];
    wayLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:wayLabel];
    
    UILabel *organizationLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 175, 100, 20)];
    organizationLabel.text = @"天一投资";
    organizationLabel.textColor = [UIColor redColor];
    organizationLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:organizationLabel];
    
    UILabel *deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 125, 100, 20)];
    deadlineLabel.text = @"一个月";
    deadlineLabel.textColor = [UIColor redColor];
    deadlineLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:deadlineLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 150, 100, 20)];
    dateLabel.text = @"2015年12月3日";
    dateLabel.textColor = [UIColor redColor];
    dateLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:dateLabel];
    
    //边框
    UIButton *signBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn3.frame = CGRectMake(20, 210, 280, 30);
    signBtn3.backgroundColor = [UIColor whiteColor];
    [signBtn3.layer setMasksToBounds:YES];
    [signBtn3.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [signBtn3.layer setBorderWidth:1.5];   //边框宽度
    CGColorSpaceRef colorSpace3 = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref3 = CGColorCreate(colorSpace3,(CGFloat[]){ 1, 0.5, 0.6, 1 });
    [signBtn3.layer setBorderColor:colorref3];//边框颜色
    [_ScrollView addSubview:signBtn3];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 210, 30, 30)];
    imgView2.image = [UIImage imageNamed:@"creditor_transfer_alarm"];
     imgView2.contentMode = UIViewContentModeScaleToFill;
    [_ScrollView insertSubview:imgView2 aboveSubview:signBtn3];
    
    UILabel *dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 210, 190, 30)];
    dateLabel2.text = @"12天23小时34分54秒";
    dateLabel2.textColor = [UIColor orangeColor];
    dateLabel2.font = [UIFont systemFontOfSize:14.0f];
    [_ScrollView addSubview:dateLabel2];
    
    
    
    //列表初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 260, self.view.frame.size.width, 640) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_ScrollView addSubview:_tableView];
    
    
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款详情";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar setBarTintColor:SETCOLOR(255, 167, 0, 1.0)];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条分享按钮
    UIBarButtonItem *ShareItem=[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(ShareClick)];
    ShareItem.tintColor = [UIColor blackColor];
    [self.navigationItem setRightBarButtonItem:ShareItem];
    
    
    
}

#pragma mark UItableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [tableArr count]+1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 10.0f;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.0f;
    }
   else
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 10.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        
        static  NSString *cellID = @"cellid";
        BorrowDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[BorrowDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.HeadimgView.image = [UIImage imageNamed:@"loan_type1"];
        cell.NameLabel.text = @"张三李四";
        cell.BorrowLabel.text = [NSString stringWithFormat:@"%d次成功，%d次流标",3,2];
        cell.repaymentLabel.text = [NSString stringWithFormat:@"%d次正常，%d次逾期已还",45,2];
        cell.MemberimgView.image = [UIImage imageNamed:@"loan_type1"];
        cell.CreditView.image = [UIImage imageNamed:@"menu_collection_00"];
        [cell.attentionBtn addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.CalculateBtn setImage:[UIImage imageNamed:@"menu_calculator"] forState:UIControlStateNormal];
        [cell.CalculateBtn addTarget:self action:@selector(CalculateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.ReportBtn setImage:[UIImage imageNamed:@"menu_information"] forState:UIControlStateNormal];
        [cell.ReportBtn addTarget:self action:@selector(ReportBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.MailBtn setImage:[UIImage imageNamed:@"menu_collection_02"] forState:UIControlStateNormal];
        [cell.MailBtn addTarget:self action:@selector(MailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;

        
    }
    else{
        
        
        NSString *cellID2 = @"cellid2";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        cell.textLabel.text = [tableArr objectAtIndex:indexPath.section-1];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }
    

}

#pragma mark 关注按钮
- (void)attentionBtnClick
{
    
    
    NSLog(@"关注按钮");
    
    
}


#pragma mark 信件按钮
- (void)MailBtnClick
{
    
    
    NSLog(@"信件按钮");
    
    
}

#pragma mark 举报按钮
- (void)ReportBtnClick
{
    
    
    NSLog(@"举报按钮");
    
    
}



#pragma mark 计算器按钮
- (void)CalculateBtnClick
{
    
    
    NSLog(@"计算器按钮");
    
    
}
#pragma mark 收藏按钮
- (void)collectBtnClick
{


     NSLog(@"收藏按钮");


}
#pragma  分享按钮
- (void)ShareClick
{
     NSLog(@"分享按钮");

    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // NSLog(@"返回按钮");
    [self.navigationController popViewControllerAnimated:NO];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
