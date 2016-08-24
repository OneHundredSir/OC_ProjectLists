//
//  bankNameViewController.m
//  SP2P_7
//
//  Created by Jerry on 15/7/9.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "bankNameViewController.h"

@interface bankNameViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>

@property (nonatomic, strong) UITableView *bankTableView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic,strong) NSArray *bankNameArr;
@end

@implementation bankNameViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 初始化数据
    [self initData];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"167" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // 初始化视图
    [self initView];
    // Do any additional setup after loading the view.
   
}
/**
 * 初始化数据
 */
- (void)initData
{
    
    _bankNameArr = @[];
    
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    _bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MSHIGHT) style:UITableViewStylePlain];
    _bankTableView.delegate = self;
    _bankTableView.dataSource = self;
    [_bankTableView setBackgroundColor:KblackgroundColor];
    [self.view addSubview:_bankTableView];
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"选择银行";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
        _bankNameArr = [dics objectForKey:@"bankCodeNames"];
        
        [self.bankTableView reloadData];
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    
}

// 无可用的网络
-(void) networkError
{
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    
}

#pragma mark 返回按钮
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
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
    static NSString *settingcell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingcell];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *bankNameStr = @"银行";
    if (self.bankNameArr.count) {
        cell.textLabel.text = self.bankNameArr[indexPath.row];
        bankNameStr  = self.bankNameArr[indexPath.row];
    }

    
    if([bankNameStr rangeOfString:@"中国银行"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/BOC"];
    }
    else if([bankNameStr rangeOfString:@"工商"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/ICBC"];
        
    } else if([bankNameStr rangeOfString:@"建设"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/CCB"];
        
    } else if([bankNameStr rangeOfString:@"农业银行"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/ABC"];
        
    } else if([bankNameStr rangeOfString:@"交通"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/COMM"];
        
    } else if([bankNameStr rangeOfString:@"招商"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/CMB"];
        
    } else if([bankNameStr rangeOfString:@"光大"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/CEB"];
        
    } else if([bankNameStr rangeOfString:@"平安"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/SPABANK"];
        
    } else if([bankNameStr rangeOfString:@"兴业"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/CIB"];
        
    } else if([bankNameStr rangeOfString:@"浦发"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/SPDB"];
        
    } else if([bankNameStr rangeOfString:@"中信"].location !=NSNotFound)
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/CITIC"];
        
    } else
    {
        cell.imageView.image = [UIImage imageNamed:@"BankcardIcon.bundle/bankDefaultIcon"];
        
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DLOG(@"name - %@", self.bankNameArr[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *numStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBank" object:numStr];
    [self.navigationController popViewControllerAnimated:YES];
}




@end
