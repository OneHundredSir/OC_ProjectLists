//
//  AuditSubjectViewController.m
//  SP2P_7
//
//  Created by Jerry on 14/11/22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AuditSubjectViewController.h"
#import "ColorTools.h"
#import "AuditSubjectCell.h"
#import "QCheckBox.h"
#import "ReviewIntegralDetail.h"

@interface AuditSubjectViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSInteger _currePage;
    NSMutableArray *_dataArrays;
}


@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic,strong) QCheckBox *check;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *checkArrays;

@end

@implementation AuditSubjectViewController

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
    _checkArrays = [[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
    [self headerRereshing];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tenderBtn.frame = CGRectMake(self.view.frame.size.width*0.5-50, 8,100, 25);
    tenderBtn.backgroundColor = BrownColor;
    [tenderBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [tenderBtn.layer setMasksToBounds:YES];
    [tenderBtn.layer setCornerRadius:3.0];
    [tenderBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tenderBtn];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"选择审核科目";
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
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",indexPath.section];
    AuditSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AuditSubjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ReviewIntegralDetail *bean = _dataArrays[indexPath.section];
    cell.depictLabel.text = [NSString stringWithFormat:@"%@",bean.descriptionStr];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", bean.name];
    
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
    cell.payLabel.text = [NSString stringWithFormat:@"¥%ld",(long)bean.auditFee];
    
    //单选按钮
    _check = [[QCheckBox alloc] initWithDelegate:self];
    _check.frame = CGRectMake(10, 8, 60, 60);
    [_check setTag:indexPath.section];
    [_check setImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
    [_check setImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateSelected];
    [_check setTitle:nil forState:UIControlStateNormal];
    [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    
    [cell.contentView addSubview:_check];
    for (int i=0; i<[_dataArrays count]; i++) {
        ReviewIntegralDetail *model = [_dataArrays objectAtIndex:i];
        if (_check.tag == model.Tag) {
            if(model.Checked)
            {
                _check.selected= YES;
                [_check setImage:[UIImage imageNamed:@"checkbox2_checked"] forState:UIControlStateNormal];
            
            }else{
            
              _check.selected= NO;
              [_check setImage:[UIImage imageNamed:@"checkbox2_unchecked"] forState:UIControlStateNormal];
            
            
            }
        
            
        }
    }
      [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma 返回按钮触发方法
- (void)backClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma  确定按钮按钮触发
- (void)sureClick
{
    
    DLOG(@"审核科目确定按钮!");
    
    for (int i=0; i<[_dataArrays count]; i++) {
        ReviewIntegralDetail *model = [_dataArrays objectAtIndex:i];
        if (model.Checked) {
            [_checkArrays addObject:model];
        }
    }
    
     [[NSNotificationCenter defaultCenter]  postNotificationName:@"selected" object:_checkArrays];
      [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    DLOG(@"did tap on CheckBox:%ld checked:%d", (long)checkbox.tag, checked);
    if (checkbox.checked) {
     for (int i=0; i<[_dataArrays count]; i++) {
         ReviewIntegralDetail *model = [_dataArrays objectAtIndex:i];
         if (model.Tag == checkbox.tag) {
             
                model.Checked = 1;
         }
        
     
     }
        
    }else{
     
        for (int i=0; i<[_dataArrays count]; i++) {
            ReviewIntegralDetail *model = [_dataArrays objectAtIndex:i];
             if (model.Tag == checkbox.tag) {
                model.Checked = 0;
            }
        }
     
     }
   
    [_tableView reloadData];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _currePage =1;
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
    [parameters setObject:@"123" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [_tableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self hiddenRefreshView];
//    });
    
    
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
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        int i = 0;
        for (NSDictionary *item in dataArr) {
            
            ReviewIntegralDetail *bean = [[ReviewIntegralDetail alloc] init];
          
            bean.name = [item objectForKey:@"name"] ; //
            bean.no= [item objectForKey:@"id"] ; //
            bean.type= [[item objectForKey:@"type"] intValue]; //
            bean.creditScore = [[item objectForKey:@"creditScore"] intValue]; //
            bean.auditCycle = [[item objectForKey:@"auditCycle"] intValue]; //
            bean.auditFee = [[item objectForKey:@"auditFee"] intValue]; //
            bean.period = [[item objectForKey:@"period"] intValue]; //
            bean.creditLimit = creditLimitNum * [[item objectForKey:@"creditScore"] intValue]; //
            bean.descriptionStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"description"]];
            bean.Tag = i++;
            bean.Checked = 0;
            [_dataArrays addObject:bean];
        }
        
        [_tableView reloadData];
        
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