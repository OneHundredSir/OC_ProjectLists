//
//  WHDWalletViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDWalletViewController.h"

#import "CardWalletViewController.h"
#import "DetailViewController.h"
#import "HappyShopViewController.h"


@interface WHDWalletViewController ()

@end

@implementation WHDWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewTitle:@"钱包"];
    [self setRightBtn:nil andTitle:nil];
}


#pragma mark 按钮跳转事件

- (IBAction)showBtn:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (tag == 10)//中间积分
    {
        DetailViewController *vc = [[DetailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag == 13)//券包
    {
        CardWalletViewController *vc = [[CardWalletViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag == 14)
    {
        HappyShopViewController *vc = [[HappyShopViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
