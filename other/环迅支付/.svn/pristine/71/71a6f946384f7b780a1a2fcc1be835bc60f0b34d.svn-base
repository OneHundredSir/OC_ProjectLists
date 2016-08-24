//
//  ReviewIntegralDetailViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-7.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//审核科目积分明细

#import "ReviewIntegralDetailViewController.h"
#import "ColorTools.h"
#import "UIFolderTableView.h"
#import "ReviewIntegralDetailCell.h"

#import "ReviewIntegralDetail.h"

@interface ReviewIntegralDetailViewController ()<UIFolderTableViewDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSInteger _currePage;
    NSMutableArray *_dataArrays;
}


@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic,strong) UIFolderTableView *tableView;

@end

@implementation ReviewIntegralDetailViewController

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
    _dataArrays = [[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    _tableView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"审核科目积分明细";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];

}

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _dataArrays.count;
    
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
    return 70.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.section];
    ReviewIntegralDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[ReviewIntegralDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ReviewIntegralDetail *bean = _dataArrays[indexPath.section];
    cell.depictLabel.text = [NSString stringWithFormat:@"%@",bean.descriptionStr];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@（编号:%@）", bean.name, bean.no];
 
    switch (bean.type) {
        case 1:
            cell.imgLabel.text = @"图片";
            break;
        case 2:
            cell.imgLabel.text = @"文本";
            break;
        case 3:
            cell.imgLabel.text = @"视频";
            break;
        case 4:
            cell.imgLabel.text = @"音频";
            break;
        case 5:
            cell.imgLabel.text = @"表格";
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self moreBtnClick:indexPath];
}

#pragma 更多按钮触发方法
- (void)moreBtnClick:(NSIndexPath *)indexPath
{
    ReviewIntegralDetail *bean = _dataArrays[indexPath.section];
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    dropView.backgroundColor = [UIColor whiteColor];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, dropView.frame.size.width, 20)];
    
    moneyLabel.text = [NSString stringWithFormat:@"有效期: %ld 个月", (long)bean.period];
    moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    moneyLabel.textColor = [UIColor darkGrayColor];
    [dropView addSubview:moneyLabel];
    
    UILabel *moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, dropView.frame.size.width, 20)];
    moneyLabel2.text = [NSString stringWithFormat:@"审核周期: %ld 天", (long)bean.auditCycle];
    moneyLabel2.font = [UIFont boldSystemFontOfSize:13.0f];
    moneyLabel2.textColor = [UIColor darkGrayColor];
    [dropView addSubview:moneyLabel2];
    
    UILabel *moneyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, dropView.frame.size.width, 20)];
    moneyLabel3.text =  [NSString stringWithFormat:@"信用积分: %ld 分", (long)bean.creditScore];
    moneyLabel3.font = [UIFont boldSystemFontOfSize:13.0f];
    moneyLabel3.textColor = [UIColor darkGrayColor];
    [dropView addSubview:moneyLabel3];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, dropView.frame.size.width, 20)];
    stateLabel.text = [NSString stringWithFormat:@"审核费用: %ld 元", (long)bean.auditFee];
    stateLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    stateLabel.textColor = [UIColor darkGrayColor];
    [dropView addSubview:stateLabel];
    

    UILabel *wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, dropView.frame.size.width-20, 20)];
    wayLabel.text = [NSString stringWithFormat:@"信用额度: %ld 元",(long)bean.creditLimit];
    wayLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    wayLabel.textColor = [UIColor darkGrayColor];
    [dropView addSubview:wayLabel];
    
    
    _tableView.scrollEnabled = NO;
    [_tableView openFolderAtIndexPath:indexPath WithContentView:dropView
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                     //[self CloseAndOpenACtion:indexPath];
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                    //[self CloseAndOpenACtion:indexPath];
                                    //[cell changeArrowWithUp:NO];
                                }
                           completionBlock:^{
                               // completed actions
                               _tableView.scrollEnabled = YES;
                           }];
    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    if([_returnType isEqualToString:@"积分规则"]){
        [self.navigationController popViewControllerAnimated:YES];
    
    }else
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _currePage =1;
    [self requestData];
}

- (void)footerRereshing
{
    _currePage++;
   [self requestData];
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"142" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_currePage] forKey:@"currPage"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self hiddenRefreshView];
    });
    
    
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
        if (_currePage == 1) {
                [_dataArrays removeAllObjects];// 清空全部数据
        }
 
        NSInteger creditLimitNum = [[dics objectForKey:@"creditLimit"] integerValue];
        
        NSArray *dataArr = [[dics objectForKey:@"list"] objectForKey:@"page"];
        
        for (NSDictionary *item in dataArr) {
            
            ReviewIntegralDetail *bean = [[ReviewIntegralDetail alloc] init];
            
            bean.name = [item objectForKey:@"name"] ; //
            bean.no= [item objectForKey:@"id"] ; //
            bean.type= [[item objectForKey:@"type"] intValue]; //
            bean.creditScore = [[item objectForKey:@"credit_score"] intValue]; //
            bean.auditCycle = [[item objectForKey:@"audit_cycle"] intValue]; //
            bean.auditFee = [[item objectForKey:@"auditFee"] intValue]; //
            bean.period = [[item objectForKey:@"period"] intValue]; //
            bean.creditLimit = creditLimitNum * [[item objectForKey:@"credit_score"] intValue]; //
            bean.descriptionStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"description"]];
            
            [_dataArrays addObject:bean];
        }
        
//        [_tableView reloadData];
    
    } else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
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
