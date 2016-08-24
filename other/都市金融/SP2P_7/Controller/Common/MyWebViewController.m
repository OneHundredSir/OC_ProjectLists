//
//  MyWebViewController.m
//  SP2P_6.1
//
//  Created by EIMS-IOS on 15-2-28.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//
//资金托管
#import "MyWebViewController.h"
#import "ReleaseSuccessViewController.h"

@interface MyWebViewController ()<UIWebViewDelegate>

@property (nonatomic,assign)BOOL isFirst;

@property (nonatomic,copy) NSString *error;

@property (nonatomic,copy) NSString *htmlStr;

@property (nonatomic,copy) NSString *bidNo;

@property (nonatomic,strong) UIWebView *myWebView;

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
    if (self.type != TYPE_RECHARGE) {
        _myWebView.scalesPageToFit = YES;
    }
    
    [self.view addSubview:_myWebView];

    [_myWebView loadHTMLString:self.html baseURL:nil];
}

#pragma mark - UIWebViewDelegate
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
    //转NSUTF8
    NSString  *currentURL = [curURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"currentURL is %@",currentURL);
    
    if (currentURL == nil) {
        return;
    }
    if ([currentURL rangeOfString:@"appCallBack"].location != NSNotFound || [currentURL rangeOfString:@"/front/PaymentAction"].location != NSNotFound || [currentURL rangeOfString:@"/payment/payErrorInfo"].location != NSNotFound ||[currentURL rangeOfString:@"/payment/chinapnr"].location != NSNotFound) {
        

        NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
        NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:lJs];
        
        //隐藏html文本
        [webView loadHTMLString:nil baseURL:nil];
        
        
        // 去掉所有标签
        NSString *jsonString = [self filterHTML:htmlString];;
        
        if ([jsonString rangeOfString:@"{"].location != NSNotFound) {
            //匹配分别得到{}的下标
            NSRange start = [jsonString rangeOfString:@"{"];
            NSRange end = [jsonString rangeOfString:@"}"];
            //截取范围类的字符串
            jsonString = [jsonString substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
            DLOG(@"截取的值为：%@",jsonString);
        }
        
        // 转字典
        NSDictionary *dict = [self dictionaryWithJsonString:jsonString];
        
        
        if (![[dict objectForKey:@"msg"] isEqual:[NSNull null]]){
            
            NSString *message = (dict[@"msg"] == nil || [dict[@"msg"] length]==0)? @"操作成功":dict[@"msg"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
        }else{
            [SVProgressHUD showErrorWithStatus:@"服务器错误，请稍候再试"];
        }

    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   //1.开户 2.充值 3.投标 4.提现 5.绑定银行卡 6.债权转让竞拍确认（竟价）7.债权转让竞拍确认受让（定向）8.还款
    //if ([self.type isEqualToString:@"1"])
    if (self.type  == TYPE_AUCTION)//开户
    {
        UINavigationController *nav = self.navigationController.viewControllers[self.level];
        [self.navigationController popToViewController:nav animated:YES];
    }
    else if(self.type == TYPE_RECHARGE)//充值
    {
        UIViewController *nav = self.navigationController.viewControllers[self.level];
        [nav setValue:@YES forKey:@"rechargeSuccess"];
        [self.navigationController popToViewController:nav animated:NO];
        
    }
    else if(self.type == TYPE_INVEST)//投标
    {
         //列表刷新通知
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"investRefresh" object:nil];
        self.navigationController.navigationBarHidden = NO;
        UINavigationController *nav = self.navigationController.viewControllers[self.level];
        [self.navigationController popToViewController:nav animated:YES];
    }
    
    else if(self.type == TYPE_WITHDRAW)//提现
    {
        UIViewController *nav = self.navigationController.viewControllers[self.level];
        [self.navigationController popToViewController:nav animated:YES];
    }
    
    else if(self.type == TYPE_BINDING_CARD)//绑卡
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if (self.type == TYPE_AUCTION || self.type == TYPE_TRANSFER)
    {// 接受转让（竟价）6（定向）7
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"transferRefresh" object:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            UIViewController *nav = self.navigationController.viewControllers[self.level];
            [self.navigationController popToViewController:nav animated:YES];
        });
    }else if (self.type == TYPE_REPAYMENT)//还款
    {
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"BorrowingBillSuccess" object:self];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }else if (self.type == TYPE_DailyErningTransferIn)//日利宝转入
    {
        UIViewController *nav = self.navigationController.viewControllers[self.level];
        [self.navigationController popToViewController:nav animated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];   
    }
}

#pragma mark - 字符串转字典
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


#pragma mark - 去掉html字符串中所有标签
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


#pragma mark - 返回按钮触发方法
- (void)backClick
{
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
