//
//  BlackListViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
////账户中心--》账户管理--》黑名单

#import "BlackListViewController.h"
#import "ColorTools.h"
#import "UIFolderTableView.h"
#import "BlackListCell.h"
#import "NSString+Date.h"
#import "BlackList.h"

@interface BlackListViewController ()<UIFolderTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, HTTPClientDelegate>
{
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _section;
    NSInteger isOPT;
}

@property (nonatomic,strong)  UIFolderTableView *listView;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end
@implementation BlackListViewController

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
    self.view.backgroundColor = KblackgroundColor;
    
    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [_listView headerBeginRefreshing];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"黑名单";
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
    NSString *cellid = [NSString stringWithFormat:@"cellid%ld",(long)indexPath.section];
    BlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[BlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BlackList *bean = _dataArrays[indexPath.section];
    
    cell.NameLabel.text = bean.blacklistName;
    cell.idLabel.text = [NSString stringWithFormat:@"关联借款标编号:%ld", (long)bean.bidId];
    cell.timeLabel.text = bean.time;
    [cell.moreBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
    [cell.moreBtn  setImage:[UIImage imageNamed:@"expan_up_btn"] forState:UIControlStateSelected];
    [cell.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
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
    BlackList *bean = _dataArrays[indexPath.section];
    
    _section = indexPath.section;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"152" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)bean.rowId] forKey:@"blacklistId"];
    
    isOPT = 152;
    if (_requestClient == nil) {
        
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFolderTableView *folderTableView = (UIFolderTableView *)_listView;
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    dropView.backgroundColor = [UIColor whiteColor];
    
    BlackList *bean = _dataArrays[indexPath.section];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWIDTH, 1)];
    line.backgroundColor = KblackgroundColor;
    [dropView addSubview:line];
    
    UILabel *reasonTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    reasonTextLabel.text = @"原因:";
    reasonTextLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    reasonTextLabel.textColor = [UIColor darkGrayColor];
    [dropView addSubview:reasonTextLabel];
    
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, dropView.frame.size.width-60, 80)];
    reasonLabel.text = bean.reason;
    reasonLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    reasonLabel.textAlignment = NSTextAlignmentJustified;
    reasonLabel.numberOfLines = 0;
    reasonLabel.textColor = [UIColor grayColor];
    [dropView addSubview:reasonLabel];
    
    
    //判断内容尺寸
    CGSize maxSize = CGSizeMake(MSWIDTH-60, 10000);
    CGSize ViewSize = [bean.reason boundingRectWithSize:maxSize
                                                options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                context:nil].size;
    
    
    reasonLabel.frame = CGRectMake(50, 10, MSWIDTH-60, ViewSize.height+5);
    dropView.frame = CGRectMake(0, 0, MSWIDTH, ViewSize.height+30);
    
    _listView.scrollEnabled = NO;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:dropView
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
                               _listView.scrollEnabled = YES;
                           }];
    
}

#pragma 更多按钮触发方法
- (void)moreBtnClick:(UIButton *)btn
{
    UITableViewCell *cell;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {
        
        cell = (UITableViewCell *)[btn superview];
    }else {
        cell = (UITableViewCell *)[[btn superview]  superview];
    }
    
    NSIndexPath *index1 = [_listView indexPathForCell:cell];
    DLOG(@"index1.setion is %ld",(long)index1.section);
    // NSIndexPath *index1 =  [NSIndexPath indexPathForItem:btn.tag inSection:0];
    UIFolderTableView *folderTableView = (UIFolderTableView *)_listView;
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, 80)];
    dropView.backgroundColor = [UIColor whiteColor];
    
    
    BlackList *bean = _dataArrays[index1.section];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWIDTH, 1)];
    line.backgroundColor = KblackgroundColor;
    [dropView addSubview:line];
    
    UILabel *reasonTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    reasonTextLabel.text = @"原因:";
    reasonTextLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    reasonTextLabel.textColor = [UIColor darkGrayColor];
    [dropView addSubview:reasonTextLabel];
    
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, dropView.frame.size.width-60, 21)];
    reasonLabel.text = bean.reason;
    reasonLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    reasonLabel.textAlignment = NSTextAlignmentJustified;
    reasonLabel.numberOfLines = 0;
    reasonLabel.textColor = [UIColor grayColor];
    [dropView addSubview:reasonLabel];
    
    
    //判断内容尺寸
    CGSize maxSize = CGSizeMake(MSWIDTH-60, 10000);
    CGSize ViewSize = [bean.reason boundingRectWithSize:maxSize
                                                options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                context:nil].size;
    
    
    reasonLabel.frame = CGRectMake(50, 10, MSWIDTH-60, ViewSize.height+5);
    dropView.frame = CGRectMake(0, 0, MSWIDTH, ViewSize.height+30);
    
    
    _listView.scrollEnabled = NO;
    [folderTableView openFolderAtIndexPath:index1 WithContentView:dropView
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
                               _listView.scrollEnabled = YES;
                           }];
    
    
}



#pragma 输入框代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma 返回按钮触发方法
- (void)backClick
{
    _listView.editing = UITableViewCellEditingStyleNone;
    
    [self dismissViewControllerAnimated:YES completion:^(){}];
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
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    isOPT = 68;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"68" forKey:@"OPT"]; //已成功的借款标查询
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
        
        if (isOPT == 68) {
            NSArray *dataArr = [dics objectForKey:@"list"];
            for (NSDictionary *item in dataArr) {
                BlackList *bean = [[BlackList alloc] init];
                bean.blacklistName = [item objectForKey:@"blacklist_name"];
                bean.rowId = [[item objectForKey:@"id"] intValue];
                bean.reason = [item objectForKey:@"reason"];
                bean.bidId =  [[item objectForKey:@"bid_id"] intValue];
                bean.time = [NSString converDate:[[item objectForKey:@"time"] objectForKey:@"time"] withFormat:@"yyyy-MM-dd"];
                
                [_dataArrays addObject:bean];
            }
            
            [_listView reloadData];
            
        }else if (isOPT == 152) {
            
            [_dataArrays removeObjectAtIndex:_section];
            [_listView deleteSections: [NSIndexSet indexSetWithIndex: _section] withRowAnimation:UITableViewRowAnimationBottom];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            
        }
        
    } else {
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
    if (!self.listView.isHeaderHidden) {
        [self.listView headerEndRefreshing];
    }
    
    if (!self.listView.isFooterHidden) {
        [self.listView footerEndRefreshing];
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
