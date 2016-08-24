//
//  AssigneeingDebtViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  账户中心 -> 理财子账户 -> 债权管理(受让债权管理) -> 竞拍中

#import "AssigneeingDebtViewController.h"
#import "ColorTools.h"
#import "CreditorRightAssigneeDetailsViewController.h"
#import "AssigneeLoanStandardDetailsViewController.h"

#import "PushAlertView.h"
#import "NSString+encryptDES.h"

@interface AssigneeingDebtViewController ()<UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate, UIAlertViewDelegate>
{
    
    NSArray *titlyArr;
    NSArray *dataArr;
    
    NSString *collectCapitalValue;
    NSString *hightestBidValue;
    NSString *myBidValue;
    
    int isOPT;
    NSString *newBidValue;
    NSString *dealpwd;
}

@property (nonatomic, strong) UILabel *assigneeStatus;   // 受让状态
@property (nonatomic, strong) UILabel *assigneeWay;      // 受让方式
@property (nonatomic, strong) UILabel *collectCapital;   // 待收本金
@property (nonatomic, strong) UILabel *hightestBid;      // 最高竞价
@property (nonatomic, strong) UILabel *myBid;            // 我的竞价

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AssigneeingDebtViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    isOPT = 55;
    [self requestData];
}

/**
 * 初始化数据
 */
- (void)initData
{
    
     titlyArr = @[@"受让状态:",@"受让方式:",@"原待收本金:",@"竞拍最高价:",@"我的竞拍价:"];
     dataArr = @[@"债权受让详情",@"受让的借款标详情"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
     [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    for (int i = 0; i<[titlyArr count]; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(20, 75+i*30, 120, 30);
        titleLabel.text = [titlyArr objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.view addSubview:titleLabel];
        
    }
    
    _assigneeStatus = [[UILabel alloc] initWithFrame:CGRectMake(90, 75, 200, 30)];
    _assigneeStatus.text = @"竞拍中";
    _assigneeStatus.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _assigneeStatus.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_assigneeStatus];
    
    _assigneeWay = [[UILabel alloc] initWithFrame:CGRectMake(90, 105, 200, 30)];
    _assigneeWay.text = @"竞价转让";
    _assigneeWay.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    _assigneeWay.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_assigneeWay];
    
    
    
    _collectCapital = [[UILabel alloc] initWithFrame:CGRectMake(105, 135, 200, 30)];
    _collectCapital.text = @"";
    _collectCapital.font = [UIFont systemFontOfSize:15.0];
    _collectCapital.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_collectCapital];
    
    
    _hightestBid = [[UILabel alloc] initWithFrame:CGRectMake(105, 165, 200, 30)];
    _hightestBid.text = @"";
    _hightestBid.font = [UIFont systemFontOfSize:15.0];
    _hightestBid.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_hightestBid];
    
    
    _myBid = [[UILabel alloc] initWithFrame:CGRectMake(105, 195, 200, 30)];
    _myBid.text = @"";
    _myBid.font = [UIFont systemFontOfSize:15.0];
    _myBid.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_myBid];
    
    
    //加价
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addBtn setTitle:@"加价" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    addBtn.frame = CGRectMake(self.view.frame.size.width*0.5-60, 260, 120, 30);
    addBtn.layer.cornerRadius = 3.0f;
    addBtn.layer.masksToBounds = YES;
    addBtn.backgroundColor = GreenColor;
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-75, self.view.frame.size.width, 70) style:UITableViewStyleGrouped];
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.separatorColor = [UIColor grayColor];
    listView.delegate = self;
    listView.scrollEnabled = NO;
    listView.dataSource = self;
    [self.view  addSubview:listView];
    
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
            creditorRightAssigneeDetailsView.signId = _signId;
            [self.navigationController pushViewController:creditorRightAssigneeDetailsView animated:YES];
            
        }
            break;
            
        case 1:
        {
            
            AssigneeLoanStandardDetailsViewController *assigneeLoanStandardDetailsView = [[AssigneeLoanStandardDetailsViewController alloc] init];
            assigneeLoanStandardDetailsView.signId = _signId;
            [self.navigationController pushViewController:assigneeLoanStandardDetailsView animated:YES];
        }
            break;
            
    }
}

#pragma 加价按钮触发方法
- (void)addBtnClick
{

    DLOG(@"加价");
    
    PushAlertView *pushAlert  =  [[PushAlertView alloc] initWithTitle:@"确认成交" collectCapitalText:collectCapitalValue hightestBidText:hightestBidValue offerPriceText:myBidValue leftButtonTitle:@"确定" rightButtonTitle:@"取消"];
    isOPT = 58;
    
    pushAlert.leftBlock = ^() {
        // 确定按钮
        newBidValue = pushAlert.alertnewPriceTF.text;
//        dealpwd = [NSString encrypt3DES:pushAlert.dealpwdTextF.text key:DESkey];
//        dealpwd = pushAlert.dealpwdTextF.text;
//        DLOG(@"确定 -> %@", pushAlert.alertnewPriceTF.text);
//        DLOG(@"dealpwd -> %@", dealpwd);
        
        [self requestData];
    };
    
    pushAlert.rightBlock = ^() {
        // 取消按钮
    };
    pushAlert.dismissBlock = ^() {
        
    };
    [pushAlert show];

}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        DLOG(@"确定");
    }else {
        DLOG(@"取消");
    }
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 加载数据
 */
- (void)requestData
{
    if (AppDelegateInstance.userInfo == nil||_signId == nil) {
          [ReLogin outTheTimeRelogin:self];        
        return;
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@"" forKey:@"body"];
        
        if (isOPT == 55) {
            [parameters setObject:@"55" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:_signId forKey:@"signId"];
        }else if (isOPT == 58) {
            
            DLOG(@"_sign -> %@", _sign);
            
            [parameters setObject:@"58" forKey:@"OPT"];
            [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
            [parameters setObject:_sign forKey:@"sign"];
            [parameters setObject:newBidValue forKey:@"NewBid"];
//            [parameters setObject:dealpwd forKey:@"dealpwd"];
        }

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
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        if (isOPT == 55) {
            if ([[obj objectForKey:@"assigneeWay"] integerValue] == 1) {
                _assigneeWay.text = @"定向转让";
            }else {
                _assigneeWay.text = @"竞价转让";
            }
            
            collectCapitalValue = [NSString stringWithFormat:@"%@", [obj objectForKey:@"collectCapital"]];
            myBidValue = [NSString stringWithFormat:@"%@", [obj objectForKey:@"offerPrice"]];
            hightestBidValue = [NSString stringWithFormat:@"%@", [obj objectForKey:@"hightestBid"]];
            
            _collectCapital.text = [NSString stringWithFormat:@"%@  元", [obj objectForKey:@"collectCapital"]];
            _hightestBid.text = [NSString stringWithFormat:@"%@  元", [obj objectForKey:@"hightestBid"]];
            _myBid.text = [NSString stringWithFormat:@"%@  元", [obj objectForKey:@"offerPrice"]];
        }else {
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];        
    }else{
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


@end
