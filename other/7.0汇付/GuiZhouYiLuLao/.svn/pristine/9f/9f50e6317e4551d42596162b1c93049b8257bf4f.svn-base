//
//  CreditRatingRuleViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//信用等级规则
#import "CreditRatingRuleViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFolderTableView.h"
#import "CreditRatingRuleCell.h"

#import "CreditRatingRule.h"

@interface CreditRatingRuleViewController ()<UIFolderTableViewDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic,strong) UIFolderTableView *tableView;

@end

@implementation CreditRatingRuleViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _tableView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
    [self headerRereshing];

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

#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArrays count];
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
    return 65.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",indexPath.section];
    CreditRatingRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[CreditRatingRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell.RatingImg setContentMode:UIViewContentModeScaleAspectFill];
    
    CreditRatingRule *bean = _dataArrays[indexPath.section];
    
    cell.RatingLabel.text = bean.name;
    [cell.RatingImg  sd_setImageWithURL:[NSURL URLWithString:bean.imageFileName]
                       placeholderImage:[UIImage imageNamed:@"news_image_default"]];
    
    
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
    CreditRatingRule *bean = _dataArrays[indexPath.section];
    
    // NSIndexPath *index1 =  [NSIndexPath indexPathForItem:btn.tag inSection:0];
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
    dropView.backgroundColor = [UIColor whiteColor];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, dropView.frame.size.width, 20)];
    moneyLabel.text = [NSString stringWithFormat:@"最低信用积分: %ld", (long)bean.minCreditScore];
    moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel];
    
    UILabel *moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, dropView.frame.size.width, 20)];
    moneyLabel2.text = [NSString stringWithFormat:@"最低审核科目数量: %ld", (long)bean.minAuditItems];
    moneyLabel2.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel2.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel2];
    
    UILabel *moneyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, dropView.frame.size.width, 20)];

    moneyLabel3.text = [NSString stringWithFormat:@"是否允许逾期扣分: %@", bean.isAllowOverdue];
    
    moneyLabel3.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel3.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel3];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, dropView.frame.size.width, 20)];
    stateLabel.text = [NSString stringWithFormat:@"必审科目: %@", bean.mustItems];
    stateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    stateLabel.textColor = [UIColor grayColor];
    [dropView addSubview:stateLabel];
    
    UILabel *wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, dropView.frame.size.width-20, 40)];
    wayLabel.text =[NSString stringWithFormat:@"信贷建议: %@", bean.suggest];
    wayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    wayLabel.numberOfLines = 0;
    wayLabel.textColor = [UIColor grayColor];
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
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^(){}];
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
//    [_dataArrays removeAllObjects];// 清空全部数据
    
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
    [parameters setObject:@"113" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
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
        
        [_dataArrays removeAllObjects];// 清空全部数据
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        
        for (NSDictionary *item in dataArr) {
 
            CreditRatingRule *bean = [[CreditRatingRule alloc] init];
            
            bean.minCreditScore = [[item objectForKey:@"min_credit_score"] intValue];// 信用积分
            bean.minAuditItems = [[item objectForKey:@"min_audit_items"] intValue];// 最低审核科目
            bean.isAllowOverdue = [item objectForKey:@"is_allow_overdue"];// 是否逾期扣分
            if ([[item objectForKey:@"image_filename"] hasPrefix:@"http"]) {
                
                  bean.imageFileName = [NSString stringWithFormat:@"%@",[item objectForKey:@"image_filename"]];// 借款标名称
            }else{
               
                bean.imageFileName = [NSString stringWithFormat:@"%@%@", Baseurl,[item objectForKey:@"image_filename"]];// 借款标名称
            }
           
            bean.mustItems = [item objectForKey:@"must_items"];
            bean.minCreditScore = [[item objectForKey:@"min_credit_score"] intValue];
            bean.suggest = [item objectForKey:@"suggest"] ; //
            bean.name = [item objectForKey:@"name"] ; //
//            {
//                "is_allow_overdue" : "是",
//                "id" : 1,
//                "image_filename" : "\/images?uuid=2b601645-217e-47b6-a950-05073ed992db",
//                "min_audit_items" : 0,
//                "entityId" : 1,
//                "min_credit_score" : 0,
//                "must_items" : "",
//                "persistent" : true,
//                "suggest" : "借款人审核资料少，历史记录一般，不建议投标。",
//                "is_enable" : true,
//                "name" : "信用等级为HR"
//            }
            
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
    
    // 服务器返回数据异常
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
