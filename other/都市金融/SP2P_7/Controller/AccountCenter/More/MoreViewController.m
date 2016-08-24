//
//  MoreViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-12.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreViewController.h"

#import "ColorTools.h"
#import "BarButtonItem.h"

#import "TabViewController.h"
#import "SettingViewController.h"
#import "MoreAboutusViewController.h"
#import "MoreHelpViewController.h"
#import "MoreCustomViewController.h"
#import "RestUIAlertView.h"
#import "LoginViewController.h"
#import "TabViewController.h"

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate, HTTPClientDelegate>
{
    NSArray *_titleArrays;
    NSMutableArray *_detailTextArr;
    BOOL _isDissmissFromLogin;
}

@property (nonatomic , strong)  UITableView *moreTableView;
@property (nonatomic , strong)  UILabel *Versionlabel;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    // 初始化数据
    [self initData];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //信息
    [parameters setObject:@"174" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:@"2" forKey:@"deviceType"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
    
    if (_isDissmissFromLogin) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _isDissmissFromLogin = NO;
    // 初始化视图
    [self initView];
}


/**
 初始化数据
 */
- (void)initData
{
    _titleArrays = @[@"关注官方微信",@"拨打客服电话",@"了解我们",@"退出帐号"];//@"打赏好评",
    _detailTextArr = [NSMutableArray array];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"关于我们";
    [self.view setBackgroundColor:KblackgroundColor];
    
    //    // 导航条 右边 设置按钮
//        UIBarButtonItem *settingItem=[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
//        settingItem.tag = 2;
//        settingItem.tintColor = [UIColor whiteColor];
//        [self.navigationItem setRightBarButtonItem:settingItem];
}

/**
 * 初始化内容详情
 */
- (void)initContentView
{
    CGFloat selfH = self.view.bounds.size.height;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, 280*selfH/568)];
    backView.backgroundColor = KColor;
    [self.view addSubview:backView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 30, 30, 30);
    backBtn.tag = 1;
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    //
    //    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    shareBtn.frame = CGRectMake(MSWIDTH - 45,30, 30, 30);
    //    [shareBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    //    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    //    [backView addSubview:shareBtn];
    //
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2 -50, 30, 100, 30)];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
    //    titleLabel.text = @"关于我们";
    //    [backView addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"logo"];
    imageView.frame = CGRectMake(MSWIDTH*0.5 - 75/2, 90, 75, 75);
    imageView.layer.cornerRadius = 37.5f;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:imageView];
    
    _Versionlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, MSWIDTH, 25)];
    _Versionlabel.font = [UIFont boldSystemFontOfSize:14];
    _Versionlabel.textAlignment = NSTextAlignmentCenter;
    _Versionlabel.textColor = [UIColor whiteColor];
    [backView addSubview:_Versionlabel];
    
    _moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame), self.view.frame.size.width, 220) style:UITableViewStyleGrouped];
    _moreTableView.delegate = self;
    _moreTableView.dataSource = self;
    _moreTableView.scrollEnabled = NO;
    
    [_moreTableView setBackgroundColor:KblackgroundColor];
    
    [self.view addSubview:_moreTableView];
}

/**
 * 导航条两侧按钮点击事件
 * 根据Button的tag值区分
 */
- (void)butClick:(UIButton *)but
{
    [self.navigationController popViewControllerAnimated:YES];
    //        TabViewController *tabViewController = [[TabViewController alloc] init];
//    TabViewController *tabViewController = [TabViewController shareTableView];
//    [self.frostedViewController presentMenuViewController];
//    self.frostedViewController.contentViewController = tabViewController;
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if (_detailTextArr.count) {
        
        cell.detailTextLabel.text = _detailTextArr[indexPath.section];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = _titleArrays[indexPath.section];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG(@"name - %@", _titleArrays[indexPath.section]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
            //        case 0:{
            //
            //            DLOG(@"打赏好评!");
            ////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms:appstore地址"]];
            //             [self  gotoAppStorePageRaisal:@"123456"];
            //
            //          }
            //            break;
//        case 0:
//        case 0:{
//            
//            DLOG(@"打赏好评!");
////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms:appstore地址"]];
//             [self  gotoAppStorePageRaisal:@"123456"];
//         
//          }
//            break;
        case 0:
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"公众号已复制到剪贴板,你可以微信-通讯录-搜索框粘贴\"%@\"公众号,点击关注即可.",_detailTextArr.count?_detailTextArr[0]:@"" ] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去关注", nil];
            alertView.tag = 11;
            [alertView show];
            
        }
            break;
        case 1:
        {
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:_detailTextArr.count?_detailTextArr[1]:@"" message:@"服务时间: 8:00 - 20:00" delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"拨打", nil];
            alertView1.delegate = self;
            alertView1.tag = 10;
            [alertView1 show];
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Baseurl]];
        }
            break;
            
        case 3:
        {
            //退出帐号
            // 记录 退出状态
            if (AppDelegateInstance.userInfo != nil) {
                [[AppDefaultUtil sharedInstance] removeGesturesPasswordWithAccount: AppDelegateInstance.userInfo.userName];// 移除该账号的手势密码
            }
            
            //            [[AppDefaultUtil sharedInstance] setDefaultUserName:@""];// 清除用户昵称
            //            [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
            [[AppDefaultUtil sharedInstance] setDefaultAccount:@""];// 清除用户账号
            [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:@""];// 清除用户头像
            
            AppDelegateInstance.userInfo = nil;
            AppDelegateInstance.userInfo.isLogin = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
            
//            TabViewController *tabViewController = [TabViewController shareTableView];
//            self.frostedViewController.contentViewController = tabViewController;
            LoginViewController *loginView = [[LoginViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginView];
            _isDissmissFromLogin = YES;
            [self presentViewController:navigationController animated:YES completion:nil];
//            [tabViewController presentViewController:navigationController animated:NO completion:nil];
            
        }
            break;
    }
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    //    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSString *platformName = [dics objectForKey:@"platformName"];
        NSString *platformTelephone = [dics objectForKey:@"platformTelephone"];
        _Versionlabel.text = [NSString stringWithFormat:@"版本号 %@", [dics objectForKey:@"version"]];
        // [_detailTextArr addObject:@""]; //appstore url连接
//        [_detailTextArr addObject:@""]; //appstore url连接
        [_detailTextArr addObject:platformName];//微信公众号
        [_detailTextArr addObject:platformTelephone];//客服电话
        [_detailTextArr addObject:[Baseurl substringWithRange:NSMakeRange(7, Baseurl.length - 7)]];//官网
        [_detailTextArr addObject:@""];
        
        [_moreTableView reloadData];
        
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
    //    [self hiddenRefreshView];
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    //    [self hiddenRefreshView];
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 10)
        {
            NSString *phoneNum = [_detailTextArr[1] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
            
        }else if (alertView.tag == 11)
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _detailTextArr.count?_detailTextArr[0]:@"";
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://wx12be9e3d2b80b0b4"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://wx12be9e3d2b80b0b4"]];
            }else{
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
            }
            
            
        }
        
    }else
        return;
}

//去app页面评价
-(void)gotoAppStorePageRaisal:(NSString *) nsAppId
{
    //    NSString *str = [NSString stringWithFormat:
    //                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa /wa/viewContentsUserReviews?type=Purple+Software&id=%d",
    //                     myAppID ];
    //
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



@end
