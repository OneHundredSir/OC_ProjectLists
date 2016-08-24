//
//  MineViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MineViewController.h"
#import "ConfigViecontroller.h"


@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightBtn:@"pc_setting_40x40" andTitle:nil];
    
    self.rightBtnBlock = ^(UIButton *btn)
    {
        ConfigViecontroller *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfigViecontroller"];
        
        [self.navigationController pushViewController:vc animated:YES];
    };
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    [self setRightBtn:@"pc_setting" andTitle:nil];
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self isLoginSatueWith:nil];

}

#pragma mark 自己构造方法
#pragma mark 不带block的提示框
-(void)alertMetionWitDetail:(NSString *)detailTitle
{
    UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:@"提示" message: detailTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [AlertVC addAction:OKAciton];
    [self presentViewController:AlertVC animated:YES completion:nil];
}

#pragma mark 带block的提示框
-(void)alertMetionWitDetail:(NSString *)detailTitle andFinishBlock:(void(^)())block
{
    UIAlertController *AlertVC = [UIAlertController alertControllerWithTitle:@"提示" message: detailTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    UIAlertAction *quxiaoAciton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [AlertVC addAction:OKAciton];
    [AlertVC addAction:quxiaoAciton];
    [self presentViewController:AlertVC animated:YES completion:^{
        
    }];
}
@end
