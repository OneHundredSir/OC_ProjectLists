//
//  LeftMenuViewController.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "LeftMenuViewController.h"

#import "MenuToolItemView.h"
#import "MenuToolItem.h"
#import "ColorTools.h"


#import "MoreViewController.h"
#import "CalculatorViewController.h"

#import "LoginViewController.h"
#import "TwoCodeViewController.h"
#import "ChangeIconViewController.h"

#include "AccountCenterOrderViewController.h"
#import "SendValuedelegate.h"
#import "AccountCenterOrder.h"
#import "FMDB.h"

//各个账户中心子视图控制器
#import "BorrowingBillViewController.h"
#import "AuditingViewController.h"
#import "TenderViewController.h"
#import "PaymentViewController.h"
#import "SuccessfullyViewController.h"
#import "LiteratureAuditMainViewController.h"
#import "FinancialBillsViewController.h"
#import "BidRecordsViewController.h"
#import "FullScaleViewController.h"
#import "CollectionViewController.h"
#import "CompletedViewController.h"
#import "DebtManagementViewController.h"
#import "FinancialStatisticsViewController.h"
#import "TenderRobotViewController.h"
#import "AccountInfoViewController.h"
#import "FundRecordViewController.h"
#import "RechargeViewController.h"
#import "WithdrawalViewController.h"
#import "BankCardManageViewController.h"
#import "AccuontSafeViewController.h"
#import "MobilePassWordViewController.h"
#import "CreditLevelViewController.h"
#import "MyCollectionViewController.h"
#import "AttentionUserViewController.h"
#import "BlackListViewController.h"
#import "MailViewController.h"
// 资讯公告
#import "SpecialEventsViewController.h"

#import "UserInfo.h"
#import "Macros.h"

#import "UIImageView+WebCache.h"
#import "JoinVipViewController.h"

#import "UIButton+WebCache.h"

#import "CapitalViewController.h" //资金
#import "BillManageViewController.h" // 账单
#import "TradeRecordViewController.h"//交易记录
#import "IsiPhoneDevice.h"
@interface LeftMenuViewController ()<UITableViewDataSource , UITableViewDelegate, SendValuedelegate, HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;
    AccountCenterOrderViewController *AccountCenterOrderView;
    UINavigationController *NavigationController;
    UINavigationController *NavigationController1;
    NSArray *IconDataArr;
    NSMutableArray *menuArr;
    
    NSArray *_dataArr;
    
    BOOL isLogin;
    
    FMDatabase *db;             //数据库
    NSString *IDstr;  //ID
    NSMutableArray *OrderArr;
    MenuToolItem *bean;
    UIButton *collectionBtn1;
    
    
}

@property (nonatomic, strong) UIImageView *sideBarImageView;
// 信用等级
@property (nonatomic, strong) UIImageView *levelImage;
@property (nonatomic, strong) UIButton *creditRatingBtn;    // 信用额度 img
// VIP
@property (nonatomic, strong) UIButton *vipBtn;
@property (nonatomic, strong) UIButton *code;

@property (nonatomic, strong) UIButton *info;
@property (nonatomic, strong) UIButton *calculator;
@property (nonatomic, strong) UIButton *refreshBtn;    // 刷新

@property (nonatomic, strong) UIButton *loginView;
@property (nonatomic, strong) UILabel *loginUser;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UILabel *amount;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation LeftMenuViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //通知检测对象
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(update) name:@"update" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshBtnClick) name:@"update2" object:nil];
    
    [self initData];//初始化数据
    
    [self initView];//初始化视图
    
    
    if (AppDelegateInstance.userInfo != nil) {
        [self update];
    }
    
    

}


/**
 * 初始化数据
 */
- (void)initData
{
    
    isLogin = NO;
    
    IconDataArr = [[NSArray alloc] init];
//    OrderArr = [[NSMutableArray alloc] init];
//    menuArr = [[NSMutableArray alloc] init];
    DLOG(@"IcondataArr is %@",IconDataArr);
    IconDataArr = @[@"order_icon_001",@"order_icon_104",@"order_icon_204",@"nav_share",@"order_icon_206",@"Loan_mail",@"order_icon_201"];
    _dataArr = @[@"收益对账单",@"资金明细",@"权益转让",@"CPS推广",@"安全",@"站内信",@"资料"];//,@"银行卡",@"order_icon_205"
    

}

-(void)initinfo
{
    
    IDstr = @"123";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"UserSetData.db"];
    db= [FMDatabase databaseWithPath:dbPath] ;
    NSLog(@"dapath is %@",dbPath);
    if (![db open]) {
        NSLog(@"数据库无法打开");
        return ;
    }
    //创建表
    if(![db tableExists:@"UserSet"])
    {
        [db executeUpdate:@"CREATE TABLE  UserSet (Id text, Tag integer, Checked integer)"];
        NSLog(@"表创建完成");
    }
    
    
    [db executeUpdate:@"INSERT INTO UserSet (Id,Tag,Checked) VALUES (?,?,?)",IDstr,[NSNumber numberWithInt:201],[NSNumber numberWithInt:1]];
    [db executeUpdate:@"INSERT INTO UserSet (Id,Tag,Checked) VALUES (?,?,?)",IDstr,[NSNumber numberWithInt:101],[NSNumber numberWithInt:1]];
    
    [db executeUpdate:@"INSERT INTO UserSet (Id,Tag,Checked) VALUES (?,?,?)",IDstr,[NSNumber numberWithInt:1],[NSNumber numberWithInt:1]];
    
    
    
    //读取数据库数据
    [self readdata];
    
}

/**
 读取数据库数据数据
 */
- (void)readdata
{
    
//    IDstr = @"123";
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"UserSetData.db"];
//    db= [FMDatabase databaseWithPath:dbPath];
//    DLOG(@"dapath is %@",dbPath);
//    if (![db open]) {
//        DLOG(@"数据库无法打开");
//        return ;
//    }
    
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"UserSet"];
    while ([rs next])
    {
        
        NSInteger count = [rs intForColumn:@"count"];
        DLOG(@"isTableOK %ld", (long)count);
        
        if (0 == count)
        {
            
            DLOG(@"数据库中不存在表");
            
        }else {
    
            //返回全部查询结果
            FMResultSet *rs=[db executeQuery:@"SELECT * FROM UserSet WHERE Id = ?",IDstr];
            [OrderArr  removeAllObjects];
            while ([rs next])
            {
                DLOG(@"ID  %@ ********  标签  %@ *******  选中%@",[rs stringForColumn:@"Id"],[rs stringForColumn:@"Tag"],[rs stringForColumn:@"checked"]);
                AccountCenterOrder *orderModel = [[AccountCenterOrder alloc] init];
                orderModel.Id = [[rs stringForColumn:@"Id"] integerValue];
                orderModel.Tag = [[rs stringForColumn:@"Tag"] integerValue];
                orderModel.Checked = [[rs stringForColumn:@"checked"] integerValue];
                [OrderArr addObject:orderModel];
            }
            
            [rs close];
            //DLOG(@"orderArr is %@",OrderArr);
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"menu_collection_list" withExtension:@"plist"];
            NSArray *collections = [NSArray arrayWithContentsOfURL:url];
            for (int i = 0; i<[OrderArr count]; i++)
            {
                
                for (NSDictionary *item in collections)
                {
                    AccountCenterOrder *model = [OrderArr objectAtIndex:i];
                    if (model.Tag == [[item objectForKey:@"Tag"] integerValue])
                    {
                       // DLOG(@"model.tag is %d",model.Tag);
                        MenuToolItem *bean1 = [[MenuToolItem alloc] init];
                        bean1.name = [item objectForKey:@"name"];
                        bean1.icon = [item objectForKey:@"icon"];
                        bean1.Tag = [[item objectForKey:@"Tag"] intValue];
                        DLOG(@"bean.name and bean.icon is %@%@-----%d",bean1.name,bean1.icon,bean1.Tag);
                        [_collectionArrays insertObject:bean1 atIndex:0];
                        
                    }
                    
                }
                
            }
            [_collectionView reloadData];

        }
    }
}



/**
 初始化视图
 */
- (void)initView
{
    
    _sideBarImageView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _sideBarImageView.image = [UIImage imageNamed:@"sidebar_bg"];
    [self.view addSubview:_sideBarImageView];
    
    // logo图片
    _loginView = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginView.frame = CGRectMake(15, 50, 60, 60);
    [_loginView.layer setMasksToBounds:YES];
    [_loginView.layer setCornerRadius:30.0]; //设置矩形四个圆角半径
    [_loginView addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
    [_loginView setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.view addSubview:_loginView];// 登陆头像
    
    _loginUser =  [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_loginView.frame)+10, 200, 25)];
    _loginUser.textColor = GreenColor;
    _loginUser.textAlignment = NSTextAlignmentLeft;
    _loginUser.text = NSLocalizedString(@"Login_No", nil);
    _loginUser.font = [UIFont fontWithName:@"Arial" size:15.0];
    [self.view addSubview:_loginUser];//  请登录
    
    CGFloat rowHeight = MSHIGHT > 568 ? 45:40;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_loginUser.frame)+20, MSWIDTH - 100, rowHeight*_dataArr.count) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _info = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_tableView.frame)+5, 50, 30)];
    [_info setTitle:@"关于" forState:UIControlStateNormal];
    _info.titleLabel.textColor = [UIColor lightGrayColor];
    _info.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_info addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_info];// 关于

    
}


#pragma mark - 刷新
- (void)refreshBtnClick {
    
    DLOG(@"刷新");
    
    [self requestData];
}


#pragma mark SendValuedelegate  接收排序数组数据
-(void)SendValue:(NSArray *)valueArr
{

//    IconDataArr = valueArr;
//    DLOG(@"icondatARr is ----------------%@",valueArr);
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"menu_collection_list" withExtension:@"plist"];
//    NSArray *collections = [NSArray arrayWithContentsOfURL:url];
//    [_collectionArrays removeAllObjects];
//        for (int i = 0; i<[IconDataArr count]; i++)
//         {
//             AccountCenterOrder *model = [IconDataArr objectAtIndex:i];
//               for (NSDictionary *item1 in collections)
//               {
//                  
//                    
//                if (model.Tag == [[item1 objectForKey:@"Tag"] integerValue])
//                   {
//                        MenuToolItem *bean2 = [[MenuToolItem alloc] init];
//                        bean2.name = [item1 objectForKey:@"name"];
//                        bean2.icon = [item1 objectForKey:@"icon"];
//                        bean2.Tag = (int)[[item1 objectForKey:@"Tag"] integerValue];
//                        DLOG(@"bean.name and bean.icon is %@%@%d",bean2.name,bean2.icon,bean2.Tag);
//                       [_collectionArrays insertObject:bean2 atIndex:0];
//                
//                   }
//        
//             }
//        
//       }
//    [_collectionArrays addObject:bean];
//    [_collectionView reloadData];
}


#pragma mark UItableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArr count];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(MSHIGHT > 568)
    {
        return 45.0f;
    }else
        return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_dataArr objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:IconDataArr[indexPath.row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    switch (indexPath.row) {
       
        case 0:
            {
                BillManageViewController *billView = [[BillManageViewController alloc] init];
                UINavigationController *billmanageNV = [[UINavigationController alloc] initWithRootViewController:billView];
                 self.frostedViewController.contentViewController = billmanageNV;
//                [self presentViewController:NaVController1 animated:YES completion:nil];
                
                
            }
            break;
            
        case 1:
            {
        
                TradeRecordViewController  *tradeRecordView = [[TradeRecordViewController alloc] init];
                UINavigationController *tradeRecordNV = [[UINavigationController alloc] initWithRootViewController: tradeRecordView];
                   self.frostedViewController.contentViewController = tradeRecordNV;
//                [self presentViewController:NaVController16 animated:YES completion:nil];
        
            }
            
            break;
            
       /* case 2:
        {
            BankCardManageViewController *BankCardManageView = [[BankCardManageViewController alloc] init];
            UINavigationController *NaVController19 = [[UINavigationController alloc] initWithRootViewController:BankCardManageView];
            BankCardManageView.backTypeNum = 0;
            self.frostedViewController.contentViewController = NaVController19;
        
        }
            break;*/
            
        case 2:{
            
            DebtManagementViewController *DebtManagementView = [[DebtManagementViewController alloc] init];
            UINavigationController *NaVController12 = [[UINavigationController alloc] initWithRootViewController:DebtManagementView];
//            [self presentViewController:NaVController12 animated:YES completion:nil];
            self.frostedViewController.contentViewController = NaVController12;
        }
            
            break;
        case 3:
            {
                TwoCodeViewController *cpsVC = [[TwoCodeViewController alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cpsVC];
                cpsVC.backTypeNum = 0;
                 self.frostedViewController.contentViewController = navigationController;
            
            }
                break;
        case 4:
            {
                AccuontSafeViewController *AccuontSafeView = [[AccuontSafeViewController alloc] init];
                AccuontSafeView.backTypeNum = 0;
                UINavigationController *NaVController20 = [[UINavigationController alloc] initWithRootViewController:AccuontSafeView];
//                [self presentViewController:NaVController20 animated:YES completion:nil];
                self.frostedViewController.contentViewController = NaVController20;
            
            }
            break;
            
            
        case 5:
            {
            
                MailViewController *mailView = [[MailViewController alloc] init];
                UINavigationController *mailNvc = [[UINavigationController alloc] initWithRootViewController:mailView];
//                [self presentViewController:mailNvc animated:YES completion:nil];
                self.frostedViewController.contentViewController = mailNvc;
            
            }
            break;
            
        default:
        {
            AccountInfoViewController *accountInfoView = [[AccountInfoViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:accountInfoView];
            self.frostedViewController.contentViewController = navigationController;
          
            
        }
            break;
    }
    
    [self.frostedViewController hideMenuViewController];
}




#pragma mark
#pragma  mark 个人中心 更多 设置按钮
- (void)info:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    MoreViewController *moreView = [[MoreViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:moreView];
//    [self presentViewController:navigationController animated:YES completion:nil];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}


#pragma mark 点击计算器触发方法
- (void)calculator:(id)sender
{
    CalculatorViewController *calculatorVC = [[CalculatorViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:calculatorVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark 头像点击事件
- (void)login:(id)sender
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if(isLogin)
    {
        
        CapitalViewController *capitalView = [[CapitalViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:capitalView];
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
        
    }else {
        LoginViewController *calculatorVC = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:calculatorVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}


//通知中心触发方法

-(void)update
{
    DLOG(@"通知中心触发方法==============%@===========", AppDelegateInstance.userInfo.userImg);

    isLogin = [AppDelegateInstance.userInfo.isLogin boolValue];
    NSString *username = AppDelegateInstance.userInfo.userName;
    NSString *userImg = AppDelegateInstance.userInfo.userImg;
    NSString *creditRating = AppDelegateInstance.userInfo.userCreditRating;
    NSString *creditLimit = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.userLimit];
    NSString *isVip = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.isVipStatus];
//    NSString *accountAmount = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.accountAmount];
//    NSString *availableBalance = [NSString stringWithFormat:@"%@", AppDelegateInstance.userInfo.availableBalance];
    DLOG(@"userImg -> %@", userImg);
    DLOG(@"username -> %@", username);
    DLOG(@"creditRating -> %@", creditRating);
    DLOG(@"creditLimit -> %@", creditLimit);
    DLOG(@"isVip -> %@", isVip);
    DLOG(@"isLogin -> %d", (int)isLogin);
    
    
    if (!isLogin) {
        _loginUser.text = @"请登录";
        _amountLabel.text = @"";
        [_vipBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_loginView setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
        [_loginView setBackgroundImage:nil forState:UIControlStateHighlighted];
        _levelImage.image = nil;
        [_creditRatingBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_refreshBtn setImage:nil forState:UIControlStateNormal];
     
   
        
    }else {
       
        [_loginView sd_setBackgroundImageWithURL:[NSURL URLWithString:userImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
        
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        NSString* currentStr = [formatter stringFromDate:date];
        NSInteger timeNum = [currentStr  integerValue];
        DLOG(@"当前时间为%ld",timeNum);
//        _amountLabel.text = creditLimit;
        if(timeNum >= 0 &&  timeNum <= 9){
            _loginUser.text = [NSString stringWithFormat:@"早上好!  %@",username];
        }else if(timeNum >= 10 &&  timeNum <= 12){
        
            _loginUser.text = [NSString stringWithFormat:@"上午好!  %@",username];
        
        }else if(timeNum >= 13 &&  timeNum <= 18){
            
            _loginUser.text = [NSString stringWithFormat:@"下午好!  %@",username];
            
        }else if(timeNum >= 19 &&  timeNum <= 23){
            
            _loginUser.text = [NSString stringWithFormat:@"晚上好!  %@",username];
            
        }
        

    }
    
}

#pragma mark 二维码推广
- (void)codeClick:(id)sender
{
    TwoCodeViewController *calculatorVC = [[TwoCodeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:calculatorVC];
//    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)requestData {
    
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSString *name = [[AppDefaultUtil sharedInstance] getDefaultAccount];
        NSString *password = [[AppDefaultUtil sharedInstance] getDefaultUserPassword];
        NSString *deviceType = [[AppDefaultUtil sharedInstance] getdeviceType];
        
        [parameters setObject:@"1" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:name forKey:@"name"];
        [parameters setObject:password forKey:@"pwd"];
        if(AppDelegateInstance.userId !=nil && AppDelegateInstance.channelId != nil)
        {
            [parameters setObject:AppDelegateInstance.userId forKey:@"userId"];
            [parameters setObject:AppDelegateInstance.channelId forKey:@"channelId"];
            
        }else{
            
            [parameters setObject:@"" forKey:@"userId"];
            [parameters setObject:@"" forKey:@"channelId"];
            
        }
        [parameters setObject:deviceType forKey:@"deviceType"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
        
        UserInfo *usermodel = [[UserInfo alloc] init];
        if([[obj objectForKey:@"creditRating"] hasPrefix:@"http"])
        {
            usermodel.userCreditRating = [obj objectForKey:@"creditRating"];
            
        }else{
            usermodel.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
        }
        usermodel.userName = [obj objectForKey:@"username"];
        if ([[obj objectForKey:@"headImg"] hasPrefix:@"http"]) {
            
            usermodel.userImg = [NSString stringWithFormat:@"%@", [obj objectForKey:@"headImg"]];
        }else{
            
            usermodel.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
            
        }
        usermodel.userLimit = [obj objectForKey:@"creditLimit"];
        usermodel.isVipStatus = [obj objectForKey:@"vipStatus"];
        usermodel.userId = [obj objectForKey:@"id"];
        usermodel.isLogin = @"1";
        usermodel.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] floatValue]];
        usermodel.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] floatValue]];
        usermodel.isEmailStatus = [[obj objectForKey:@"hasEmail"] boolValue];
        usermodel.isMobileStatus = [[obj objectForKey:@"hasMobile"] boolValue];
        
        AppDelegateInstance.userInfo = usermodel;
        // 通知全局广播 LeftMenuController 修改UI操作
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:[obj objectForKey:@"username"]];
        
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        NSString* currentStr = [formatter stringFromDate:date];
        NSInteger timeNum = [currentStr  integerValue];
        DLOG(@"当前时间为%ld",timeNum);
        //        _amountLabel.text = creditLimit;
        if(timeNum >= 0 &&  timeNum <= 9){
            _loginUser.text = [NSString stringWithFormat:@"早上好!  %@",usermodel.userName];
        }else if(timeNum >= 10 &&  timeNum <= 12){
            
            _loginUser.text = [NSString stringWithFormat:@"上午好!  %@",usermodel.userName];
            
        }else if(timeNum >= 13 &&  timeNum <= 18){
            
            _loginUser.text = [NSString stringWithFormat:@"下午好!  %@",usermodel.userName];
            
        }else if(timeNum >= 19 &&  timeNum <= 23){
            
            _loginUser.text = [NSString stringWithFormat:@"晚上好!  %@",usermodel.userName];
            
        }
        

        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end
