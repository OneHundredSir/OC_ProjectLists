//
//  WHDDiscoverViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDiscoverViewController.h"

@interface WHDDiscoverViewController ()

@end

@implementation WHDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewTitle:@"发现"];
//    self.tabBarController.tabBar.hidden = YES;//只是测试用的
}

- (IBAction)sendBtn:(UIButton *)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"半透背景"] forState:UIControlStateHighlighted];
    switch (sender.tag) {
        case 10://邀请
            NSLog(@"邀请");
            break;
        case 11://摇一摇
            NSLog(@"摇一摇");
            break;
        case 12://每日一笑
            NSLog(@"每日一笑");
            break;
        case 13://商城
            NSLog(@"商城");
            break;
        case 14://1元欢乐购
            NSLog(@"1元欢乐购");
            break;
        default:
            break;
    }
}


@end
