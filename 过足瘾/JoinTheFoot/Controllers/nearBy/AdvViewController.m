//
//  AdvViewController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "AdvViewController.h"

@interface AdvViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AdvViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftItem:nil 1
              OrImage:@"返回1"];
    __block AdvViewController *temself = self;
    self.leftAct = ^(UIButton *leftBtn){
    
        [temself.navigationController popViewControllerAnimated:YES];
    };
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.]]
    
    
}


@end
