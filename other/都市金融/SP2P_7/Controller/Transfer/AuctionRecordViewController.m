//
//  AuctionRecordViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AuctionRecordViewController.h"
#import "ColorTools.h"
#import "AuctionRecordCell.h"
#import "AuctionViewController.h"
#import "TenderRecords.h"

@interface AuctionRecordViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>
{
    
    NSArray *titleArr;
    
}
@property(nonatomic ,strong) NSMutableArray *listDataArr;
@property(nonatomic ,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AuctionRecordViewController

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
    
    titleArr = @[@"竞拍人",@"竞拍出价",@"竞拍时间"];
    
    _listDataArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //竞拍投标记录
    [parameters setObject:@"32" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_creditorId] forKey:@"creditorId"];
    [parameters setObject:@"1" forKey:@"currPage"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 104-64)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i<[titleArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake((self.view.frame.size.width/3)*i, 0, self.view.frame.size.width/3, 44);
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [backView addSubview:titleLabel];
        
    }
    
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 106-64, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.scrollEnabled = YES;
    _listView.dataSource = self;
    [self.view  addSubview:_listView];
    
    
     if (AppDelegateInstance.userInfo != nil && _outTimeNum != 1  && _status == 1) {
         
         _listView.frame = CGRectMake(0, 106, self.view.frame.size.width, self.view.frame.size.height-44-40);
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tenderBtn.frame = CGRectMake(0, 0,MSWIDTH, 44);
    tenderBtn.backgroundColor = GreenColor;
    [tenderBtn setTitle:@"我要竞拍" forState:UIControlStateNormal];
    [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
//    [tenderBtn.layer setMasksToBounds:YES];
//    [tenderBtn.layer setCornerRadius:3.0];
    [tenderBtn addTarget:self action:@selector(tenderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tenderBtn];
    
     }
    
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"竞拍记录";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
//    // 导航条分享按钮
//    UIBarButtonItem *ShareItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(ShareClick)];
//    ShareItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setRightBarButtonItem:ShareItem];
}



// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{

    DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        
        if (dataArr.count!= 0) {
            
            for (NSDictionary *dic in dataArr) {
                
                TenderRecords *model = [[TenderRecords alloc] init];
                model.userName = [dic objectForKey:@"name"];
                model.tendAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"offer_price"]];
                NSDate *date;
                if([dic objectForKey:@"time"] != nil && ![[dic objectForKey:@"time"] isEqual:[NSNull null]]){
                    
                    date = [NSDate dateWithTimeIntervalSince1970: [[[dic objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    model.time = [dateFormat stringFromDate: date];
                }else{
                
                   model.time = @"00-00";
                }
                
                [_listDataArr addObject:model];
                
            }
            
            [_listView reloadData];
            
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else{
        
        DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
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
   [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}


#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_listDataArr count];
    
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
    return 35.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    AuctionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AuctionRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TenderRecords *recordmodel = [_listDataArr objectAtIndex:indexPath.section];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", recordmodel.userName];
    cell.bidLabel.text = [NSString stringWithFormat:@"%@", recordmodel.tendAmount];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", recordmodel.time];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    // DLOG(@"返回按钮");
     [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma 分享按钮
- (void)ShareClick
{
     DLOG(@"分享按钮");

    if (AppDelegateInstance.userInfo == nil) {
        
          [ReLogin outTheTimeRelogin:self];        
    }else {
        DLOG(@"分享按钮");
        
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@/front/invest/invest?bidId=竞拍记录", Baseurl];
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"sp2p 7.1.2晓风网贷 我要投资 借款详情"
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"logo"]]
                                                    title:@"借款详情"
                                                      url:shareUrl
                                              description:@"这是一条测试信息"
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        DLOG(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        DLOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [error errorDescription]]];
                                    }
                                }];
    }
}


#pragma 竞拍
- (void)tenderBtnClick
{
    
    if (AppDelegateInstance.userInfo == nil) {
        
        
       [ReLogin outTheTimeRelogin:self];        
    }
    else
    {
        
        DLOG(@"竞拍按钮！！！");
        AuctionViewController *AuctionView = [[AuctionViewController alloc] init];
        AuctionView.creditorId = _creditorId;
        [self.navigationController pushViewController:AuctionView animated:YES];
        
        
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
