//
//  MainTabBarController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadTabBarIcons];//加载tabbar的items
    [self loadGester];//加载策划手势
    [self setShowDow];//设置 tabbar的view的阴影
    
  
   
}

- (void)setShowDow
{
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.view.layer.shadowOffset = CGSizeMake(-2, -2.5);//阴影方向
    self.view.layer.shadowOpacity = 0.7;//阴影透明度

}

- (void)loadGester
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];//创建一个滑动手势
    
    self.pan = pan;
    
    [self.view addGestureRecognizer:pan];//将手势添加到 tabbar的View上


}
- (void)_loadTabBarIcons
{

    [self.tabBar setBarTintColor:[UIColor whiteColor]];
//    [self.tabBar setTranslucent:NO];
    NSArray *images_nol = @[@"附近1.jpg",@"消息1.jpg",@"发现1.jpg",@"钱包1.jpg"];
    NSArray *images_sel = @[@"附近2.jpg",@"消息2.jpg",@"发现2.jpg",@"钱包2.jpg"];
    NSArray *titles = @[@"附近",@"消息",@"发现",@"钱包"];
    NSArray *ctlNames = @[@"NearViewController",@"MessageViewController",@"DiscoverViewController",@"WalletViewController"];
    
    NSMutableArray *ctls = [NSMutableArray array];
    
    for (int i = 0; i < images_nol.count; i ++)
    {
        
        UIViewController *cv =  [[NSClassFromString(ctlNames[i]) alloc] init];//通过类名 得到改类， 然后 allco 创建该类的对象 是一个 控制器
        
        
//        通过控制器构造 导航控制器
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:cv];
//        得到当前的 普通状态下的图片
        UIImage *nol_old = [UIImage imageNamed:images_nol[i]];
//        得到选中状态下的图片
        UIImage *nlo_sel = [UIImage imageNamed:images_sel[i]];
//        设置tabbarItem的图片 （图片调用UIImageRenderingModeAlwaysOriginal 这个方法 放置图片失去原来的效果（蓝白））
        [cv.tabBarItem setImage:[nol_old  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [cv.tabBarItem setSelectedImage:[nlo_sel  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        设置tabBaritem的title
        [cv.tabBarItem setTitle:titles[i]];
//        设置title的颜色（点中）
        [cv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : mian_color} forState:UIControlStateSelected];
        [ctls addObject:nav];
        
    }
//    设置当前tabbar的控制器
    self.viewControllers = ctls;
    

}

- (void)panAction:(UIPanGestureRecognizer *)pan
{

    if (pan && pan.state == UIGestureRecognizerStateBegan)//判断手势刚开始滑动
    {
        
        CGPoint point = [pan translationInView:self.view];
       
        if (point.x > 0)
        {
            
            [UIView animateWithDuration:0.35 animations:^{
                
                self.view.center = CGPointMake(kScreen_W * 1.15, kScreen_H / 2);
                self.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                
                
            }completion:^(BOOL finished) {
               personPage(YES)
            }];
            
            
        }else
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.center = CGPointMake(kScreen_W / 2, kScreen_H / 2);
                self.view.transform = CGAffineTransformIdentity;
                
                
            } completion:^(BOOL finished) {
                
               personPage(NO)
            }];
        
        }
        
    }else if(pan == nil)
    {
    
        if (self.view.center.x == kScreen_W / 2)
        {
            
            [UIView animateWithDuration:0.35 animations:^{
                
                self.view.center = CGPointMake(kScreen_W * 1.15, kScreen_H / 2);
                self.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                
                
            }completion:^(BOOL finished) {
                personPage(YES)
            }];
            
            
        }else
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.center = CGPointMake(kScreen_W / 2, kScreen_H / 2);
                self.view.transform = CGAffineTransformIdentity;
                
                
            } completion:^(BOOL finished) {
                
                personPage(NO)
            }];
            
        }

    
    
    }
    
    
    


}

@end
