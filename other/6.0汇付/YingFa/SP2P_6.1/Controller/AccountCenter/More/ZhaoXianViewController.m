//
//  ZhaoXianViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  招贤纳士

#import "ZhaoXianViewController.h"

#import "MoreAboutUs.h"
#import "ColorTools.h"


@interface ZhaoXianViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;
}

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic , strong)  UITableView *aboutUsTableView;
@property (nonatomic , strong)  UIWebView *hiringWebView;

@property (nonatomic,copy) NSString *_urlHtml;

@end

@implementation ZhaoXianViewController

// 加载页面之前 加载数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"125" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
       
    }
     [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"招贤纳士";
    _collectionArrays =[[NSMutableArray alloc] init];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"aboutus_list" withExtension:@"plist"];
    NSArray *collections = [NSArray arrayWithContentsOfURL:url];
    for (NSDictionary *item in collections) {
        MoreAboutUs *bean = [[MoreAboutUs alloc] init];
        bean.name = [item objectForKey:@"name"];
        bean.des =  [item objectForKey:@"des"];
        bean.icon =  [item objectForKey:@"icon"];
        [_collectionArrays addObject:bean];
    }
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initView
{
    [self initNavigationBar];
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:16.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tag = 1;
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initContentView{
//    _aboutUsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    
//    _aboutUsTableView.delegate = self;
//    _aboutUsTableView.dataSource = self;
//    
//    [_aboutUsTableView setBackgroundColor:KblackgroundColor];
//    
//    [self.view addSubview:_aboutUsTableView];
    
    _hiringWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _hiringWebView.backgroundColor = KblackgroundColor;
    [self.view addSubview:_hiringWebView];
}

#pragma mark - UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectionArrays.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    // 设置 cell 右边的箭头
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    MoreAboutUs *aboutus = [_collectionArrays objectAtIndex:indexPath.row];
    
    cell.contentMode = UIViewContentModeTop;
    
    cell.textLabel.text = aboutus.name;
    cell.detailTextLabel.text = aboutus.des;
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreAboutUs *aboutus = [_collectionArrays objectAtIndex:indexPath.row];
    DLOG(@"name - %@", aboutus.name);
    DLOG(@"des - %@", aboutus.des);
    DLOG(@"icon - %@", aboutus.icon);
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
        
        DLOG(@"返回成功  msg -> %@",[obj objectForKey:@"msg"]);
        
        NSString *content = nil;
        
        id object = [obj objectForKey:@"content"];
        
        if ([object isKindOfClass:[NSArray class]]) {
            
            if ([object count] != 0) {
                
                content = object[0];
            }
        }else{
            
            content = object;
        }
        
        if (![object isEqual:[NSNull null]] && content != nil) {
            
            [_hiringWebView loadHTMLString:content baseURL:[NSURL URLWithString:Baseurl]];
        }
        
        
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
