//
//  AccountCenterOrderViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-6-23.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心排序
#import "AccountCenterOrderViewController.h"

#import "ColorTools.h"
#import "BarButtonItem.h"

#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "QCheckBox.h"
#import "AccountCenterOrder.h"
#import "FMDB.h"
#import "LeftMenuViewController.h"
#import "AccountCenterOrderCell.h"

#import "MailViewController.h"
#import "LoginViewController.h"



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
//#import "RechargeViewController.h"
#import "MyRechargeMYViewController.h"
#import "WithdrawalViewController.h"
#import "BankCardManageViewController.h"
#import "AccuontSafeViewController.h"
#import "MobilePassWordViewController.h"
#import "CreditLevelViewController.h"
#import "MyCollectionViewController.h"
#import "AttentionUserViewController.h"
#import "BlackListViewController.h"

@interface AccountCenterOrderViewController ()<SKSTableViewDelegate,UITableViewDataSource,UITableViewDelegate, HTTPClientDelegate>
{
   
    AccountCenterOrder *OrderModel;
    NSDictionary *OrderDic;
    NSMutableArray *OrderArr;
    FMDatabase *db;             //数据库
    NSString *IDstr;           //用户ID
    NSString *tablename;       //表名
  
}
@property (nonatomic, strong) SKSTableView *tableView;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) QCheckBox *check;
@property (nonatomic, strong) UIButton *quitBtn;

@end

@implementation AccountCenterOrderViewController
@synthesize valuedelegate = _valuedelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
    //读取数据库数据
    [self readdata];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    [self contents];
    
    IDstr = @"123";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"UserSetData.db"];
    db= [FMDatabase databaseWithPath:dbPath] ;
    DLOG(@"dapath is %@",dbPath);
    if (![db open]) {
        DLOG(@"数据库无法打开");
        return ;
    }
    //创建表
    if(![db tableExists:@"UserSet"])
    {
        [db executeUpdate:@"CREATE TABLE  UserSet (Id text, Tag integer, Checked integer)"];
        DLOG(@"表创建完成");
    }
}


/**
 读取数据库数据数据
 */
- (void)readdata
{
    
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
    DLOG(@"orderArr is %@",OrderArr);
    [_tableView reloadData];
}



/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Model
    OrderModel = [[AccountCenterOrder alloc] init];
    OrderArr  = [[NSMutableArray alloc] init];
    OrderDic = [[NSMutableDictionary alloc] init];
    
    //列表初始化
    _tableView = [[SKSTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.SKSTableViewDelegate = self;
    [self.tableView registerClass:[SKSTableViewCell class] forCellReuseIdentifier:@"SKSTableViewCell"];
    //_tableView.separatorColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
//    if (AppDelegateInstance.userInfo.isLogin) {
//        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
//        bottomView.backgroundColor = [UIColor whiteColor];
//        [self.view insertSubview:bottomView aboveSubview:_tableView];
//        
//        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _quitBtn.frame = CGRectMake(self.view.frame.size.width*0.5-50, 8,100, 25);
//        _quitBtn.backgroundColor = GreenColor;
//        [_quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//        [_quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        _quitBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
//        [_quitBtn.layer setMasksToBounds:YES];
//        [_quitBtn.layer setCornerRadius:3.0];
//        [_quitBtn addTarget:self action:@selector(quitBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:_quitBtn];
//    }
}

//初始化
- (NSArray *)contents
{
    if (!_contents) {
        _contents = @[@[@[@"借款子账户",@"借款账单"]],
                      @[@[@"理财子账户",@"理财账单", @"债权管理",@"理财统计",@"投标机器人"]],
                      @[@[@"账户管理",@"账户信息",@"资金记录",@"银行卡管理",@"账户安全",@"我的收藏"]]];
        
    }
    
    return _contents;
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"我的账户";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条完成按钮
    UIBarButtonItem *mailItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Loan_mail"] style:UIBarButtonItemStyleDone target:self action:@selector(mailClick)];
    mailItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:mailItem];
}


#pragma 返回按钮触发方法
- (void)backClick
{
    //代理传值
    if (_valuedelegate && [_valuedelegate respondsToSelector:@selector(SendValue:)]) {
        
        [_valuedelegate SendValue:OrderArr];
        
    }
    
    // DLOG(@"返回按钮");
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

#pragma 站内信触发方法
- (void)mailClick
{
    MailViewController *mailView = [[MailViewController alloc] init];
    [self.navigationController pushViewController:mailView animated:YES];
}

#pragma 退出按钮
- (void)quitBtnClick
{
    DLOG(@"退出按钮");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出账户" message:@"确定要退出此账户吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
    [alertView show];
    
}

#pragma mark - UITableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.contents[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.section][indexPath.row] count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SKSTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    cell.isExpandable = YES;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    
     AccountCenterOrderCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[AccountCenterOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    cell.imgView.image  = [UIImage imageNamed:[NSString stringWithFormat:@"order_icon_%ld%ld%ld", (long)indexPath.section, (long)indexPath.row,(long)indexPath.subRow]];
    
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell setTag:100+indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //单选按钮
    _check = [[QCheckBox alloc] initWithDelegate:self];
     [_check setImage:[UIImage imageNamed:@"order_icon_add"] forState:UIControlStateNormal];
     [_check setImage:[UIImage imageNamed:@"order_icon_added"] forState:UIControlStateSelected];
    _check.frame = CGRectMake(self.view.frame.size.width-30, 0, 50, 50);
    [_check setTag:[[NSString stringWithFormat:@"%ld%ld%ld", (long)indexPath.section, (long)indexPath.row,(long)indexPath.subRow] intValue]];
    for (int i=0; i<[OrderArr count]; i++) {
        AccountCenterOrder *model = [OrderArr objectAtIndex:i];
        if (_check.tag==model.Tag) {
            DLOG(@"111");
            model.name=cell.textLabel.text;
            DLOG(@"%@",model.name);
            [_check setImage:[UIImage imageNamed:@"order_icon_add"] forState:UIControlStateNormal];
            _check.selected=YES;
        }
    }
    [_check setTitle:nil forState:UIControlStateNormal];
    [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [cell addSubview:_check];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{


    DLOG(@"dkfdkjhdjkfhkjdhkjf is %d",[[NSString stringWithFormat:@"%ld%ld%ld", indexPath.section,indexPath.subRow,indexPath.row] intValue]);

    switch ([[NSString stringWithFormat:@"%ld%ld%ld", indexPath.section,indexPath.subRow,indexPath.row] intValue]) {
            
        case 1:
        {
            BorrowingBillViewController *BorrowingBillView = [[BorrowingBillViewController alloc] init];
            UINavigationController *NaVController1 = [[UINavigationController alloc] initWithRootViewController:BorrowingBillView];
            BorrowingBillView.curr = 1;
            [self presentViewController:NaVController1 animated:YES completion:nil];
        }
            break;
//        case 2:
//        {
//            
//            AuditingViewController *AuditingView = [[AuditingViewController alloc] init];
//            UINavigationController *NaVController2 = [[UINavigationController alloc] initWithRootViewController:AuditingView];
//            [self presentViewController:NaVController2 animated:YES completion:nil];
//            
//        }
//            break;
//        case 3:
//        {
//            
//            TenderViewController *TenderView = [[TenderViewController alloc] init];
//            UINavigationController *NaVController3 = [[UINavigationController alloc] initWithRootViewController:TenderView];
//            [self presentViewController:NaVController3 animated:YES completion:nil];
//            
//        }
//            break;
//        case 4:
//        {
//            PaymentViewController *PaymentView = [[PaymentViewController alloc] init];
//            UINavigationController *NaVController4 = [[UINavigationController alloc] initWithRootViewController:PaymentView];
//            [self presentViewController:NaVController4 animated:YES completion:nil];
//            
//        }
//            break;
//        case 5:
//        {
//            SuccessfullyViewController *SuccessfullyView = [[SuccessfullyViewController alloc] init];
//            UINavigationController *NaVController5 = [[UINavigationController alloc] initWithRootViewController:SuccessfullyView];
//            [self presentViewController:NaVController5 animated:YES completion:nil];
//            
//        }
//            break;
//        case 6:
//        {
//            
//            LiteratureAuditMainViewController *literatureAuditView = [[LiteratureAuditMainViewController alloc] rootViewController];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:literatureAuditView];
//            [navigationController setNavigationBarHidden:YES];
//            [self presentViewController:navigationController animated:YES completion:nil];
//            
//        }
//            break;
        case 101:
        {
            FinancialBillsViewController *FinancialBillsView = [[FinancialBillsViewController alloc] init];
            UINavigationController *NaVController7 = [[UINavigationController alloc] initWithRootViewController:FinancialBillsView];
            [self presentViewController:NaVController7 animated:YES completion:nil];
        }
            break;
//        case 102:
//        {
//            
//            BidRecordsViewController *BidRecordsView = [[BidRecordsViewController alloc] init];
//            UINavigationController *NaVController8 = [[UINavigationController alloc] initWithRootViewController:BidRecordsView];
//            [self presentViewController:NaVController8 animated:YES completion:nil];
//        }
//            break;
//        case 103:
//        {
//            FullScaleViewController  *FullScaleView = [[FullScaleViewController alloc] init];
//            UINavigationController *NaVController9 = [[UINavigationController alloc] initWithRootViewController:FullScaleView];
//            [self presentViewController:NaVController9 animated:YES completion:nil];
//        }
//            break;
//            
//        case 104:
//        {
//            CollectionViewController *CollectionView = [[CollectionViewController alloc] init];
//            UINavigationController *NaVController10 = [[UINavigationController alloc] initWithRootViewController:CollectionView];
//            [self presentViewController:NaVController10 animated:YES completion:nil];
//        }
//            break;
//        case 105:
//        {
//            
//            
//            CompletedViewController *CompletedView = [[CompletedViewController alloc] init];
//            UINavigationController *NaVController11 = [[UINavigationController alloc] initWithRootViewController:CompletedView];
//            [self presentViewController:NaVController11 animated:YES completion:nil];
//        }
//            break;
        case 102:
        {
            
            DebtManagementViewController *DebtManagementView = [[DebtManagementViewController alloc] init];
            UINavigationController *NaVController12 = [[UINavigationController alloc] initWithRootViewController:DebtManagementView];
            [self presentViewController:NaVController12 animated:YES completion:nil];
        }
            break;
        case 103:
        {
            
            FinancialStatisticsViewController *FinancialStatisticsView = [[FinancialStatisticsViewController alloc] init];
            UINavigationController *NaVController13 = [[UINavigationController alloc] initWithRootViewController:FinancialStatisticsView];
            [self presentViewController:NaVController13 animated:YES completion:nil];
        }
            break;
        case 104:
        {
            
            TenderRobotViewController *TenderRobotView = [[TenderRobotViewController alloc] init];
            UINavigationController *NaVController14 = [[UINavigationController alloc] initWithRootViewController:TenderRobotView];
            [self presentViewController:NaVController14 animated:YES completion:nil];
        }
            break;
        case 201:
        {
            AccountInfoViewController *AccountInfoView = [[AccountInfoViewController alloc] init];
            UINavigationController *NaVController15 = [[UINavigationController alloc] initWithRootViewController:AccountInfoView];
            [self presentViewController:NaVController15 animated:YES completion:nil];
        }
            break;
        case 202:
        {
            FundRecordViewController  *FundRecordView = [[FundRecordViewController alloc] init];
            UINavigationController *NaVController16 = [[UINavigationController alloc] initWithRootViewController: FundRecordView];
            [self presentViewController:NaVController16 animated:YES completion:nil];
        }
            break;
//        case 203:
//        {
//            
//            RechargeViewController *RechargeView = [[RechargeViewController alloc] init];
//            UINavigationController *NaVController17 = [[UINavigationController alloc] initWithRootViewController:RechargeView];
//            [self presentViewController:NaVController17 animated:YES completion:nil];
//        }
//            break;
//        case 204:
//        {
//            
//            WithdrawalViewController *WithdrawalView = [[WithdrawalViewController alloc] init];
//            UINavigationController *NaVController18 = [[UINavigationController alloc] initWithRootViewController:WithdrawalView];
//            [self presentViewController:NaVController18 animated:YES completion:nil];
//        }
//            break;
        case 203:
        {
            
            BankCardManageViewController *BankCardManageView = [[BankCardManageViewController alloc] init];
            UINavigationController *NaVController19 = [[UINavigationController alloc] initWithRootViewController:BankCardManageView];
            [self presentViewController:NaVController19 animated:YES completion:nil];
        }
            break;
        case 204:
        {
            AccuontSafeViewController *AccuontSafeView = [[AccuontSafeViewController alloc] init];
            UINavigationController *NaVController20 = [[UINavigationController alloc] initWithRootViewController:AccuontSafeView];
            [self presentViewController:NaVController20 animated:YES completion:nil];
        }
            break;
//        case 207:
//        {
//            CreditLevelViewController *CreditLevelView = [[CreditLevelViewController alloc] init];
//            UINavigationController *NaVController22 = [[UINavigationController alloc] initWithRootViewController:CreditLevelView];
//            [self presentViewController:NaVController22 animated:YES completion:nil];
//        }
//            break;
        case 205:
        {
            MyCollectionViewController *MyCollectionView = [[MyCollectionViewController alloc] init];
            UINavigationController *NaVController23 = [[UINavigationController alloc] initWithRootViewController:MyCollectionView];
            [self presentViewController:NaVController23 animated:YES completion:nil];
            
            
        }
            break;
//        case 209:
//        {
//            AttentionUserViewController *AttentionUserView = [[AttentionUserViewController alloc] init];
//            UINavigationController *NaVController24 = [[UINavigationController alloc] initWithRootViewController:AttentionUserView];
//            [self presentViewController:NaVController24 animated:YES completion:nil];
//            
//        }
//            break;
//        case 2010:
//        {
//            BlackListViewController *BlackListView = [[BlackListViewController alloc] init];
//            UINavigationController *NaVController25 = [[UINavigationController alloc] initWithRootViewController:BlackListView];
//            [self  presentViewController:NaVController25 animated:YES completion:nil];
//            
//            
//        } break;
//            
    }


}

#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    DLOG(@"did tap on CheckBox:%@ checked:%d", @(checkbox.tag), checked);
    NSInteger listcount = 0;
    if (checked ==1) {
        // 判断当前有没有，没有就插入
        if ([db open])
        {
            DLOG(@"开始插入数据");
            //插入数据
            DLOG(@"da is %@",db);
            NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", @"UserSet"];
            FMResultSet *rs = [db executeQuery:sqlstr];
            while ([rs next])
            {
                //表中的字段个数
                NSInteger  count = [rs intForColumn:@"count"];
                DLOG(@"TableItemCount %@", @(count));
                listcount = count;
            }
            
            if (listcount<8)
            {
                
                [db executeUpdate:@"INSERT INTO UserSet (Id,Tag,Checked) VALUES (?,?,?)",IDstr,[NSNumber numberWithInt:(int)checkbox.tag],[NSNumber numberWithInt:checked]];
               
            }
            
            else
            {
                UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"快捷方式设置已达最大数！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [AlertView show];
                checkbox.checked = 0;
                
                
            }
            
        }
        
    }
    
    else
    {
        if ([db open])
        {
            
            FMResultSet *rs = [db executeQuery:@"SELECT Tag FROM UserSet WHERE Id = ?",IDstr];
            while ([rs next])
            {
                
                if (checkbox.tag == [rs intForColumn:@"Tag"])
                {
                    
                    DLOG(@"删除字段Tag为 ：%d",[rs intForColumn:@"Tag"]);
                    //删除数据
                    [db executeUpdate:@"DELETE FROM UserSet WHERE Id = ? and Tag = ?",IDstr,[NSNumber numberWithInt:checkbox.tag]];
                }
                
            }
            
        }
        
    }
    
    //读取数据库数据
    [self readdata];
}

#pragma mark UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLOG(@"buttonIndex: %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
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
            [self dismissViewControllerAnimated:YES completion:^(){}];
        }
            
            break;
        case 1:
        
            break;
    }
}


@end
