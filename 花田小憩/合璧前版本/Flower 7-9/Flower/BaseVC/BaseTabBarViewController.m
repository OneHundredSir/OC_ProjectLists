//
//  BaseTabBarViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()




@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [UITabBar appearance].opaque =  YES;
    
    NSArray *nomalImgs = @[@"tb_0",@"tb_1",@"tb_2"] ;
        
    NSArray *selectedImgs = @[@"tb_0_selected",@"tb_1_selected",@"tb_2_selected"] ;
        
    NSArray *names = @[@"专题",@"商城",@"我的"];
        
    NSArray *controllersName = @[@"MainViewController",@"ShopViewController",@"MineViewController"];

    NSMutableArray *vcModels = [NSMutableArray array];
    for (int i=0; i<nomalImgs.count; i++)
    {
        BaseViewController *vc = [[NSClassFromString(controllersName[i]) alloc]init];
        vc.view.backgroundColor = mainColor;
        BaseNavigationViewController *navi = [[BaseNavigationViewController alloc]initWithRootViewController:vc];
        //设置底部的对象
        //设置不选中的图片
        [vc.tabBarItem setImage:[[UIImage imageNamed:nomalImgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //设置选中的图片
        [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setTitle:names[i]];
        //设置文字
        [vc setViewTitle:names[i]];
//        //设置顶部的东西
//        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
        
        [vcModels addObject:navi];
//        self.tabBar.barTintColor = [UIColor whiteColor];
    }
    self.viewControllers = vcModels;
}



@end
