//
//  WHDDiscoverViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDiscoverViewController.h"
#import "WHDFindViewController.h"
#import "WHDYaoViewController.h"
#import "WHDFunViewController.h"
#import "WHDDiscoverShopViewController.h"
#import "WHDDiscoverHappyShopViewController.h"


@interface WHDDiscoverViewController ()
@property(nonatomic,strong)NSArray *classArr;
@property(nonatomic,strong)NSArray *classNameArr;

@end

@implementation WHDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewTitle:@"发现"];
//    self.tabBarController.tabBar.hidden = YES;//只是测试用的
    self.classArr = @[@"WHDFindViewController",
                      @"WHDYaoViewController",
                      @"WHDFunViewController",
                      @"WHDDiscoverShopViewController",
                      @"WHDDiscoverHappyShopViewController"];
    self.classNameArr = @[@"邀请朋友",
                          @"摇一摇",
                          @"每日一笑",
                          @"商城",
                          @"1元欢乐购"];
    
}

- (IBAction)sendBtn:(UIButton *)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"半透背景"] forState:UIControlStateHighlighted];
    NSInteger index = sender.tag - 10;
    
    [self whdPushVC:self.classArr[index] andName:self.classNameArr[index] isPush:YES];
  
    
    //没有下面的事情了.
#if 0
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
#endif
}




@end
