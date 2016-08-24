//
//  AJAccountController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/13.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJAccountController.h"
#import "AJAccountHeaderView.h"
#import "AJAccountCellData.h"
#import "AccountCell.h"
#import "AJBorrowerInfoEditCoontroller.h"
#import "BillManageViewController.h" // 账单
#import "TradeRecordViewController.h"//交易记录
//#import "RechargeViewController.h" // 充值
//#import "WithdrawalViewController.h" // 提现
#import "MyWithdrawalViewController.h"// 汇付提现
//#import "BankCardManageViewController.h" // 银行卡
#import "DebtManagementViewController.h" // 债权转让
#import "TwoCodeViewController.h" // CPS推广
//#import "ChangeIconViewController.h" // 修改头像
#import "AccountInfoViewController.h"
#import "AccuontSafeViewController.h" // 安全
#import "MailViewController.h" // 消息
#import "MoreViewController.h"//关于
#import "AJDailyManagerController.h"//日利宝
#import "AJDailyEarningRepayController.h"
#import "AJAccountHeaderData.h"
#import "MyRechargeViewController.h"// 充值
#import "JSONKit.h"

#define ktabHeaderHeight 556.f/2
#define ksectionSpace 20.f/2
@interface AJAccountController ()<AJAccountHeaderViewDelegate, HTTPClientDelegate>
@property (nonatomic, strong) NSArray *cellDatas;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, strong) AJAccountHeaderData *accountData;
@property (nonatomic, assign) BOOL rechargeSuccess;
@end

@implementation AJAccountController

- (NSArray *)cellDatas
{
    if (_cellDatas == nil) {
        
        AJAccountCellData *cell1 = [[AJAccountCellData alloc]initWithText:@"日利宝" Img:@"Account_dairyearing" desClass:NSStringFromClass([AJDailyManagerController class])];
//         AJAccountCellData *cell1_ = [[AJAccountCellData alloc]initWithText:@"日利宝还款" Img:@"Account_dairyearing" desClass:NSStringFromClass([AJDailyEarningRepayController class])];
        AJAccountCellData *cell2 = [[AJAccountCellData alloc]initWithText:@"账单" Img:@"Account_check" desClass:NSStringFromClass([BillManageViewController class])];
//        AJAccountCellData *cell3 = [[AJAccountCellData alloc]initWithText:@"银行卡" Img:@"Account_bankcard" desClass:NSStringFromClass([BankCardManageViewController class])];
        NSArray *section0 = @[cell1,/* cell1_*/ cell2/*, cell3*/];
        AJAccountCellData *cell4 = [[AJAccountCellData alloc]initWithText:@"债权宝管理" Img:@"Account_transfer" desClass:NSStringFromClass([DebtManagementViewController class])];
//        AJAccountCellData *cell5 = [[AJAccountCellData alloc]initWithText:@"CPS推广" Img:@"Account_GPS" desClass:NSStringFromClass([TwoCodeViewController class])];
        AJAccountCellData *cell6 =  [[AJAccountCellData alloc]initWithText:@"安全" Img:@"Account_safe" desClass:NSStringFromClass([AccuontSafeViewController class])];
        AJAccountCellData *cell7 = [[AJAccountCellData alloc]initWithText:@"关于我们" Img:@"Account_about" desClass:NSStringFromClass([MoreViewController class])];
        NSArray *section1 = @[cell4, cell6, cell7];
        _cellDatas = @[section0, section1];
    }
    return _cellDatas;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    // 拦截外部设置
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {}
    return self;
}
- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self requestAccountData];
    
    if (self.rechargeSuccess) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)requestAccountData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //竞拍相关信息
    [parameters setObject:@"164" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.requestClient requestGet:@"app/services" withParameters:parameters];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rechargeSuccess = NO;
    [self initSubView];
}

- (void)initSubView
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf requestAccountData];
    }];
    
    AJAccountHeaderView *header = [[AJAccountHeaderView alloc] initWithDelegate:self];
    header.frame = CGRectMake(0, 0, 0, ktabHeaderHeight + 90.f/2);
    self.tableView.tableHeaderView = header;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
}

#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellDatas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountCell *cell = [AccountCell cellWithTableView:tableView];
    cell.data = (AJAccountCellData*)self.cellDatas[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.f/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section==0)? ksectionSpace:0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ksectionSpace;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AJAccountCellData *data = self.cellDatas[indexPath.section][indexPath.row];
    Class controllerClass = NSClassFromString(data.className);
    UIViewController *destinationController = (UIViewController *)[controllerClass new];
    
    if (controllerClass) {
         [self.navigationController pushViewController:destinationController animated:!self.rechargeSuccess];
        self.rechargeSuccess = NO;
    }
    
}
#pragma  mark - AJAccountHeaderViewDelegate
- (void)AJAccountHeaderViewWithClickBtnTo:(clickBtnTo)sender
{
    switch (sender) {
        case clickBtnToMessage:// 消息
        {
            MailViewController *controller = [[MailViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
           
            break;
        case clickBtnToDetail:// 明细
        {// 资金明细
            TradeRecordViewController  *controller = [[TradeRecordViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }

            break;
        case clickBtnToPortrait:// 头像
        {
            // 先查询是个人标 还是企业标
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setObject:@"3" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [self.requestClient requestParameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                
                DLOG( @"%@", [responseObject JSONString]);
                
                if ([responseObject[@"error"] intValue] == -1) {
                    
                    [SVProgressHUD dismiss];
                    if ([[responseObject allKeys] containsObject:@"businessLicense"]) { //企业
                        
                        
                        AJBorrowerInfoEditCoontroller  *controller = [[AJBorrowerInfoEditCoontroller alloc] init];
                        [controller setValue:@YES forKey:@"ipsAcctNo"];
                        [controller setValue:@"企业信息编辑" forKey:@"title"];
                        [controller setValue:responseObject forKey:@"responseObj"];
                   
                        [self.navigationController pushViewController:controller animated:YES];

             
                        
                    }else{
                        
                        AccountInfoViewController  *controller = [[AccountInfoViewController alloc] init];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                    
                }else{
                    
                    [SVProgressHUD showImage:nil status:responseObject[@"msg"]];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                
            }];
          
        }
            break;
        case clickBtnToRecharge:// 充值
        {
            MyRechargeViewController  *controller = [[MyRechargeViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case clickBtnToWithdrawal:// 提现
        {
            MyWithdrawalViewController  *controller = [[MyWithdrawalViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        
        self.accountData = [[AJAccountHeaderData alloc] initWithDict:dics];
        if (AppDelegateInstance.userInfo != nil) { // 已登录才进入账户中心，而登陆后AppDelegateInstance.userInfo必然有值
            [self update];
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    
}
//通知中心触发方法
-(void)update
{
   self.accountData.userName = AppDelegateInstance.userInfo.userName;
   self.accountData.userImg = AppDelegateInstance.userInfo.userImg;
    AJAccountHeaderView *header = (AJAccountHeaderView*)self.tableView.tableHeaderView;
    header.aAJAccountHeaderData = self.accountData;
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


@end