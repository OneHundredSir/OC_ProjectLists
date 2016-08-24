//
//  AccuontSafeViewController.m
//  SP2P_7
//
//  Created by Kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》账户安全
#import "AccuontSafeViewController.h"
#import "FindDealPasssWordViewController.h"
#import "ChangeLoginPasswordViewController.h"
#import "SetSafeQuestionViewController.h"
#import "SetSafeQuestionViewTwoController.h"
#import "SetSafeEMailViewController.h"
#import "SetSafeEmailTwoViewController.h"
#import "SetSafePhoneNumViewController.h"
#import "SetSafePhoneNumTwoViewController.h"
#import "SetNewDealPassWordViewController.h"
#import "FindDealPasswordTwoViewController.h"
#import "RestUIAlertView.h"

#import "ColorTools.h"
#import "TabViewController.h"

@interface AccuontSafeViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *titleArr;

    BOOL _isEmailStatus;            // 邮箱设置状态
    BOOL _isPayPasswordStatus;      // 交易密码状态
    BOOL _isTeleStatus;             // 手机绑定状态
    
    BOOL _isLoading;
    NSString *_phoneNUmStr;
    NSString *_emailStr;

}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *detailArr;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, assign) BOOL isSecretStatus;           // 安全问题状态
@end

@implementation AccuontSafeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"安全";
    self.view.backgroundColor = KblackgroundColor;
//    [self initNavigationBar];
    
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
    //通知检测对象
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updatelist:) name:@"updatelist" object:nil];
    
    _isSecretStatus = AppDelegateInstance.userInfo.isSecretStatus;// 判断安全问题是否已经设置
    _isEmailStatus =AppDelegateInstance.userInfo.isEmailStatus;
    
    titleArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] initWithArray:@[@"安全邮箱",@"安全手机",@"安全问题",@"登录密码"]];
    _detailArr = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@"",@""]];
}

/**
 初始化数据
 */
- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark UItableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [_dataArr count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.5f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    cell.textLabel.text = [_dataArr objectAtIndex:indexPath.section];
    NSString *safeQue = _isSecretStatus? @"" : @"未设置";
    NSString *safeMail = _isEmailStatus? @"" : @"未设置";
    
    [_detailArr replaceObjectAtIndex:2 withObject:safeQue];
    [_detailArr replaceObjectAtIndex:0 withObject:safeMail];
    
    if (_detailArr.count) {
        cell.detailTextLabel.text = _detailArr[indexPath.section];
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case 0:
        {
            // 安全邮箱
            if (AppDelegateInstance.userInfo.isSecretStatus) { // 已设置安全问题
                
                if (AppDelegateInstance.userInfo.isEmailStatus) {// 已经设置安全邮箱
                
                    SetSafeEMailViewController *setSafeEMailView = [[SetSafeEMailViewController alloc] init];
                    setSafeEMailView.isSafeQuestion = _isSecretStatus;
                    
                    [self.navigationController pushViewController:setSafeEMailView animated:YES];
                    
                }else{  // 未设置安全邮箱
                    DLOG(@"确定按钮");
                    SetSafeEmailTwoViewController *SetSafeEmailTwoView = [[SetSafeEmailTwoViewController alloc] init];
                    [self.navigationController pushViewController:SetSafeEmailTwoView animated:YES];
                }
                
            }else {// 没有设置安全问题
                SetSafeQuestionViewTwoController *setSafeQuestionViewTwo = [[SetSafeQuestionViewTwoController alloc] init];
                [self.navigationController pushViewController:setSafeQuestionViewTwo animated:YES];

                [SVProgressHUD showErrorWithStatus:@"亲，请先设置安全问题"];
            }
            
        }
            break;
        case 1:
        {
            // 安全手机
//            if (AppDelegateInstance.userInfo.isSecretStatus) {
//                if (AppDelegateInstance.userInfo.isMobileStatus) {
            
                    SetSafePhoneNumViewController *setSafePhoneNumView = [[SetSafePhoneNumViewController alloc] init];
                    setSafePhoneNumView.isTeleStatus = _isTeleStatus;
                    [self.navigationController pushViewController:setSafePhoneNumView animated:YES];
//                }else{
            
                    // 未设置安全手机
//                    SetSafePhoneNumTwoViewController *SetSafePhoneNumTwoView = [[SetSafePhoneNumTwoViewController alloc] init];
//                    [self.navigationController pushViewController:SetSafePhoneNumTwoView animated:YES];
                    
                    
//                }
//                
//            }else {
////                [SVProgressHUD showErrorWithStatus:@"亲，请先设置安全问题"];
//                SetSafeQuestionViewTwoController *setSafeQuestionViewTwo = [[SetSafeQuestionViewTwoController alloc] init];
//                [self.navigationController pushViewController:setSafeQuestionViewTwo animated:YES];
//            }
            
        }
            break;
        case 2:
        {
            // 安全问题
            DLOG(@"dddddddd- > %d", AppDelegateInstance.userInfo.isSecretStatus);
            
            if (!_isLoading) {
                // 不在请求数据
                if (AppDelegateInstance.userInfo.isSecretStatus) {
                    // 有安全问题
                    SetSafeQuestionViewTwoController *setSafeQuestionViewTwo = [[SetSafeQuestionViewTwoController alloc] init];
                    [self.navigationController pushViewController:setSafeQuestionViewTwo animated:YES];
                    
                }else {
                    // 未设置安全问题
                    SetSafeQuestionViewController *setSafeQuestionView = [[SetSafeQuestionViewController alloc] init];
                    [self.navigationController pushViewController:setSafeQuestionView animated:YES];
                }
            }
            
        }
            break;
        case 3:
        {
            //修改登录密码
            if (AppDelegateInstance.userInfo.isMobileStatus) {
                
                ChangeLoginPasswordViewController *changeLoginPasswordView = [[ChangeLoginPasswordViewController alloc] init];
                [self.navigationController pushViewController:changeLoginPasswordView animated:YES];
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"亲，你还没有设置安全手机"];
                
            }
        }
            break;
//        case 4:
//        {
//            //修改交易密码
//            if (AppDelegateInstance.userInfo.isSecretStatus) {
//                if (AppDelegateInstance.userInfo.isMobileStatus) {
//                    if (AppDelegateInstance.userInfo.isPayPasswordStatus) {
//                        
//                        ChangeLoginPasswordViewController *changeLoginPasswordView = [[ChangeLoginPasswordViewController alloc] init];
//                        changeLoginPasswordView.viewType = @"tradePwd";
//                        [self.navigationController pushViewController:changeLoginPasswordView animated:YES];
//                        
//                    }else {
//                        SetNewDealPassWordViewController *setDealPass = [[SetNewDealPassWordViewController alloc] init];
//                        setDealPass.ispayPasswordStatus = AppDelegateInstance.userInfo.isPayPasswordStatus;
//                        setDealPass.statuStr = @"正常设置";
//                        [self.navigationController pushViewController:setDealPass animated:YES];
//                    }
//                }else {
//                    [SVProgressHUD showErrorWithStatus:@"亲，你还没有设置安全手机"];
//                }
//            }else {
//                [SVProgressHUD showErrorWithStatus:@"亲，请先设置安全问题"];
//            }
//            
//        }
//            break;
//        case 5:
//        {
//            // 找回交易密码
//            if (AppDelegateInstance.userInfo.isSecretStatus) {
//                if (AppDelegateInstance.userInfo.isMobileStatus) {
//                    if (AppDelegateInstance.userInfo.isPayPasswordStatus) {
//                        //                            FindDealPasssWordViewController *findDealPasssWordView = [[FindDealPasssWordViewController alloc] init];
//                        //                            [self.navigationController pushViewController:findDealPasssWordView animated:YES];
//                        
//                        FindDealPasswordTwoViewController *findDeal = [[FindDealPasswordTwoViewController alloc] init];
//                        [self.navigationController pushViewController:findDeal animated:YES];
//                        
//                    }else {
//                        //                            SetNewDealPassWordViewController *setDealPass = [[SetNewDealPassWordViewController alloc] init];
//                        //                            setDealPass.ispayPasswordStatus = AppDelegateInstance.userInfo.isPayPasswordStatus;
//                        //                            setDealPass.statuStr = @"正常设置";
//                        //                            [self.navigationController pushViewController:setDealPass animated:YES];
//                        [SVProgressHUD showErrorWithStatus:@"亲，请先设置交易密码"];
//                    }
//                }else {
//                    [SVProgressHUD showErrorWithStatus:@"亲，你还没有设置安全手机"];
//                }
//            }else {
//                [SVProgressHUD showErrorWithStatus:@"亲，请先设置安全问题"];
//            }
//            
//        }
//            break;
            
    }
}


#pragma 返回按钮触发方法
- (void)backClick
{
    
    switch (self.backTypeNum ) {
        case 0:
        {
//            TabViewController *tabViewController = [[TabViewController alloc] init];
             TabViewController *tabViewController = [TabViewController shareTableView];
             [self.frostedViewController presentMenuViewController];
            self.frostedViewController.contentViewController = tabViewController;
        
        }
            break;
        case 1:
        {
             [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
            
        default:{
          
            [self dismissViewControllerAnimated:YES completion:^(){}];
        }
            break;
    }

  
}

#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"138" forKey:@"OPT"];// 客户端安全问题是否设置接口
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
       
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    _isLoading = YES;
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    DLOG(@"===%@=======", dics);
    
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _isPayPasswordStatus = [[dics objectForKey:@"payPasswordStatus"] boolValue];
        _isTeleStatus = [[dics objectForKey:@"teleStatus"] boolValue];
        _isEmailStatus = [[dics objectForKey:@"emailStatus"] boolValue];
        _isSecretStatus = [[dics objectForKey:@"SecretStatus"] boolValue];
        _phoneNUmStr = [dics objectForKey:@"mobile"];
        _emailStr = [dics objectForKey:@"email"];
        
        if (!_isPayPasswordStatus) {
            _dataArr = [NSMutableArray arrayWithArray:@[@"安全邮箱",@"安全手机",@"安全问题",@"登录密码"]];
            _detailArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@""]];
        }else {
            _dataArr = [NSMutableArray arrayWithArray:@[@"安全邮箱",@"安全手机",@"安全问题",@"登录密码",@"修改交易密码",@"找回交易密码"]];
            _detailArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@""]];
        }
        
        NSString *saftQue;
        if (_isSecretStatus) {
            
           saftQue = @"";
            
        }else{
            
             saftQue = @"未设置";
            
        }
         [_detailArr replaceObjectAtIndex:0 withObject:saftQue];
        
        NSString *saftPwd;
        if (_isPayPasswordStatus) {
            
            saftPwd = @"";
            
        }else{
            
            saftPwd = @"未设置";
            
        }
        [_detailArr replaceObjectAtIndex:4 withObject:saftPwd];
        
        if (_phoneNUmStr == nil || [_phoneNUmStr isEqual:[NSNull null]]) {

            _phoneNUmStr = @"未设置";
        }else{
         
          _phoneNUmStr = [NSString stringWithFormat:@"%@****%@",[_phoneNUmStr substringWithRange:NSMakeRange(0, 3)],[_phoneNUmStr substringWithRange:NSMakeRange(_phoneNUmStr.length-4, 4)]];
        
        }
        [_detailArr replaceObjectAtIndex:1 withObject:_phoneNUmStr];
        
//        if (_emailStr == nil || [_emailStr isEqual:[NSNull null]]) {
//            
//            _emailStr = @"未设置";
//        }
//        [_detailArr replaceObjectAtIndex:2 withObject:_emailStr];
        NSString *security;
        if (_isSecretStatus) {
            security = @"";
        }else {
            security = @"未设置";
        }
        [_detailArr replaceObjectAtIndex:2 withObject:security];
     
        
        [self setView];
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        // 服务器返回数据异常
       [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
    _isLoading = NO;
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    _isLoading = NO;
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
     _isLoading = NO;
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

#pragma mark - 根据服务器信息，更新tableView数据
- (void)setView {
//    if (_isPayPasswordStatus) {
//        [_dataArr replaceObjectAtIndex:3 withObject:@"修改交易密码"];
//    }else {
//        [_dataArr replaceObjectAtIndex:3 withObject:@"设置交易密码"];
//    }
//    
//    if (_isSecretStatus) {
//        [_dataArr replaceObjectAtIndex:0 withObject:@"修改安全问题"];
//    }else {
//        [_dataArr replaceObjectAtIndex:0 withObject:@"设置安全问题"];
//    }
//    
//    if (AppDelegateInstance.userInfo.isEmailStatus) {
//        [_dataArr replaceObjectAtIndex:2 withObject:@"修改安全邮箱"];
//    }else {
//        [_dataArr replaceObjectAtIndex:2 withObject:@"设置安全邮箱"];
//    }
//    
//    if (AppDelegateInstance.userInfo.isMobileStatus) {
//        [_dataArr replaceObjectAtIndex:1 withObject:@"修改安全手机"];
//    }else {
//        [_dataArr replaceObjectAtIndex:1 withObject:@"设置安全手机"];
//    }
//    
    // 储存是否设置安全手机 (0、 未设置  1、设置)
    AppDelegateInstance.userInfo.isMobileStatus = _isTeleStatus;
    AppDelegateInstance.userInfo.isTeleStatus = _isTeleStatus;
    // 储存是否设置交易密码 (0、 未设置  1、设置)
    AppDelegateInstance.userInfo.isPayPasswordStatus = _isPayPasswordStatus;
    // 储存是否设置安全问题 (0、 未设置  1、设置)
    AppDelegateInstance.userInfo.isSecretStatus = _isSecretStatus;
    [_tableView reloadData];
}

//通知中心触发方法
-(void)updatelist:(NSNotification *)notification
{
    NSString *str = (NSString *)[notification object];
    DLOG(@"通知中心触发方法==============%@===========", AppDelegateInstance.userInfo.userImg);
    
    if ([str isEqualToString:@"3"]) {
//        [_dataArr replaceObjectAtIndex:3 withObject:@"修改交易密码"];
       _isPayPasswordStatus = AppDelegateInstance.userInfo.isPayPasswordStatus = YES;
    }
    if ([str isEqualToString:@"0"]) {
//        [_dataArr replaceObjectAtIndex:0 withObject:@"修改安全问题"];
       _isSecretStatus = AppDelegateInstance.userInfo.isSecretStatus = YES;
    }
    if ([str isEqualToString:@"2"]) {
//        [_dataArr replaceObjectAtIndex:2 withObject:@"修改安全邮箱"];
        _isEmailStatus = AppDelegateInstance.userInfo.isEmailStatus = YES;
    }
    if ([str isEqualToString:@"1"]) {
//        [_dataArr replaceObjectAtIndex:1 withObject:@"修改安全手机"];
      _isTeleStatus = AppDelegateInstance.userInfo.isMobileStatus = YES;
    }
    
    [_tableView reloadData];
}

@end
