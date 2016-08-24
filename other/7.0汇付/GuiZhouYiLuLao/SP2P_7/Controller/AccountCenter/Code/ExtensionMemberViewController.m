//
//  ExtensionMemberViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  成功推广的会员

#import "ExtensionMemberViewController.h"

#import "ColorTools.h"
#import "Member.h"
#import "MemberTableViewCell.h"
#import "ExtensionDetailViewController.h"
#import "UIFolderTableView.h"

@interface ExtensionMemberViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
}

@property (nonatomic, strong) UIFolderTableView *listView;
//  是否打开二级详情
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation ExtensionMemberViewController

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
    
    self.isOpen = NO;
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initContentView];

}

/**
 初始化数据
 */
- (void)initData
{
    _currPage = 1;
    _total = 1;
    _collectionArrays =[[NSMutableArray alloc] init];
}



/**
 * 初始化内容详情
 */
- (void)initContentView
{
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, MSHIGHT-104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.showsVerticalScrollIndicator = NO;
    _listView.showsHorizontalScrollIndicator = NO;
    [_listView setBackgroundColor:KblackgroundColor];
    
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _collectionArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"memberCell";
    
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[MemberTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    [cell.more setTag:indexPath.section + 11111];
    
    
    Member *_member = [_collectionArrays objectAtIndex:indexPath.section];
    
    [cell fillCellWithObject:_member];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Member *_member = [_collectionArrays objectAtIndex:indexPath.section];
    
    ExtensionDetailViewController *subVc = [[ExtensionDetailViewController alloc] init];
    
    subVc.registrationDate = _member.registrationDate;
    subVc.recommend = _member.loan;
    subVc.manage = _member.manage;
    subVc.bonus = _member.bonus;
    
    UITableViewCell *cell1 = [_listView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell1 viewWithTag:indexPath.section + 11111];
    
    DLOG(@"%d", btn.selected);
    if (btn.selected == 0) {
        btn.selected = 1;
    }
    
    _listView.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                     //[self CloseAndOpenACtion:indexPath];
                                     btn.selected = !btn.selected;
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

-(void)CloseAndOpenACtion:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectIndex]) {
        self.isOpen = NO;
        [self didSelectCellRowFirstDo:NO nextDo:NO];
        self.selectIndex = nil;
    }
    else
    {
        if (!self.selectIndex) {
            self.selectIndex = indexPath;
            [self didSelectCellRowFirstDo:YES nextDo:NO];
            
        }
        else
        {
            [self didSelectCellRowFirstDo:NO nextDo:YES];
        }
    }
}
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [_listView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

#pragma mark 1、返回
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _currPage = 1;
    _total = 1;
    
    [self requestData];
}


- (void)footerRereshing
{
    _currPage++;
    
    [self requestData];
}


#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
        
        return;
    }else {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"29" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_currPage] forKey:@"currPage"];
        [parameters setObject:[NSString stringWithFormat:@"%ld", (long)_type] forKey:@"type"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
    }
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [self hiddenRefreshView];
    
    NSDictionary *dics = obj;
    
    DLOG(@"dics->%@",dics);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        DLOG(@"加载数据中.....");
        
        if (_total == 1) {
            [_collectionArrays removeAllObjects];// 清空全部数据
        }
        
        NSDictionary *roots = [dics objectForKey:@"page"];
        
        if (![[dics objectForKey:@"page"] isEqual:[NSNull null]]) {
            
            NSArray *results = [roots objectForKey:@"page"];
            
            _total = [[roots objectForKey:@"totalCount"] intValue];
            
            for (NSDictionary *item in results) {
                Member *bean = [[Member alloc] init];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[item objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
                [dataFormat setDateFormat:@"yyyy-MM-dd hh:mm"];
                
                bean.registrationDate = [dataFormat stringFromDate: date];
                bean.dateTime = bean.registrationDate;
                
                bean.name = [item objectForKey:@"recommend_user_name"];
                bean.isActive = [[item objectForKey:@"is_active"] boolValue];
                bean.manage = [item objectForKey:@"all_amount"];
                bean.bonus = [item objectForKey:@"all_cps_reward"];
                bean.loan = [item objectForKey:@"name"];
                
                [_collectionArrays addObject:bean];
            }
        }
        [_listView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
    //    [SVProgressHUD showErrorWithStatus:@"网络异常"];
    [self hiddenRefreshView];
    
}

// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    [self hiddenRefreshView];
}

#pragma mark - Hidden View 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!_listView.isHeaderHidden) {
        [_listView headerEndRefreshing];
    }
    
    if (!_listView.isFooterHidden) {
        [_listView footerEndRefreshing];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hiddenRefreshView];
    
//    if (_requestClient != nil) {
//        [_requestClient cancel];
//    }
}

@end
