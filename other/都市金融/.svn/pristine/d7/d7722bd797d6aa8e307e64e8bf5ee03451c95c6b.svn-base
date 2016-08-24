//
//  SettingViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  设置

#import "SettingViewController.h"

#import "ColorTools.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate,HTTPClientDelegate>
{
    NSArray *_titleArrays;
    NSInteger _billNum;
    NSInteger _investNum;
    NSInteger _activityNum;
    NSInteger _typeNum;
}
@property (nonatomic, copy) NSString *selectStr1;
@property (nonatomic, copy) NSString *selectStr2;
@property (nonatomic, copy) NSString *selectStr3;
@property (nonatomic, copy) NSString *allsetStr;
@property (nonatomic, strong) UITableView *settingTableView;
@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation SettingViewController

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
    
    // 初始化数据
    [self initDate];
    
    // 初始化试图
    [self initView];
}

- (void)initDate
{
    
    _billNum = 0;
    _investNum = 0;
    _activityNum = 0;
    _titleArrays = @[@"理财满标提醒",@"账单提醒",@"活动"];
    _selectStr1 = @"1";
    _selectStr2 = @"1";
    _selectStr3 = @"1";
    _typeNum = 0;
    [self requestData];
}

- (void)initView
{
    [self initNavigationBar];
    
    [self initContent];
}


-(void)requestData
{
    _typeNum = 0;
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
    }else
    {
        
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取推送设置
    [parameters setObject:@"156" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
     [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
        
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
   
    }
}




- (void)initNavigationBar
{
    self.title = @"设置";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor=[UIColor whiteColor];
    backItem.tag = 1;
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initContent
{
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -2, self.view.frame.size.width, 260) style:UITableViewStyleGrouped];
    
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.scrollEnabled = NO;
    
    [_settingTableView setBackgroundColor:KblackgroundColor];
    
    [self.view addSubview:_settingTableView];
}


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dataDic = obj;
    DLOG(@"fhjdfjkdfjk is %@",dataDic);
    if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (_typeNum == 0) {
            _investNum = [[dataDic objectForKey:@"investPush"] integerValue];
            _billNum = [[dataDic objectForKey:@"billPush"] integerValue];
            _activityNum = [[dataDic objectForKey:@"activityPush"] integerValue];
            _selectStr1 = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"investPush"]];
            _selectStr2 = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"billPush"]];
            _selectStr3 = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"activityPush"]];
            [self changeOnOff];
        }else{
        
         [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [dataDic objectForKey:@"msg"]]];
        
        }
 
        
    }else if ([[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        
        DLOG(@"返回失败===========%@",[dataDic objectForKey:@"msg"]);
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [dataDic objectForKey:@"msg"]]];
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

- (void)changeOnOff
{
    UITableViewCell *cell12 = (UITableViewCell *)[_settingTableView viewWithTag:101];
    UITableViewCell *cell13 = (UITableViewCell *)[_settingTableView viewWithTag:102];
    UITableViewCell *cell14 = (UITableViewCell *)[_settingTableView viewWithTag:103];
    
    UISwitch *switchON12  = (UISwitch*)[cell12.contentView viewWithTag:101];
    UISwitch *switchON13  = (UISwitch*)[cell13.contentView viewWithTag:102];
    UISwitch *switchON14  = (UISwitch*)[cell14.contentView viewWithTag:103];
    
    
    if (switchON12.tag ==101 && _investNum ==1 ) {
        [switchON12 setOn:YES];
    }else if (switchON12.tag ==101 && _investNum ==0 ){
        
        [switchON12 setOn:NO];
    }
   
    if (switchON13.tag ==102 && _billNum ==1 ) {
        [switchON13 setOn:YES];
    }else if (switchON13.tag ==102 && _billNum ==0 ){
        
        [switchON13 setOn:NO];
    }

    if (switchON14.tag ==103 && _activityNum ==1 ) {
        [switchON14 setOn:YES];
    }else if (switchON14.tag ==103 && _activityNum ==0 ){
        
        [switchON14 setOn:NO];
    }
    
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _titleArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingCellId = @"settingCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingCellId];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = _titleArrays[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    UISwitch *switchON = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 4, 30, 24)];
    switchON.tag = indexPath.section + 101;
    [switchON addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:switchON];
    cell.tag = indexPath.section+101;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DLOG(@"cell title -> %@", _titleArrays[indexPath.section]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)switchAction:(UISwitch *)switchV
{
  
    _typeNum = 1;
 
    UITableViewCell *cell12 = (UITableViewCell *)[_settingTableView viewWithTag:101];
    UITableViewCell *cell13 = (UITableViewCell *)[_settingTableView viewWithTag:102];
    UITableViewCell *cell14 = (UITableViewCell *)[_settingTableView viewWithTag:103];
    
    UISwitch *switchON12  = (UISwitch*)[cell12.contentView viewWithTag:101];
    UISwitch *switchON13  = (UISwitch*)[cell13.contentView viewWithTag:102];
    UISwitch *switchON14  = (UISwitch*)[cell14.contentView viewWithTag:103];
    switch (switchV.tag) {
        case 100:
           {
               if (switchV.isOn) {
                   _selectStr1 = @"1";
                   _selectStr2 = @"1";
                   _selectStr3 = @"1";
                  
                  [switchON12 setOn:YES animated:YES];
                  [switchON13 setOn:YES animated:YES];
                  [switchON14 setOn:YES animated:YES];
                
               }else{
               
                   _selectStr1 = @"0";
                   _selectStr2 = @"0";
                   _selectStr3 = @"0";
                   [switchON12 setOn:NO animated:YES];
                   [switchON13 setOn:NO animated:YES];
                   [switchON14 setOn:NO animated:YES];
               
               }
    
           }
            break;
        case 101:
        {
            _selectStr1 = [NSString stringWithFormat:@"%d",switchV.isOn];
//            if (!switchV.isOn) {
//                [switchON11 setOn:NO animated:YES];
//            }
        }
            break;
        case 102:
        {
            _selectStr2 = [NSString stringWithFormat:@"%d",switchV.isOn];
//            if (!switchV.isOn) {
//                [switchON11 setOn:NO animated:YES];
//            }
        }
            break;
        case 103:
        {
            _selectStr3 = [NSString stringWithFormat:@"%d",switchV.isOn];
//            if (!switchV.isOn) {
//                [switchON11 setOn:NO animated:YES];
//            }
        }
            break;
    }
    DLOG(@"%@,%@,%@",_selectStr1,_selectStr2,_selectStr3);
    
    //发送推送设置
    if (AppDelegateInstance.userInfo == nil) {
          [ReLogin outTheTimeRelogin:self];
    }else
    {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //获取推送设置
        [parameters setObject:@"155" forKey:@"OPT"];
        [parameters setObject:@"" forKey:@"body"];
        [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
        [parameters setObject:_selectStr1 forKey:@"investPush"];
        [parameters setObject:_selectStr2 forKey:@"billPush"];
        [parameters setObject:_selectStr3 forKey:@"activityPush"];
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
        
    }
}

@end
