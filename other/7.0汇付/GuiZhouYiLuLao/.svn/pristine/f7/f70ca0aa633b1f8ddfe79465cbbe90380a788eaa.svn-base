//
//  ConfirmedViewController.m
//  SP2P_7
//
//  Created by kiu on 14/12/16.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//
//  账户中心 -> 理财子账户 -> 债权管理(受让债权管理) -> 转让中状态(opt = 51)

#import "ConfirmedViewController.h"
#import "ColorTools.h"
#import "CreditorRightAssigneeDetailsViewController.h"
#import "AssigneeLoanStandardDetailsViewController.h"
#import "MyWebViewController.h"
#import "MyRechargeViewController.h"
#import "OpenAccountViewController.h"

@interface ConfirmedViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate, UIAlertViewDelegate>
{
    NSArray *dataArr;
    
}

@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UIButton *acceptBtn;
@end

@implementation ConfirmedViewController

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
    
    
    dataArr = @[@"债权受让详情",@"受让的借款标详情"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    self.view.backgroundColor = KblackgroundColor;
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 170) style:UITableViewStyleGrouped];
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.separatorColor = [UIColor grayColor];
    listView.delegate = self;
    listView.scrollEnabled = NO;
    listView.dataSource = self;
    [self.view  addSubview:listView];
    
    // 成交
    _acceptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_acceptBtn setTitle:@"成 交" forState:UIControlStateNormal];
    [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _acceptBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _acceptBtn.frame = CGRectMake((self.view.frame.size.width - 120) * 0.5, 300, 120, 35);
    _acceptBtn.layer.cornerRadius = 3.0f;
    _acceptBtn.layer.masksToBounds = YES;
    _acceptBtn.backgroundColor = BrownColor;
    [_acceptBtn addTarget:self action:@selector(acceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_acceptBtn];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
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
    return 30.0f;
    
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
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.textLabel.text = [dataArr objectAtIndex:indexPath.section];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            CreditorRightAssigneeDetailsViewController *creditorRightAssigneeDetailsView = [[CreditorRightAssigneeDetailsViewController alloc] init];
            creditorRightAssigneeDetailsView.signId = _signId;
            [self.navigationController pushViewController:creditorRightAssigneeDetailsView animated:YES];
            
        }
            break;
            
        case 1:
        {
            
            AssigneeLoanStandardDetailsViewController *assigneeLoanStandardDetailsView = [[AssigneeLoanStandardDetailsViewController alloc] init];
            assigneeLoanStandardDetailsView.signId = _signId;
            [self.navigationController pushViewController:assigneeLoanStandardDetailsView animated:YES];
            
            
        }
            break;
    }
}



#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 成交
- (void)acceptBtnClick {
    _acceptBtn.userInteractionEnabled = NO;
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定接受" message:[NSString stringWithFormat:@"您确定以 %@ 元的竞价购买了用户 %@ %@ 元的债权吗？", _maxOfferPrice, _bidName, _receivedAmount] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定接受" message:[NSString stringWithFormat:@"您是否确定以 %@元 接受此债权？", _maxOfferPrice] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 51;
    [alertView show];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    _acceptBtn.userInteractionEnabled = YES;
    NSDictionary *dics = obj;
    DLOG(@"竞拍债权确认===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {

        if (![[obj objectForKey:@"htmlParam"]isEqual:[NSNull null]] && [obj objectForKey:@"htmlParam"] != nil)
        {
            NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
            MyWebViewController *web = [[MyWebViewController alloc]init];
            web.html = htmlParam;
            web.type = @"6";
            [self.navigationController pushViewController:web animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-31"])
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        OpenAccountViewController *openAccountVC = [[OpenAccountViewController alloc]init];
        openAccountVC.level = 1;
        [self.navigationController pushViewController:openAccountVC animated:YES];
    }
    else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-999"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"可用余额不足，是否现在充值？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 50;
        [alertView show];
    }
    
    else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        // 服务器返回数据异常
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
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1)
    {
        switch (alertView.tag)
        {
            case 50:
            {
                MyRechargeViewController *RechargeView = [[MyRechargeViewController alloc] init];
                RechargeView.level = 1;
                [self.navigationController pushViewController:RechargeView animated:YES];
            }
                break;
            case 51:
            {
                if (AppDelegateInstance.userInfo == nil) {
                    [ReLogin outTheTimeRelogin:self];
                    _acceptBtn.userInteractionEnabled = YES;
                    return;
                }
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setObject:@"51" forKey:@"OPT"];
                [parameters setObject:@"" forKey:@"body"];
                [parameters setObject:_sign forKey:@"sign"];
                [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
                
                if (_requestClient == nil) {
                    _requestClient = [[NetWorkClient alloc] init];
                    _requestClient.delegate = self;
                }
                [_requestClient requestGet:@"app/services" withParameters:parameters];
            }
                break;
            default:
                break;
        }
        
    }else{
        _acceptBtn.userInteractionEnabled = YES;
    }
    
    
}

@end
