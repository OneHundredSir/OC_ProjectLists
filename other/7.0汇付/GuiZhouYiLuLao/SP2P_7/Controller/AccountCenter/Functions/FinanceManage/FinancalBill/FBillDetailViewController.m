//
//  FBillDetailViewController.m
//  SP2P_7
//
//  Created by kiu on 14-10-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心--》理财子账户————》账单详情

#import "FBillDetailViewController.h"
#import "CurrentFBillDetailsViewController.h"
#import "BorrowingFBillDetailViewController.h"
#import "RepaymentHistoricalFBViewController.h"

@interface FBillDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSArray *tableArr;
    
    NSString *_billId;
}

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, strong) UILabel *billIdLabel;  // 账单编号
@property (nonatomic, strong) UILabel *billdateLabel;  // 借款账单生成日期
@property (nonatomic, strong) UILabel *nameLabel;  // 帐户名
@property (nonatomic, strong) UILabel *infoLabel;  // 提示内容
@property (nonatomic, strong) UILabel *hotLine;  // 客服专线
@property (nonatomic, strong) UILabel *webLabel;  // 域名
@property (nonatomic, strong) UILabel *introductionLabel;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation FBillDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self requestData];
}
/**
 * 初始化数据
 */
- (void)initData
{
    
    tableArr = @[@"本期理财账单明细",@"借款标详细情况",@"历史收款记录"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = KblackgroundColor;
//    _scrollView.scrollEnabled = NO;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 510);
    [self.view addSubview:_scrollView];
    
    
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    backView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView1];
    
    
    _billTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 35)];
    _billTitleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _billTitleLabel.textAlignment = NSTextAlignmentCenter;
    _billTitleLabel.text = @"";
    [_scrollView addSubview:_billTitleLabel];
    
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(0,51, self.view.frame.size.width, 80)];
    backView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView2];
    
    _NameStr = [[NSString alloc] init];
    _NameStr = @"";
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, self.view.frame.size.width, 30)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _nameLabel.text = [NSString stringWithFormat:@"尊敬的%@用户，您好!",_NameStr];
    [_scrollView addSubview:_nameLabel];
    
    _introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, self.view.frame.size.width-20, 60)];
    _introductionLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _introductionLabel.textColor = [UIColor grayColor];
    _introductionLabel.text = @"";
    _introductionLabel.numberOfLines = 0;
    _introductionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_scrollView addSubview:_introductionLabel];
    
    
    UIView *backView3 = [[UIView alloc] initWithFrame:CGRectMake(0,132, self.view.frame.size.width, 140)];
    backView3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView3];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 134, 90, 30)];
    promptLabel.text = @"重要提示:";
    promptLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_scrollView addSubview:promptLabel];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, self.view.frame.size.width-20, 60)];
    _infoLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _infoLabel.textColor = [UIColor grayColor];
    _infoLabel.text = @"     尊敬的客户,为确保您还款准确,请您仔细阅读下面需还款明细栏目中各账户本期应还款金额及本期最低还款额等信息";
    _infoLabel.numberOfLines = 0;
    _infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_scrollView addSubview:_infoLabel];
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 400)  style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.scrollEnabled = NO;
    [_listView setBackgroundColor:KblackgroundColor];
    [_scrollView addSubview:_listView];
    
    
    _billIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, self.view.frame.size.width, 30)];
    _billIdLabel.text = @"账单编号:";
    _billIdLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _billIdLabel.textColor = [UIColor grayColor];
    [_listView addSubview:_billIdLabel];
    
    _billdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, self.view.frame.size.width, 30)];
    _billdateLabel.text = @"理财账单生成日期:";
    _billdateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _billdateLabel.textColor = [UIColor grayColor];
    [_listView addSubview:_billdateLabel];
    
    _webLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, self.view.frame.size.width, 30)];
    _webLabel.text = @"";
    _webLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _webLabel.textColor = [UIColor grayColor];
    [_listView addSubview:_webLabel];
    
    
    _hotLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width, 30)];
    _hotLine.text = @"";
    _hotLine.font = [UIFont boldSystemFontOfSize:12.0f];
    _hotLine.textColor = [UIColor grayColor];
    [_listView addSubview:_hotLine];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"账单详情";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}


#pragma mark UItableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [tableArr count];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 3.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 35.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 3.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID2 = @"cellid1";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
    }
    cell.textLabel.text = [tableArr objectAtIndex:indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DLOG(@"_billId -> %@", _billId);
    
    if (_billId == nil ) {
        
        [SVProgressHUD showErrorWithStatus:@"系统异常，给您带来的不便敬请谅解"];
        
    }else {
        switch (indexPath.section) {
            case 0:
            {
                CurrentFBillDetailsViewController *currentFinancialBillDetailsView = [[CurrentFBillDetailsViewController alloc] init];
                currentFinancialBillDetailsView.userId = AppDelegateInstance.userInfo.userId;
                currentFinancialBillDetailsView.billId = _billId;
                
                [self.navigationController pushViewController:currentFinancialBillDetailsView animated:YES];
                
            }
                break;
                
            case 1:
            {
                BorrowingFBillDetailViewController *borrowingdetailsView = [[BorrowingFBillDetailViewController alloc] init];
                borrowingdetailsView.kId = AppDelegateInstance.userInfo.userId;
                borrowingdetailsView.billId = _billId;
                
                [self.navigationController pushViewController:borrowingdetailsView animated:YES];
                
            }
                break;
            case 2:
            {
                RepaymentHistoricalFBViewController *repaymentHistoricalView = [[RepaymentHistoricalFBViewController alloc] init];
                repaymentHistoricalView.billId = _billId;
                [self.navigationController pushViewController:repaymentHistoricalView animated:YES];
            }
                
                break;
        }
    }
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"36" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
        [parameters setObject:_sign forKey:@"billId"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        _billTitleLabel.text = [obj objectForKey:@"billTitle"];
        _nameLabel.text = [NSString stringWithFormat:@"尊敬的 %@ 用户，您好!",[obj objectForKey:@"userName"]]; // 用户名
        _billdateLabel.text = [NSString stringWithFormat:@"理财账单生成日期：%@", [obj objectForKey:@"billDate"]]; // 账单生成日期
        _hotLine.text =[NSString stringWithFormat:@"客服专线:%@", [obj objectForKey:@"hotline"]];  // 客服专线
        
        _introductionLabel.text =[NSString stringWithFormat:@"     感谢您使用%@理财服务,我平台客服专线:%@ 竭诚为您服务", [obj objectForKey:@"platformName"], [obj objectForKey:@"hotline"]];
        _billIdLabel.text = [NSString stringWithFormat:@"账单编号:%@", [obj objectForKey:@"billNo"]]; // 账单编号
        _webLabel.text = [obj objectForKey:@"platformName"];
        
        _billId = [obj objectForKey:@"billId"];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];

}

// 无可用的网络
-(void) networkError
{
   [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


@end
