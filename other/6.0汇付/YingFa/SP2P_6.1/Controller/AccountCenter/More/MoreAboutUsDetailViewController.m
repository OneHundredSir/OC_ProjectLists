//
//  MoreAboutUsDetailViewController.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-16.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreAboutUsDetailViewController.h"

#import "MoreAboutUs.h"
#import "MoreAboutUsTableViewCell.h"

#import "ColorTools.h"

@interface MoreAboutUsDetailViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;
}

@property (nonatomic , strong) UITableView *aboutUsTableView;
@property (nonatomic , strong) UIWebView *aboutUsWeb;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation MoreAboutUsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
//    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 初始化数据
 */
- (void)initWithName:(NSString *)name optId:(NSString *)optId
{
    self.title = name;
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
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[NSString stringWithFormat:@"%@", optId] forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
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
    
    [self initContentView];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
//    self.title = @"更多";
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
    _aboutUsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _aboutUsTableView.delegate = self;
    _aboutUsTableView.dataSource = self;
    
    [_aboutUsTableView setBackgroundColor:KblackgroundColor];
    
//    [self.view addSubview:_aboutUsTableView];
    
    _aboutUsWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _aboutUsWeb.backgroundColor = KblackgroundColor;
    
    [self.view addSubview:_aboutUsWeb];
}

#pragma mark - UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectionArrays.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    MoreAboutUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[MoreAboutUsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    MoreAboutUs *aboutus = [_collectionArrays objectAtIndex:indexPath.row];
    
    cell.imgView.image = [UIImage imageNamed:aboutus.icon];
    cell.titleLabel.text = aboutus.name;
    cell.desLabel.text = aboutus.des;
    
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
            
           content = [content stringByReplacingOccurrencesOfString:@"src=\"/" withString:[NSString stringWithFormat:@"src=\"%@/", Baseurl]]; //替换相对路径
            
            [_aboutUsWeb loadHTMLString:content baseURL:[NSURL URLWithString:Baseurl]];
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
