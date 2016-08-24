//
//  PartnersViewController.m
//  SP2P_7
//
//  Created by kiu on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  合作伙伴

#import "PartnersViewController.h"

#import "ColorTools.h"
#import "MoreAboutUs.h"
#import "PartenersTableViewCell.h"
#import "PartnersWebViewController.h"

@interface PartnersViewController ()<UITableViewDelegate, UITableViewDataSource, HTTPClientDelegate>
{
    NSMutableArray *_collectionArrays;
}
@property (nonatomic , strong)  UITableView *aboutUsTableView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation PartnersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"合作伙伴";
    
    // 初始化视图
    [self initView];
}

// 加载页面之前 加载数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"126" forKey:@"OPT"];
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
    
    [self.view addSubview:_aboutUsTableView];
}

#pragma mark - UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectionArrays.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingcell = @"settingCell";
    
    PartenersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingcell];
    
    if (cell == nil) {
        cell = [[PartenersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingcell];
    }
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    DLOG(@"_collectionArrays -> %lu", (unsigned long)_collectionArrays.count);
    
    MoreAboutUs *aboutus = [_collectionArrays objectAtIndex:indexPath.row];
    
    cell.contentMode = UIViewContentModeTop;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = aboutus.name;
    cell.desLabel.text = aboutus.des;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:aboutus.icon]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreAboutUs *aboutus = [_collectionArrays objectAtIndex:indexPath.row];
    DLOG(@"name - %@", aboutus.name);
    DLOG(@"des - %@", aboutus.des);
    DLOG(@"icon - %@", aboutus.icon);
    
    PartnersWebViewController *webView = [[PartnersWebViewController alloc] init];
    webView.url = aboutus.url;
    webView.titleName = aboutus.name;
    
    [self.navigationController pushViewController:webView animated:YES];
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
        
//        DLOG(@"返回成功  list -> %@",[obj objectForKey:@"list"]);
        
        _collectionArrays =[[NSMutableArray alloc] init];
        
        NSArray *collections = [obj objectForKey:@"list"];
        for (NSDictionary *item in collections) {
            MoreAboutUs *bean = [[MoreAboutUs alloc] init];
            bean.name = [item objectForKey:@"name"];
            bean.des =  [item objectForKey:@"description"];
            bean.url = [item objectForKey:@"url"];
            
            if ( [[item objectForKey:@"image_filename"] hasPrefix:@"http"]) {
                
                bean.icon =  [NSString stringWithFormat:@"%@", [item objectForKey:@"image_filename"]];
            }else{
                
                bean.icon =  [NSString stringWithFormat:@"%@%@", Baseurl, [item objectForKey:@"image_filename"]];
            }
            
            [_collectionArrays addObject:bean];
            
            DLOG(@"bean.icon -> %@", bean.icon);
        }
        [_aboutUsTableView reloadData];
        
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
