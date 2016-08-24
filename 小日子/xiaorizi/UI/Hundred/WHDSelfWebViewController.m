//
//  WHDSelfWebViewController.m
//  xiaorizi
//
//  Created by HUN on 16/6/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDSelfWebViewController.h"


#define WebId @"http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles"
@interface WHDSelfWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WHDSelfWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:WebId]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
