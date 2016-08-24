//
//  WebViewController.m
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)setUrlStr:(NSString *)urlStr
{
    NSURL *url  = [NSURL URLWithString:urlStr];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_myWebView loadRequest:request];
    }else
    {
        //后面设置的网页版是原始网页
        [_myWebView loadHTMLString:urlStr baseURL:nil];
    }
    
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
