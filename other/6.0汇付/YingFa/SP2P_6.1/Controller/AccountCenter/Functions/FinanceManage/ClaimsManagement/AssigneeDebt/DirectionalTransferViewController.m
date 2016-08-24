//
//  DirectionalTransferViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(受让债权管理) -> 定向转让

#import "DirectionalTransferViewController.h"
#import "ColorTools.h"
#import "CreditorRightAssigneeDetailsViewController.h"
#import "AssigneeLoanStandardDetailsViewController.h"
#import "MyRechargeViewController.h"
#import "MyWebViewController.h"

@interface DirectionalTransferViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate, UIAlertViewDelegate>
{
    NSInteger requestType;
    NSArray *dataArr;
    
}

@property(nonatomic ,strong) NetWorkClient *requestClient;
@end

@implementation DirectionalTransferViewController

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
    
   
    dataArr = @[@"债权受让详情",@"受让的借款标详情"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    
    self.view.backgroundColor = KblackgroundColor;

    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 170) style:UITableViewStyleGrouped];
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.separatorColor = [UIColor grayColor];
    listView.delegate = self;
    listView.scrollEnabled = NO;
    listView.dataSource = self;
    [self.view  addSubview:listView];
    
    //接受受让
    UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [acceptBtn setTitle:@"接受受让" forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    acceptBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    acceptBtn.frame = CGRectMake(20, 300, 120, 30);
    acceptBtn.layer.cornerRadius = 3.0f;
    acceptBtn.layer.masksToBounds = YES;
    acceptBtn.backgroundColor = PinkColor;
    [acceptBtn addTarget:self action:@selector(acceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:acceptBtn];
    
    //拒绝受让
    UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rejectBtn setTitle:@"拒绝受让" forState:UIControlStateNormal];
    [rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rejectBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    rejectBtn.frame = CGRectMake(170, 300, 120, 30);
    rejectBtn.backgroundColor= GreenColor;
    rejectBtn.layer.cornerRadius = 4.0f;
    rejectBtn.layer.masksToBounds = YES;
    [rejectBtn addTarget:self action:@selector(rejectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rejectBtn];
    
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

// 接受转让
- (void)acceptBtnClick {
    requestType = 59;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定接受" message:[NSString stringWithFormat:@"您确定以 %@ 元的竞价购买了用户 %@ %@ 元的债权吗？", _maxOfferPrice, _bidName, _receivedAmount] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag  = 59;
    [alertView show];
}

// 拒绝转让
- (void)rejectBtnClick {
    
    requestType = 60;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"拒绝转让" message:[NSString stringWithFormat:@"您确定拒绝用户 %@ 向您发起的定向转让吗？", _bidName] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 60;
    [alertView show];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    NSDictionary *dics = obj;
    DLOG(@"接受转让===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
        
        if (requestType == 59) {//接受转让
            
            NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
            MyWebViewController *web = [[MyWebViewController alloc]init];
            DLOG(@"htmlParam  -> %@", htmlParam);
            
            web.html = htmlParam;
            web.type = @"9";
            [self.navigationController pushViewController:web animated:YES];
            
//            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
//            
//            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSLog(@"拒绝转让");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"markupSuccess" object:self];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-999"]) {
        
        // [SVProgressHUD showErrorWithStatus:@"您的可用余额不足，请到电脑端充值！"];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"可用余额不足，是否现在充值？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 50;
        [alertView show];
        
    }
    else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
        switch (alertView.tag) {
            case 50: //余额不足
            {
                MyRechargeViewController *RechargeView = [[MyRechargeViewController alloc] init];
                UINavigationController *NaVController17 = [[UINavigationController alloc] initWithRootViewController:RechargeView];
                [self presentViewController:NaVController17 animated:YES completion:nil];
            }
                break;
            case 59: // 确认转让
            {
                if (AppDelegateInstance.userInfo == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请登录!"];
                    return;
                }
                
                requestType = 59;
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setObject:[NSString stringWithFormat:@"%ld", (long)requestType] forKey:@"OPT"];
                [parameters setObject:@"" forKey:@"body"];
                [parameters setObject:_sign forKey:@"sign"];
                [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
                DLOG(@"userID  %@",AppDelegateInstance.userInfo.userId);
                DLOG(@"sign  %@",_sign);
                
                if (_requestClient == nil) {
                    _requestClient = [[NetWorkClient alloc] init];
                    _requestClient.delegate = self;
                }
                [_requestClient requestGet:@"app/services" withParameters:parameters];
                
            }
                break;
            case 60: // 拒绝受让
            {
                requestType = 60;
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setObject:[NSString stringWithFormat:@"%ld", (long)requestType] forKey:@"OPT"];
                [parameters setObject:@"" forKey:@"body"];
                [parameters setObject:_signId forKey:@"sign"];
                [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
                NSLog(@"userID  %@",AppDelegateInstance.userInfo.userId);
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
        
    }
    
}

@end
