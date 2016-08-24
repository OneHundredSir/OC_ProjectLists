//
//  AJTransferController.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJTransferController.h"
#import "AJTransferCellDailyEarning.h"
#import "AJTransfer.h"
#import "AJDailyManagerHeaderData.h"

@interface AJTransferController ()<HTTPClientDelegate, UITextFieldDelegate>
@property (nonatomic, strong) AJTransfer *cellData;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property (nonatomic, strong) AJDailyManagerHeaderData *lastViewheaderData;
@property (nonatomic, assign) NSInteger level;
@end

@implementation AJTransferController

- (NetWorkClient *)requestClient
{
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    return _requestClient;
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    // 拦截外部设置
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;}
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (AJTransfer *)cellData
{
    if (_cellData == nil) {
        _cellData = [[AJTransfer alloc]init];
    }
    return _cellData;
}
- (void)initData
{
    if ([self.title isEqualToString:@"转出"]) {
        self.cellData.cash = @"转出金额:";
        self.cellData.cashFieldHolder = @"请输入转出金额";
//        _cellData.cashFieldText = @"0.00";
        self.cellData.usableText = [NSString stringWithFormat:@"您的可转出总金额是：%@元",self.lastViewheaderData.balance];
//        _cellData.usable = @"0.00元";
        self.cellData.commitbtnText = @"提交";
//        self.cellData.tipsText = @"1、当转出金额≤平台显示可转出额度时，可进行实时提取。\n2、一般根据实际情况，平台将通过数据分析后进行调配，使可转出额度大于用户实际所需提取额度。\n3、今日可转出额度为10，000.00元";
        self.cellData.tipsText = self.lastViewheaderData.transfer_rule;
       
    }else{// 转入
        self.cellData.cash = @"金额:";
        self.cellData.cashFieldHolder = @"请输入转入金额";
//        self.cellData.cashFieldText = @"0.00";
        self.cellData.usableText = @"可用余额";
        self.cellData.usable = [NSString stringWithFormat:@"%@元",self.lastViewheaderData.usablebalance];
        self.cellData.commitbtnText = self.title;
//        self.cellData.tipsText = @"1、最小购买金额10000.00元；\n2、日利宝按比例设有单人加入额度上限（100，000.00元），购买金额需≤担任加入额度上限。";
        self.cellData.tipsText = self.lastViewheaderData.invest_rule;

    }
}


#pragma  mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    AJTransferCellDailyEarning *cell = [AJTransferCellDailyEarning cellWithTableView:tableView btnClickBlock:^(NSString *money) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if ([weakSelf.cellData.commitbtnText isEqualToString:@"提交"]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"###,##0.00;"];
            CGFloat balance =  [[formatter numberFromString:self.lastViewheaderData.balance] doubleValue];
            if ([money floatValue] <=  0.f ) {
                    [SVProgressHUD showErrorWithStatus:@"请输入大于0的金额"];
                }else if ([money floatValue] > balance){
                     [SVProgressHUD showErrorWithStatus:@"您输入的金额过大"];
            }else{
                [parameters setObject:@"" forKey:@"body"];
                parameters[@"OPT"] = @"182";
                parameters[@"userId"] = AppDelegateInstance.userInfo.userId ;
                parameters[@"tranferAmount"] = money;
                [weakSelf.requestClient requestGet:@"app/services" withParameters:parameters];
//                  [weakSelf.requestClient requestGet:weakSelf withParameters:parameters payType:45 navLevel:[self.navigationController.viewControllers indexOfObject:self]-1];
            }
            
        }else{ // 转入
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"###,##0.00;"];
            CGFloat usablebalance =  [[formatter numberFromString:self.lastViewheaderData.usablebalance] doubleValue];
              CGFloat min_invest_amount =  [[formatter numberFromString:self.lastViewheaderData.min_invest_amount] doubleValue];
            
            if ([money floatValue] < min_invest_amount ) {
                [SVProgressHUD showErrorWithStatus:@"小于最小转入金额"];
            }else if ([money floatValue] >usablebalance){
                [SVProgressHUD showErrorWithStatus:@"大于最大转入金额"];
            }else{
                [parameters setObject:@"" forKey:@"body"];
                parameters[@"OPT"] = @"181";
                parameters[@"userId"] = AppDelegateInstance.userInfo.userId ;
                parameters[@"incomeAmount"] = money;
//                [weakSelf.requestClient requestGet:@"app/services" withParameters:parameters];
                [weakSelf.requestClient requestGet:weakSelf withParameters:parameters payType:TYPE_DailyErningTransferIn navLevel:[self.navigationController.viewControllers indexOfObject:self]-1];
            }
        }
    }];
    cell.cashField.delegate = self;
    cell.aAJTransfer = self.cellData;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 列寬
    CGFloat contentWidth = tableView.bounds.size.width - 2*50.f/2;
    CGSize size = [self.cellData.tipsText boundingRectWithSize:CGSizeMake(contentWidth, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}context:nil].size;
    // 用何種字體進行顯示
    return 524.f/2 + size.height + 58.f/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f/2;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//}
#pragma mark - HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{}

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    NSDictionary *dics = obj;
//    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    [self.view endEditing:YES];
    
    if ([self.cellData.commitbtnText isEqualToString:@"提交"] && [obj[@"error"] integerValue]== -1) {// 转出时要求跳回到之前页面
        [self.navigationController popViewControllerAnimated:YES];
        
    }
//    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
//        
//        
//    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
//        
//        [ReLogin outTheTimeRelogin:self];
//        
//    }else {
//        // 服务器返回数据异常
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
//    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"网络异常"];
}

// 无可用的网络
-(void) networkError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

@end
