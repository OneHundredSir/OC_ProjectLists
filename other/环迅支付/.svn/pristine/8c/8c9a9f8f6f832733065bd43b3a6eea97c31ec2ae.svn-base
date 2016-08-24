//
//  CollectionViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》理财子账户————》收款中
#import "CollectionViewController.h"
#import "ColorTools.h"
#import "UIFolderTableView.h"
#import "ReceivingMoneyCell.h"
#import "JoinBlackListViewController.h"
#import "FinanceTransferViewController.h"
#import "BorrowingDetailsViewController.h"

#import "Collection.h"

@interface CollectionViewController ()<UIFolderTableViewDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate> {
    NSMutableArray *_dataArrays;// 数据
    
    NSInteger _total;// 总的数据
    
    NSInteger _currPage;// 查询的页数
    
    NSString *_borrowID;
}

@property (nonatomic,strong) UIFolderTableView *listView;
@property (nonatomic,strong) UIView *backview;
@property (nonatomic,strong) UIButton *addBtn;          // 记录 当前cell里面 + 的状态
@property (nonatomic,strong) UIButton *oldSelectBtn;    // 记录 上一次cell里面 + 的状态

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation CollectionViewController

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
    _dataArrays = [[NSMutableArray alloc] init];
    _borrowID = @"";
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [_listView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [_listView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 通知全局广播 LeftMenuController 修改UI操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"FinanceSuccess" object:nil];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"收款中的理财标";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

// 调用通知，刷新数据。
-(void) updateTable:(id)obj
{
//    [_listView headerBeginRefreshing];
    [self headerRereshing];
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
    ReceivingMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[ReceivingMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Collection *collection = _dataArrays[indexPath.section];
    cell.titleLabel.text = collection.title;
    
    if (collection.transferStatus == -1) {
        cell.stateLabel.text = @"已转让出";
    }else if (collection.transferStatus == 0) {
        cell.stateLabel.text = @"正常";
    }else if (collection.transferStatus == 1) {
        cell.stateLabel.text = @"转让中";
    }
    
//    cell.typeImg.image = [UIImage imageNamed:@"state_cast"];
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", collection.bidAmount];
    [cell.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreBtn.tag = indexPath.section + 11111;
    [cell.expandBtn setImage:[UIImage imageNamed:@"financial_expand_normal"] forState:UIControlStateNormal];
    [cell.expandBtn setImage:[UIImage imageNamed:@"financial_expand_selected"] forState:UIControlStateSelected];
    [cell.expandBtn addTarget:self action:@selector(expandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.expandBtn.tag = indexPath.section;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)_listView;
    
    Collection *collection = _dataArrays[indexPath.section];
    _borrowID = [NSString stringWithFormat:@"%d", collection.bidId];
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 135)];
    dropView.backgroundColor = [UIColor whiteColor];
    
    // 注册点击事件
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tapR.numberOfTouchesRequired = 1;
    tapR.numberOfTapsRequired = 1;
    [dropView addGestureRecognizer:tapR];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, dropView.frame.size.width + 100, 2)];
    line.text = @"------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    [dropView addSubview:line];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, dropView.frame.size.width, 20)];
    moneyLabel.text = [NSString stringWithFormat:@"本息合计应收: ￥%.2f", collection.receivingAmount];
    moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel];
    
    
    UILabel *moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, dropView.frame.size.width, 20)];
    moneyLabel2.text = [NSString stringWithFormat:@"已收金额: ￥%.2f", collection.hasReceivedAmount];
    moneyLabel2.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel2.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel2];
    
    UILabel *moneyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, dropView.frame.size.width, 20)];
    moneyLabel3.text = [NSString stringWithFormat:@"剩余应收: ￥%.2f", collection.receivingAmount - collection.hasReceivedAmount];
    moneyLabel3.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel3.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel3];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 83, dropView.frame.size.width, 20)];
    
    if (collection.periodUnit == 1 || collection.isSecBid == true) {
        stateLabel.text = [NSString stringWithFormat:@"账单情况: %@/1", collection.hasPaybackPeriod];
    }else {
        stateLabel.text = [NSString stringWithFormat:@"账单情况: %@/%d", collection.hasPaybackPeriod, collection.period];
    }
    stateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    stateLabel.textColor = [UIColor grayColor];
    [dropView addSubview:stateLabel];
    
    UILabel *wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 108, dropView.frame.size.width, 20)];
    wayLabel.text = [NSString stringWithFormat:@"逾期未还账单:%@", collection.overduePaybackPeriod];
    wayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    wayLabel.textColor = [UIColor grayColor];
    [dropView addSubview:wayLabel];
    
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
bool expandClicked = YES;
- (void)expandBtnClick:(UIButton *)btn
{
    UITableViewCell *cell1 = (UITableViewCell *)[btn superview];
    _addBtn = btn;
    
    if (_oldSelectBtn.selected != _addBtn.selected) {
        
        _oldSelectBtn.selected = NO;
        expandClicked = YES;
        
    }
    _oldSelectBtn = _addBtn;
    
    // 根据 expandClicked 的状态展开按钮，进入内页
    if (expandClicked) {
        _backview = [[UIView alloc] init];
        
        Collection *collection = _dataArrays[btn.tag];
        
        
        if (collection.transferStatus == -1 || collection.transferStatus == 1) {
            
            _backview.frame = CGRectMake(260, 49.5, 60, 30);
            
            UIButton *blacklistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            blacklistBtn.frame = CGRectMake(0, 0, _backview.frame.size.width, 30);
            [blacklistBtn setTitle:@"黑名单" forState:UIControlStateNormal];
            blacklistBtn.layer.borderWidth = 0.3f;
            blacklistBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
            [blacklistBtn addTarget:self action:@selector(blacklistBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            blacklistBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            blacklistBtn.backgroundColor = GreenColor;
            blacklistBtn.tag = btn.tag;
            [_backview addSubview:blacklistBtn];
            
        }else if (collection.transferStatus == 0) {
            
            _backview.frame = CGRectMake(260, 49.5, 60, 59);
            
            UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            transferBtn.frame = CGRectMake(0, 0, _backview.frame.size.width, 30);
            [transferBtn setTitle:@"转让" forState:UIControlStateNormal];
            transferBtn.layer.borderWidth = 0.3f;
            transferBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
            [transferBtn addTarget:self action:@selector(transferBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            transferBtn.tag = btn.tag;
            transferBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            transferBtn.backgroundColor = GreenColor;
            [_backview addSubview:transferBtn];
            btn.selected = YES;
            
            UIButton *blacklistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            blacklistBtn.frame = CGRectMake(0, 30, _backview.frame.size.width, 30);
            [blacklistBtn setTitle:@"黑名单" forState:UIControlStateNormal];
            blacklistBtn.layer.borderWidth = 0.3f;
            blacklistBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
            [blacklistBtn addTarget:self action:@selector(blacklistBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            blacklistBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            blacklistBtn.backgroundColor = GreenColor;
            blacklistBtn.tag = btn.tag;
            [_backview insertSubview:blacklistBtn aboveSubview:transferBtn];
        }
      
        _backview.backgroundColor = [UIColor whiteColor];
        [_backview bringSubviewToFront:_backview];
        [_listView insertSubview:_backview atIndex:5];
        if (btn.tag == 0) {
            
            if (collection.transferStatus == -1 || collection.transferStatus == 1) {
                
                _backview.frame = CGRectMake(cell1.frame.size.width - 60, 49.5, 60, 30);
            }else {
               _backview.frame = CGRectMake(cell1.frame.size.width - 60, 49.5, 60, 59);
            }
            
            
        }else {
            
            if (collection.transferStatus == -1 || collection.transferStatus == 1) {
                
                _backview.frame = CGRectMake(cell1.frame.size.width - 60, 49.5 + (btn.tag * 70) - (btn.tag * 1), 60, 30);
                
            }else {
                _backview.frame = CGRectMake(cell1.frame.size.width - 60, 49.5 + (btn.tag * 70) - (btn.tag * 1), 60, 59);
            }
        }
      
        expandClicked = NO;
        
    }else {
        DLOG(@"frame -> %f", _backview.frame.size.height);
        
        [_backview removeFromSuperview];
        btn.selected = NO;
        expandClicked = YES;
   }
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
    UIFolderTableView *folderTableView = (UIFolderTableView *)_listView;
    
    DLOG(@"btn.tag -> %ld", (long)btn.tag);
    Collection *collection = _dataArrays[btn.tag - 11111];
    _borrowID = [NSString stringWithFormat:@"%d", collection.bidId];
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 135)];
    dropView.backgroundColor = [UIColor whiteColor];
    
    // 注册点击事件
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tapR.numberOfTouchesRequired = 1;
    tapR.numberOfTapsRequired = 1;
    [dropView addGestureRecognizer:tapR];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, dropView.frame.size.width + 100, 2)];
    line.text = @"------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    [dropView addSubview:line];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, dropView.frame.size.width, 20)];
    moneyLabel.text = [NSString stringWithFormat:@"本息合计应收: ￥%.2f", collection.receivingAmount];
    moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel];
    
    
    UILabel *moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, dropView.frame.size.width, 20)];
    moneyLabel2.text = [NSString stringWithFormat:@"已收金额: ￥%.2f", collection.hasReceivedAmount];
    moneyLabel2.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel2.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel2];
    
    UILabel *moneyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, dropView.frame.size.width, 20)];
    moneyLabel3.text = [NSString stringWithFormat:@"剩余应收: ￥%.2f", collection.receivingAmount - collection.hasReceivedAmount];
    moneyLabel3.font = [UIFont boldSystemFontOfSize:12.0f];
    moneyLabel3.textColor = [UIColor grayColor];
    [dropView addSubview:moneyLabel3];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 83, dropView.frame.size.width, 20)];
    
    if (collection.periodUnit == 1 || collection.isSecBid == true) {
        stateLabel.text = [NSString stringWithFormat:@"账单情况: %@/1", collection.hasPaybackPeriod];
    }else {
        stateLabel.text = [NSString stringWithFormat:@"账单情况: %@/%d", collection.hasPaybackPeriod, collection.period];
    }
    stateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    stateLabel.textColor = [UIColor grayColor];
    [dropView addSubview:stateLabel];
    
    UILabel *wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 108, dropView.frame.size.width, 20)];
    wayLabel.text = [NSString stringWithFormat:@"逾期未还账单:%@", collection.overduePaybackPeriod];
    wayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    wayLabel.textColor = [UIColor grayColor];
    [dropView addSubview:wayLabel];
    
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

#pragma 点击展开跳转到账单详情页面
- (void)tapClick {
    DLOG(@"_borrowID ->%@", _borrowID);
    
    BorrowingDetailsViewController *borrowD = [[BorrowingDetailsViewController alloc] init];
    borrowD.borrowID = _borrowID;
    borrowD.stateNum = 5;
    [self.navigationController pushViewController:borrowD animated:YES];
}

#pragma mark 转让按钮
- (void)transferBtnClick:(UIButton *)btn
{
    DLOG(@"转让按钮");
    FinanceTransferViewController *financeTransferView = [[FinanceTransferViewController alloc] init];
    Collection *coll = _dataArrays[btn.tag];
    financeTransferView.investId = coll.investId;
    financeTransferView.bidAmount = [NSString stringWithFormat:@"￥%.2f", coll.bidAmount];
    financeTransferView.borrowID = [NSString stringWithFormat:@"%d",coll.bidId];
    
    [self.navigationController pushViewController:financeTransferView animated:YES];

}

#pragma mark 黑名单按钮
- (void)blacklistBtnClick:(UIButton *)btn
{
    DLOG(@"黑名单按钮");
    JoinBlackListViewController *joinBlackListView = [[JoinBlackListViewController alloc] init];
    Collection *coll = _dataArrays[btn.tag];
    joinBlackListView.bidId = coll.bidId;
    joinBlackListView.bidName = coll.name;
    
    [self.navigationController pushViewController:joinBlackListView animated:YES];
}

#pragma 返回按钮触发方法
- (void)backClick
{
      [self dismissViewControllerAnimated:YES completion:^(){}];
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [self hiddenRefreshView];
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:@"42" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
        [parameters setObject:@"1" forKey:@"currPage"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
        // 2.2秒后刷新表格UI
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 刷新表格
//            [_listView reloadData];
//            
//            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//            [self hiddenRefreshView];
//        });
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
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        // 清空全部数据
        if (_total == 1) {
            [_dataArrays removeAllObjects];
        }
        
        _total = [[dics objectForKey:@"totalNum"] intValue];// 总共多少条
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        DLOG(@"dataArr -> %@", dataArr);
        for (NSDictionary *item in dataArr) {
            Collection *collection = [[Collection alloc] init];
            collection.title = [item objectForKey:@"title"];
            collection.transferStatus = [[item objectForKey:@"transfer_status"] intValue];
//            collection.bidAmount = [[item objectForKey:@"bid_amount"] floatValue];
            
            collection.bidAmount = [[item objectForKey:@"receiving_amount"] floatValue] - [[item objectForKey:@"has_received_amount"] floatValue];
            
            collection.receivingAmount = [[item objectForKey:@"receiving_amount"] floatValue];
            collection.hasReceivedAmount = [[item objectForKey:@"has_received_amount"] floatValue];
            collection.hasPaybackPeriod = [item objectForKey:@"has_payback_period"];
            collection.overduePaybackPeriod = [item objectForKey:@"overdue_payback_period"];
            collection.bidId = [[item objectForKey:@"bid_id"] intValue];
            collection.investId = [[item objectForKey:@"id"] intValue];
            collection.name = [item objectForKey:@"name"];
            
            collection.periodUnit = [[item objectForKey:@"period_unit"] intValue];
            collection.isSecBid = [[item objectForKey:@"is_sec_bid"] boolValue];
            collection.period = [[item objectForKey:@"period"] intValue];
            
            [_dataArrays addObject: collection];
            
            DLOG(@"%@", [item objectForKey:@"period_unit"]);
            DLOG(@"%@", [item objectForKey:@"period_unit"]);
            
            if (collection.periodUnit == 1 || collection.isSecBid == true) {
                [NSString stringWithFormat:@"%@/1", collection.hasPaybackPeriod];
            }else {
                [NSString stringWithFormat:@"%@/%d", collection.hasPaybackPeriod, collection.period];
            }
            
            DLOG(@"bidAmount -> %f", collection.bidAmount);
        }
        
        // 刷新表格
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
    [self hiddenRefreshView];
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [self hiddenRefreshView];
     [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
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

#pragma Hidden View

// 隐藏刷新视图
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
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
    [_backview removeFromSuperview];
   _addBtn.selected = NO;
    expandClicked = YES;
}

@end
