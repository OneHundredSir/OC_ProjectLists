//
//  ConfirmedViewController.m
//  SP2P_6.1
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
#import "MyRechargeMYViewController.h"
#import <IPSSDK/zqzrViewController.h>
#import "HXData.h"

@interface ConfirmedViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate, UIAlertViewDelegate,zqzrDelegate>
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
    _acceptBtn.backgroundColor = GreenColor;
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
            creditorRightAssigneeDetailsView.signId = _sign;
            [self.navigationController pushViewController:creditorRightAssigneeDetailsView animated:YES];
            
        }
            break;
            
        case 1:
        {
            
            AssigneeLoanStandardDetailsViewController *assigneeLoanStandardDetailsView = [[AssigneeLoanStandardDetailsViewController alloc] init];
            assigneeLoanStandardDetailsView.signId = _sign;
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

#pragma mark - 成交
- (void)acceptBtnClick {
    _acceptBtn.userInteractionEnabled = NO;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定接受" message:[NSString stringWithFormat:@"您是否确定以 %@元 接受此债权？", _maxOfferPrice] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alertView.tag = 61;
    [alertView show];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    _acceptBtn.userInteractionEnabled = YES;
    NSDictionary *dics = obj;
    NSLog(@"竞拍债权确认===%@=======", dics);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
//        NSLog(@"msg -> %@", [obj objectForKey:@"msg"]);
//        
//        NSString *htmlParam = [NSString stringWithFormat:@"%@",[obj objectForKey:@"htmlParam"]];
//        MyWebViewController *web = [[MyWebViewController alloc]init];
//        web.html = htmlParam;
//        web.type = @"8";
//        [self.navigationController pushViewController:web animated:YES];
        
        //增加以下代码：
        [[NSNotificationCenter defaultCenter] postNotificationName:@"transferRefresh" object:self];
        
        HXData * item = [[HXData alloc] init];
        
        item.pMerCode = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerCode"]];
        item.pMerBillNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerBillNo"]];
        item.pMerDate = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerDate"]];
        item.pBidNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pBidNo"]];
        item.pContractNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pContractNo"]];
        item.pFromAccountType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pFromAccountType"]];
        item.pFromName = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pFromName"]];
        item.pFromAccount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pFromAccount"]];
        item.pFromIdentType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pFromIdentType"]];
        item.pFromIdentNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pFromIdentNo"]];
        item.pToAccountType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pToAccountType"]];
        item.pToAccountName = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pToAccountName"]];
        item.pToAccount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pToAccount"]];
        item.pToIdentType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pToIdentType"]];
        item.pToIdentNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pToIdentNo"]];
        item.pCreMerBillNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pCreMerBillNo"]];
        item.pCretAmt = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pCretAmt"]];
        item.pPayAmt = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pPayAmt"]];
        item.pFromFee = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pFromFee"]];
        item.pToFee = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pToFee"]];
        item.pCretType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pCretType"]];
        item.pS2SUrl = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pS2SUrl"]];
        item.pMemo1 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo1"]];
        item.pMemo2 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo2"]];
        item.pMemo3 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo3"]];

        [zqzrViewController transferBondWithPlatform:@"" pMerCode:item.pMerCode pMerBillNo:item.pMerBillNo pMerDate:item.pMerDate pBidNo:item.pBidNo pContractNo:item.pBidNo pFromAccountType:item.pFromAccountType pFromName:item.pFromName pFromAccount:item.pFromAccount pFromIdentType:item.pFromIdentType pFromIdentNo:item.pFromIdentNo pToAccountType:item.pToAccountType pToAccountName:item.pToAccountName pToAccount:item.pToAccount pToIdentType:item.pToIdentType pToIdentNo:item.pToIdentNo pCreMerBillNo:item.pCreMerBillNo pCretAmt:item.pCretAmt pPayAmt:item.pPayAmt pFromFee:item.pFromFee pToFee:item.pToFee pCretType:item.pCretType pS2SUrl:item.pS2SUrl pWhichAction:@"6" ViewController:self Delegate:self pMemo1:item.pMemo1 pMemo2:item.pMemo2 pMemo3:item.pMemo3];
        

      
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:@"服务器异常"];
    }
}


// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

- (void)transferBondResult:(NSString *)pErrCode ErrMsg:(NSString *)pErrMsg MerCode:(NSString *)pMerCode MerBillNo:(NSString *)pMerBillNo BidNo:(NSString *)pBidNo FromAccountType:(NSString *)pFromAccountType FromName:(NSString *)pFromName FromAccount:(NSString *)pFromAccount FromIdentType:(NSString *)pFromIdentType FromIdentNo:(NSString *)pFromIdentNo ToAccountType:(NSString *)pToAccountType ToAccountName:(NSString *)pToAccountName ToAccount:(NSString *)pToAccount ToIdentType:(NSString *)pToIdentType ToIdentNo:(NSString *)pToIdentNo CreMerBillNo:(NSString *)pCreMerBillNo CretAmt:(NSString *)pCretAmt PayAmt:(NSString *)pPayAmt CretType:(NSString *)pCretType FromFee:(NSString *)pFromFee ToFee:(NSString *)pToFee Status:(NSString *)pStatus P2PBillNo:(NSString *)pP2PBillNo Memo1:(NSString *)pMemo1 Memo2:(NSString *)pMemo2 Memo3:(NSString *)pMemo3
{
    DLOG(@"%@",pErrMsg);
//    [SVProgressHUD showErrorWithStatus:pErrMsg];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    switch (alertView.tag) {
//        case 60:
//        {
//            if (buttonIndex==0) {
//                MyRechargeMYViewController *RechargeView = [[MyRechargeMYViewController alloc] init];
//                UINavigationController *NaVController = [[UINavigationController alloc] initWithRootViewController:RechargeView];
//                [self presentViewController:NaVController animated:YES completion:nil];
//            }
//        }
//            break;
            
        case 61:
        {
            if (buttonIndex == 1) {
                if (AppDelegateInstance.userInfo == nil) {
                    [SVProgressHUD showErrorWithStatus:@"请登录!"];
                    _acceptBtn.userInteractionEnabled = YES;
                    
                    return;
                }
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setObject:@"51" forKey:@"OPT"];
                [parameters setObject:@"" forKey:@"body"];
                [parameters setObject:_sign forKey:@"sign"];
                [parameters setObject:@"2" forKey:@"app"];
                
                if (_requestClient == nil) {
                    _requestClient = [[NetWorkClient alloc] init];
                    _requestClient.delegate = self;
                }
                [_requestClient requestGet:@"app/services" withParameters:parameters];
            }else{
                _acceptBtn.userInteractionEnabled = YES;
                
            }
        }
            break;
            
        default:
            break;
    }
    
}

@end
