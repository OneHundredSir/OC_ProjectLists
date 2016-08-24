//
//  WHDTarbbarController.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDTarbbarController.h"
#import "WHDNavigationController.h"

#import "ClassesVC.h"
#import "ExperienceVC.h"
#import "FoundShopVC.h"
#import "MineVC.h"

@interface WHDTarbbarController ()

@end

@implementation WHDTarbbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置统一的tincolor
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    self.tabBar.translucent=NO;
    
    [self initWithController];

}

-(void)initWithController
{
    //设置4个界面
    ClassesVC *clasvc=[[ClassesVC alloc]init];
    ExperienceVC *experience=[ExperienceVC new];
    FoundShopVC *found=[FoundShopVC new];
    MineVC *mine=[MineVC new];
    
    WHDNavigationController *nv1=[[WHDNavigationController alloc]initWithRootViewController:found];
    WHDNavigationController *nv2=[[WHDNavigationController alloc]initWithRootViewController:experience];
    WHDNavigationController *nv3=[[WHDNavigationController alloc]initWithRootViewController:clasvc];
    WHDNavigationController *nv4=[[WHDNavigationController alloc]initWithRootViewController:mine];
    
    //把图片加进去.可以待会可以考虑优化一下，封装一下
    found.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"探店" image:[UIImage imageNamed:@"recommendation_1"] selectedImage:[UIImage imageNamed:@"recommendation_2"]];
    experience.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"体验" image:[UIImage imageNamed:@"broadwood_1"] selectedImage:[UIImage imageNamed:@"broadwood_2"]];
    clasvc.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"分类" image:[UIImage imageNamed:@"classification_1"] selectedImage:[UIImage imageNamed:@"classification_2"]];
    mine.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"my_1"] selectedImage:[UIImage imageNamed:@"my_2"]];
    
    //把界面加入tabar
    self.viewControllers=@[nv1,nv2,nv3,nv4];
    
    
}
//重新构造方法
//-(UIViewController *)makeViewcontrollerWithClass:(id)myClass and


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
