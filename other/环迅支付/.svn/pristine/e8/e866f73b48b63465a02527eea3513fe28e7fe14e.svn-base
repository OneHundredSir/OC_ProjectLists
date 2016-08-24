//
//  LiteratureAuditViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心---》借款子账户----》资料审核
#import "LiteratureAuditViewController.h"

#import "ColorTools.h"
#import "LiteratureAuditTableViewCell.h"
#import "ReviewCourseDetailsViewController.h"
#import "RestUIAlertView.h"

#import "LiteratureAudit.h"

#import "NSString+Date.h"

//[判断是否有效：3是失效,2是有效 否则无效]（加载图片的判断：0是未提交 1审核中 2已通过审核 3过期失效 4未通过审核）

#define NO_Submitted 0// 未提交（无效）
#define Review 1// 审核中 （无效）
#define Success 2 // 已通过审核 （有效）
#define Failure 3// 过期失效   （失效）
#define Review_Failed 4// 未通过审核（无效）



@interface LiteratureAuditViewController ()<UITableViewDataSource, UITableViewDelegate, HTTPClientDelegate, UIAlertViewDelegate>
{
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
     NSInteger _typeNum;// 网络请求类型
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *signStr;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation LiteratureAuditViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRereshing];
}

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
    _typeNum = 0;
    _dataArrays = [[NSMutableArray alloc] init];
    _signStr = [[NSString alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:bottomView aboveSubview:_tableView];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(self.view.frame.size.width*0.5-110, 8,90, 25);
    upBtn.backgroundColor = GreenColor;
    [upBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    upBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [upBtn.layer setMasksToBounds:YES];
    [upBtn.layer setCornerRadius:3.0];
    [upBtn addTarget:self action:@selector(upBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:upBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.view.frame.size.width*0.5+20, 8,90, 25);
    cancelBtn.backgroundColor = GreenColor;
    [cancelBtn setTitle:@"取消上传" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn.layer setCornerRadius:3.0];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}



/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"借款资料审核认证";
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
    return 60.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    LiteratureAuditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[LiteratureAuditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    LiteratureAudit *bean = _dataArrays[indexPath.section];

    cell.titleLabel.text = bean.name;
    cell.stateLabel.text = bean.strStatus;
    
    switch (bean.status) {
        case NO_Submitted:
            cell.validLabel.text = [NSString stringWithFormat:@"（无效）"];
            // 未提交（无效）
//            cell.stateView.image = [UIImage imageNamed:@"state_no_submit"];
            
//            cell.stateLabel.text = bean.strStatus;
            [cell setStatus: NO_Submitted];
            break;
        case Review:
            // 审核中 （无效）
            cell.validLabel.text = [NSString stringWithFormat:@"（无效）"];
//            cell.stateView.image = [UIImage imageNamed:@"state_auditing"];
            
//            cell.stateLabel.text = bean.strStatus;
            [cell setStatus: Review];
            break;
        case Success:
            // 已通过审核 （有效）
            cell.validLabel.text = [NSString stringWithFormat:@"（有效）"];
//            cell.stateView.image = [UIImage imageNamed:@"state_pass"];
            
//            cell.stateLabel.text = bean.strStatus;
            [cell setStatus: Success];
            break;
        case Failure:
            // 过期失效   （失效）
            cell.validLabel.text = [NSString stringWithFormat:@"（失效）"];
//            cell.stateView.image = [UIImage imageNamed:@"state_failure"];
            
//            cell.stateLabel.text = bean.strStatus;
            [cell setStatus: Success];
            break;
        case Review_Failed:
            // 未通过审核（无效）
            cell.validLabel.text = [NSString stringWithFormat:@"（无效）"];
//            cell.stateView.image = [UIImage imageNamed:@"state_no_pass"];
            
//            cell.stateLabel.text = bean.strStatus;
            [cell setStatus: Success];
            break;
        default:
            break;
    }
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize _titleLabelSize = [cell.titleLabel.text boundingRectWithSize:CGSizeMake(999, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    cell.validLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x + _titleLabelSize.width + 5,-5, 64, 40);
    
    
    if (bean.expireTime != nil && ![bean.expireTime isEqual:[NSNull null]]) {
        cell.timeLabel.text = [NSString stringWithFormat:@"%@  到期", bean.expireTime];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReviewCourseDetailsViewController *reviewCourseDetailsView =[[ReviewCourseDetailsViewController alloc] init];
    LiteratureAudit *bean = _dataArrays[indexPath.section];
    reviewCourseDetailsView.literatureAudit = bean;
    [self.navigationController pushViewController:reviewCourseDetailsView animated:YES];

}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
      [self dismissViewControllerAnimated:YES completion:^(){}];
    
}



#pragma mark 取消上传
- (void)cancelBtnClick
{
    _typeNum = 3;
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"160" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];

}

#pragma mark 提交
- (void)upBtnClick
{
    _typeNum = 2;
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"159" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    if (_signStr) {
        [parameters setObject:_signStr forKey:@"sign"];
    }else
    [parameters setObject:@"" forKey:@"sign"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
    
    
}



#pragma mark 筛选按钮

- (void)ScreenClick
{
//    [self performSelector:@selector(presentRightMenuViewController:) withObject:self];
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
    [parameters setObject:@"94" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    [parameters setObject:@"" forKey:@"status"];
    [parameters setObject:@"" forKey:@"productId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];

//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [_tableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self hiddenRefreshView];
//    });
}

#pragma

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _currPage = 1;
    _total = 1;
    _typeNum = 1;
    [self requestData];
}


- (void)footerRereshing
{
    
    _currPage++;
    _typeNum = 1;
    [self requestData];
    
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
        
        if(_typeNum == 1){
 
            if (_currPage == 1) {
                [_dataArrays removeAllObjects];// 清空全部数据
            }
            
            _total = [[dics objectForKey:@"totalNum"] intValue];// 总共多少条
            
            NSArray *dataArr = [dics objectForKey:@"page"];
            if (dataArr.count) {
                
                for (NSDictionary *item in dataArr) {
                    LiteratureAudit *bean = [[LiteratureAudit alloc] init];
                    bean.name = [item objectForKey:@"name"];// 证件名称
                    bean.no = [item objectForKey:@"no"];// 审核科目编号
                    bean.status = [[item objectForKey:@"status"] intValue];//是否有效	3是失效,2是有效 否则无效
                    bean.strStatus = [item objectForKey:@"strStatus"];// 审核状态
                    
                    if ([item objectForKey:@"expire_time"] != nil && ![[item objectForKey:@"expire_time"] isEqual:[NSNull null]] ) {
                        bean.expireTime = [NSString converDate:[[item objectForKey:@"expire_time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd"];// 到期时间
                    }
                    
                    if ([item objectForKey:@"time"] != nil && ![[item objectForKey:@"time"] isEqual:[NSNull null]] ) {
                        bean.time = [NSString converDate:[[item objectForKey:@"time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd"];
                    }
                    
                    if ([item objectForKey:@"audit_time"] != nil && ![[item objectForKey:@"audit_time"] isEqual:[NSNull null]] ) {
                        bean.auditTime = [NSString converDate:[[item objectForKey:@"audit_time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd"];//
                    }
                    
                    bean.mark = [item objectForKey:@"mark"];// 审核资料唯一标识
                    bean.creditScore = [[item objectForKey:@"credit_score"] intValue];// 信用积分
                    
                    [_dataArrays addObject:bean];
                    
                    _signStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"sign"]];
                }
                
            }
//            NSArray *dataArr1 = [dics objectForKey:@"products"];
//            if (dataArr1.count) {
//             for (NSDictionary *item in dataArr1) {
//                
//                 _signStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"sign"]];
//             }
//           }
            
            // 刷新表格
            [_tableView reloadData];
        }else if(_typeNum == 2){
        
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            // 刷新表格
//            [self.tableView headerBeginRefreshing];
               [self headerRereshing];
            [self headerRereshing];
        
        }else {
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"22222%@", [obj objectForKey:@"msg"]]];
            
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
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
