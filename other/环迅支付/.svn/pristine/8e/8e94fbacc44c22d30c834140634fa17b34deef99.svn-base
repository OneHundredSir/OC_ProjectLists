//
//  MyWebViewController.m
//  SP2P_6.1
//
//  Created by EIMS-IOS on 15-2-28.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "MyWebViewController.h"
#import "ReleaseSuccessViewController.h"

@interface MyWebViewController ()<UIWebViewDelegate>

@property (nonatomic,assign)BOOL isFirst;

@property (nonatomic,copy)NSString *error;

@property (nonatomic,copy)NSString *htmlStr;

@property (nonatomic,copy)NSString *bidNo;

@property (nonatomic,strong)UIWebView *myWebView;

@property (nonatomic,strong) NSMutableArray *requireArr;

@end


@implementation MyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.isFirst = NO;
     [self initWebView];
    
    
}

- (void)initWebView
{
    _requireArr = [[NSMutableArray alloc] init];
    
    [self initNavigationBar];
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _myWebView.backgroundColor = KblackgroundColor;
    _myWebView.delegate = self;
    _myWebView.scalesPageToFit = YES;
    [self.view addSubview:_myWebView];

    [_myWebView loadHTMLString:self.html baseURL:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.isFirst)
    {
        [SVProgressHUD show];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    
    self.isFirst = YES;
 
    //监听URL
    NSString *curURL = [webView  stringByEvaluatingJavaScriptFromString:@"document.location.href"];
       
    NSString  *currentURL = [curURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"currentURL is %@",currentURL);
    
    if ([currentURL rangeOfString:@"appCallBack"].location != NSNotFound || [currentURL rangeOfString:@"/front/PaymentAction"].location != NSNotFound||[currentURL rangeOfString:@"returnRepayment"].location != NSNotFound) {
      
        NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
        NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:lJs];
        
    //    [webView loadHTMLString:nil baseURL:nil];
        

        // 去掉所有标签
        NSString *jsonString = [self filterHTML:htmlString];
        
        // 转字典
        NSDictionary *dict = [self dictionaryWithJsonString:jsonString];
        
        if ([self.type isEqualToString:@"5"]) {
            
            self.error = [NSString stringWithFormat:@"%@",[dict objectForKey:@"error"]];
            if ([self.error isEqualToString:@"-1"]) {
                // 设置奖励
                if ([dict objectForKey:@"htmlParam"]) {
                    
                    self.htmlStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"htmlParam"]];
                    
                }
                else
                {
                    // 不设置奖励
                    self.bidNo = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bidNo"]];
                    if ([dict objectForKey:@"requiredAuditItem"]!= nil && ![[dict objectForKey:@"requiredAuditItem"] isEqual:[NSNull null]])
                    {
                        for (NSDictionary *item  in [dict objectForKey:@"requiredAuditItem"]) {
                            [_requireArr addObject:[[item objectForKey:@"auditItem"] objectForKey:@"name"]];
                        }
                        
                    }
                }
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
            }
        }
       
        webView.hidden = YES;
        NSLog(@"dict = %@",dict);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息提示" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   //1.开户 2.充值 3.投标 4.提现 5.发布借款(有两次页面跳转) 6.申请vip付款 7.提交审核资料付款
   //8.债权转让竞拍确认（竟价） 9.债权转让竞拍确认受让（定向）10.还款
    
    if ([self.type isEqualToString:@"1"])//开户
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.type isEqualToString:@"2"])//充值
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeUpdate" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if([self.type isEqualToString:@"3"])//投标
    {
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"complete" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if([self.type isEqualToString:@"4"])//提现
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeUpdate" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
   
    else if ([self.type isEqualToString:@"5"])//发标 和 支付奖励
    {
 
        if ([alertView.message rangeOfString:@"成功"].location != NSNotFound)
        {
            if (self.htmlStr == nil)//发标成功后返回根视图
            {
                //发布成功页面
                ReleaseSuccessViewController *ReleaseSuccessView = [[ReleaseSuccessViewController alloc] init];
                ReleaseSuccessView.idString = self.bidNo;
                ReleaseSuccessView.amountString = self.amountString;
                ReleaseSuccessView.titleString =  self.titleString;
                ReleaseSuccessView.stateString = @"等待平台审核中...";
                ReleaseSuccessView.requiredArr = _requireArr;
                [self.navigationController pushViewController:ReleaseSuccessView animated:NO];
            }else{//支付奖励成功后加载发布借款html
                
                [_myWebView loadHTMLString:self.htmlStr baseURL:nil];
                self.htmlStr = nil;
            }
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    else if ([self.type isEqualToString:@"6"])//申请vip
    {
        if ([alertView.message rangeOfString:@"成功"].location != NSNotFound)
        {
            AppDelegateInstance.userInfo.isVipStatus = @"1";
            //通知检测对象
            [[NSNotificationCenter defaultCenter]postNotificationName:@"update" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{}];
            });
    
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    else if ([self.type isEqualToString:@"10"])//还款
    {
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"BorrowingBillSuccess" object:self];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });

    }
    else if ([self.type isEqualToString:@"8"]||[self.type isEqualToString:@"9"])
    {// 接受转让

        [[NSNotificationCenter defaultCenter] postNotificationName:@"markupSuccess" object:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }
    else{//7
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadComplete" object:self];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


//字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 去掉html字符串中所有标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return html;
}




/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"资金托管";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    if([self.type isEqualToString:@"2"])//充值
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeUpdate" object:nil];
        
    }
    // NSLog(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [_myWebView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
