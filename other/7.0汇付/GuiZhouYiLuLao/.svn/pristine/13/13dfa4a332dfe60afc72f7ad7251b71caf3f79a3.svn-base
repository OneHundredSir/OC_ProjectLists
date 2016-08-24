//
//  MyCollectionObligationsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 我收藏的债权

#import "MyCollectionObligationsViewController.h"
#import "ColorTools.h"
#import "CreditorTransfer.h"

#import "DetailsOfCreditorViewController.h"
#import "CreditorTransferTableViewCell.h"

#import "NSString+Date.h"

@interface MyCollectionObligationsViewController ()<HTTPClientDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataArrays;
    
    NSInteger _section;
    NSInteger isOPT;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end


@implementation MyCollectionObligationsViewController

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

- (void)readData
{
    _dataArrays =[[NSMutableArray alloc] init];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"creditor_transfer_list" withExtension:@"plist"];
    NSArray *collections = [NSArray arrayWithContentsOfURL:url];
    for (NSDictionary *item in collections) {
        CreditorTransfer *bean = [[CreditorTransfer alloc] init];
        bean.title = [item objectForKey:@"title"];
        bean.content = [item objectForKey:@"content"];
        
        bean.principal = [[item objectForKey:@"principal"] floatValue];
        bean.minPrincipal = [[item objectForKey:@"minPrincipal"] floatValue];
        bean.currentPrincipal = [[item objectForKey:@"currentPrincipal"] floatValue];
        
        [_dataArrays addObject:bean];
    }
}


/**
 * 初始化数据
 */
- (void)initData
{
    //[self readData];
    _dataArrays =[[NSMutableArray alloc] init];
}

/**
 初始化数据
 */
- (void)initView
{
    self.view.backgroundColor = KblackgroundColor;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -104) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_tableView headerBeginRefreshing];
       [self headerRereshing];
    
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _dataArrays.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    CreditorTransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CreditorTransferTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CreditorTransfer *object = [_dataArrays objectAtIndex:indexPath.section];
    
    [cell fillCellWithObject:object];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 2.0f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 2.0f;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CreditorTransfer *object = [_dataArrays objectAtIndex:indexPath.section];
    DetailsOfCreditorViewController *detailsOfCreditorView = [[DetailsOfCreditorViewController alloc] init];
    detailsOfCreditorView.creditorId =  [NSString stringWithFormat:@"%ld",(long)object.creditorId];
    detailsOfCreditorView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsOfCreditorView animated:YES];
}

// 先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    CreditorTransfer *bean = _dataArrays[indexPath.section];
    
    _section = indexPath.section;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"154" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)bean.attentionDebtId] forKey:@"attentionDebtId"];
    
    isOPT = 154;
    if (_requestClient == nil) {
        
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
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
    
    isOPT = 65;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"65" forKey:@"OPT"];
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
        
        if (isOPT == 65) {
            [_dataArrays removeAllObjects];// 清空全部数据
            
            NSArray *dataArr = [dics objectForKey:@"list"];
            for (NSDictionary *item in dataArr) {
                
                CreditorTransfer *bean = [[CreditorTransfer alloc] init];
                bean.title = [item objectForKey:@"transfer_title"];
                bean.apr = [item objectForKey:@"apr"];
                
                //剩余时间
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"end_time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
                NSDate *senddate=[NSDate date];
                //结束时间
                NSDate *endDate = date;
                //当前时间
                NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
                //得到相差秒数
                NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
                int days = ((int)time)/(3600*24);
                int hours = ((int)time)%(3600*24)/3600;
                int minute = ((int)time)%(3600*24)%3600/60;
                
                //            DLOG(@"相差时间 天:%i 时:%i 分:%i",days,hours,minute);
                if (days > 0){
                    bean.time = [[NSString alloc] initWithFormat:@"%i",days];
                    bean.sortTime = (int)time;
                    bean.units =@"天";
                }else  if (hours > 0){
                    
                    bean.time = [[NSString alloc] initWithFormat:@"%i",hours];
                    bean.sortTime = (int)time;
                    bean.units =@"时";
                    
                }else if (minute > 0){
                    bean.time = [[NSString alloc] initWithFormat:@"%i",minute];
                    bean.sortTime = (int)time;
                    bean.units =@"分";
                }
                else if (minute <= 0)
                {
                    bean.time = [[NSString alloc] initWithFormat:@"%i",0];
                    bean.sortTime = (int)time;
                    bean.units =@"分";
                    
                }
                
                //还款时间
                if ([item objectForKey:@"repayment_time"]  != nil && ![[item objectForKey:@"repayment_time"]  isEqual:[NSNull null]]) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"repayment_time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                    NSDate *senddate=[NSDate date];
                    //结束时间
                    NSDate *endDate =  [dateFormat dateFromString:[dateFormat stringFromDate:date]];
                    //当前时间
                    NSDate *senderDate = [dateFormat dateFromString:[dateFormat stringFromDate:senddate]];
                    //得到相差秒数
                    bean.repaytime = (int)[endDate timeIntervalSinceDate:senderDate];
                }else{
                    
                    bean.repaytime = 0;
                }
                
                bean.attentionDebtId = [[item objectForKey:@"id"] intValue];
                bean.creditorId = [[item objectForKey:@"invest_transfer_id"] intValue];
                bean.content = [item objectForKey:@"transfer_reason"];
                bean.principal = [[item objectForKey:@"debt_amount"] floatValue];
                bean.minPrincipal = [[item objectForKey:@"transfer_price"] floatValue];
                bean.currentPrincipal = [[item objectForKey:@"max_offer_price"] floatValue];
                bean.isQuality = [[item objectForKey:@"is_quality_debt"] boolValue];
                //             bean.isQuality = YES;
                [_dataArrays addObject:bean];
            }
            
            [_tableView reloadData];

        }else if (isOPT == 154) {
            [_dataArrays removeObjectAtIndex:_section];
            [_tableView deleteSections: [NSIndexSet indexSetWithIndex: _section] withRowAnimation:UITableViewRowAnimationBottom];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        }
    
    }else if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
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
