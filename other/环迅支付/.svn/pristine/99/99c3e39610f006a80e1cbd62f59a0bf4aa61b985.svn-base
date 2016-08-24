//
//  AttentionUserViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
////账户中心--》账户管理--》我关注的用户

#import "AttentionUserViewController.h"
#import "AttentionUserCell.h"
#import "ColorTools.h"
#import "MembershipDetailsViewController.h"

#import "AttentionUser.h"
#import "SendMessageViewController.h"

@interface AttentionUserViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;
    
    NSInteger _section;
    NSInteger isOPT;
}

@property (strong, nonatomic) UITableView *tableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AttentionUserViewController

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
    // Do any additional setup after loading the view.
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
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
    self.title = @"关注用户";
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
    return 65.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    AttentionUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AttentionUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    AttentionUser *bean = _dataArrays[indexPath.section];
    
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:bean.attentionUserPhoto]];
    cell.NameLabel.text = bean.attentionUserName;
    [cell.mailBtn setTag:indexPath.section];
    [cell.mailBtn addTarget:self action:@selector(mailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    MembershipDetailsViewController *MembershipDetailsView = [[MembershipDetailsViewController alloc] init];
//    [self.navigationController pushViewController:MembershipDetailsView animated:YES];
    
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    AttentionUser *bean = _dataArrays[indexPath.section];
    
    _section = indexPath.section;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"150" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)bean.uId] forKey:@"attentionId"];
    
    isOPT = 150;
    if (_requestClient == nil) {
        
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    _tableView.editing = UITableViewCellEditingStyleNone;
   
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma 站内信按钮触发方法
- (void)mailBtnClick:(UIButton *)sender
{
    AttentionUser *bean = _dataArrays[sender.tag];
     [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"发站内信给%@", bean.attentionUserName]];
    
    SendMessageViewController *sendMeg = [[SendMessageViewController alloc] init];
    sendMeg.borrowerid = [NSString stringWithFormat:@"%ld", (long)bean.attentionUserId];
    sendMeg.borrowName = bean.attentionUserName;
    [self.navigationController pushViewController:sendMeg animated:YES];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
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
    
    isOPT = 67;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"67" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];

    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
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
        
        if (isOPT == 67) {
            [_dataArrays removeAllObjects];// 清空全部数据
            
            NSArray *dataArr = [dics objectForKey:@"list"];
            for (NSDictionary *item in dataArr) {
                
                AttentionUser *bean = [[AttentionUser alloc] init];
                bean.attentionUserId = [[item objectForKey:@"attention_user_id"] intValue];// 好友用户ID
                if ([[item objectForKey:@"attention_user_photo"] hasPrefix:@"http"]) {
                    
                     bean.attentionUserPhoto = [NSString stringWithFormat:@"%@", [item objectForKey:@"attention_user_photo"]];//好友头像
                }else{
               
                    bean.attentionUserPhoto = [NSString stringWithFormat:@"%@%@",Baseurl, [item objectForKey:@"attention_user_photo"]];//好友头像
                }
                bean.attentionUserName = [item objectForKey:@"attention_user_name"];//好友用户名
                bean.sign = [item objectForKey:@"sign"];// 用户加密ID
                bean.signAttentionUserId = [item objectForKey:@"signAttentionUserId"];// 好友用户加密ID
                bean.userId = [[item objectForKey:@"user_id"] intValue];// 用户ID
                bean.uId = [[item objectForKey:@"id"] intValue];
                
                [_dataArrays addObject:bean];
            }
            
            [_tableView reloadData];
        }else if (isOPT == 150) {
            [_dataArrays removeObjectAtIndex:_section];
            [_tableView deleteSections: [NSIndexSet indexSetWithIndex: _section] withRowAnimation:UITableViewRowAnimationBottom];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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
