//
//  CreditScoreRuleViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//信用积分规则

#import "CreditScoreRuleViewController.h"
#import "ColorTools.h"

#import "CreditScoreRuleCell.h"
#import "ReviewIntegralDetailViewController.h"

#import "CreditScoreRule.h"

@interface CreditScoreRuleViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    CreditScoreRule *_bean;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CreditScoreRuleViewController

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
    _bean = [[CreditScoreRule alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [_tableView headerBeginRefreshing];

}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"信用积分规则";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 6;

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
    return 75.0f;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    CreditScoreRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[CreditScoreRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.section == 0) {
        UIButton *applysubjectsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        applysubjectsBtn.frame = CGRectMake(170,45, 180, 20);
        [applysubjectsBtn setTitle:@"查看积分明细" forState:UIControlStateNormal];
        applysubjectsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        applysubjectsBtn.titleLabel.textAlignment= NSTextAlignmentLeft;
        [applysubjectsBtn addTarget:self action:@selector(applysubjectsBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:applysubjectsBtn];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
        case 0:
            // 审核资料积分
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", @"审核资料积分"];
            cell.ScoreLabel.text = [NSString stringWithFormat:@"审核科目库共有%ld个审核资料科目：", (long)_bean.auditItemCount];
            break;
        case 1:
            // 正常还款积分
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", @"正常还款积分"];
            cell.ScoreLabel.text = [NSString stringWithFormat:@"每正常还款一期账单积：%ld 分", (long)_bean.normalPayPoints];
            break;
        case 2:
            // 成功还款积分
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", @"成功还款积分"];
            cell.ScoreLabel.text = [NSString stringWithFormat:@"每成功满标一个借款标积：%ld 分", (long)_bean.fullBidPoints];;
            break;
        case 3:
            // 成功投标积分
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", @"成功投标积分"];
            cell.ScoreLabel.text = [NSString stringWithFormat:@"每成功投标一次积：%ld 分", (long)_bean.investpoints];
            break;
        case 4:
            // 账单逾期积分
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", @"账单逾期积分"];
            cell.ScoreLabel.text = [NSString stringWithFormat:@"每逾期账单一次扣：%ld 分", (long)_bean.overDuePoints];
            break;
        case 5:
            // 信用额度
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", @"信用额度"];
            cell.ScoreLabel.text = [NSString stringWithFormat:@"信用积分1分可借：%ld 元", (long)_bean.creditLimit];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark 审核科目
- (void)applysubjectsBtnClick
{
    DLOG(@"审核科目积分明细");
    ReviewIntegralDetailViewController *reviewIntegralDetailView = [[ReviewIntegralDetailViewController alloc] init];
    reviewIntegralDetailView.returnType = @"积分规则";
    [self.navigationController pushViewController:reviewIntegralDetailView animated:YES];

}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestData];
}


#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"114" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _bean = [[CreditScoreRule alloc] init];
        _bean.investpoints = [[dics objectForKey:@"investpoints"] intValue];// 投标积分
        _bean.creditLimit = [[dics objectForKey:@"creditLimit"] intValue];// 信用额度
        _bean.normalPayPoints = [[dics objectForKey:@"normalPayPoints"] intValue];// 正常还款积分
        _bean.auditItemCount = [[dics objectForKey:@"auditItemCount"] intValue];// 审核资料科目
        
        _bean.overDuePoints = [[dics objectForKey:@"overDuePoints"] intValue];// 逾期罚款积分
        _bean.fullBidPoints = [[dics objectForKey:@"fullBidPoints"] intValue];// 成功满标积分
        
//        {
//            "fullBidPoints" : 1,
//            "creditLimit" : 200,
//            "overDuePoints" : 1,
//            "investpoints" : 1,
//            "msg" : "查看信用积分规则成功",
//            "normalPayPoints" : 1,
//            "error" : "-1",
//            "auditItemCount" : 11
//        }
        [_tableView reloadData];
 
        
    } else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hiddenRefreshView];
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
    
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


#pragma Hidden View

// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    
    if (!self.tableView.isFooterHidden) {
        [self.tableView footerEndRefreshing];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
